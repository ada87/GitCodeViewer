#!/usr/bin/env bash
set -euo pipefail

# ============ Configuration ============

readonly APP_NAME="gitcode-api"
readonly REGISTRY="registry.example.com/gitcode"
readonly HEALTH_ENDPOINT="/healthz"
readonly MAX_RETRIES=30
readonly RETRY_INTERVAL=5

# ============ Color Output ============

RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
NC='\\033[0m'

info()  { echo -e "\${GREEN}[INFO]\${NC} \${1}"; }
warn()  { echo -e "\${YELLOW}[WARN]\${NC} \${1}"; }
error() { echo -e "\${RED}[ERROR]\${NC} \${1}" >&2; }

# ============ Argument Parsing ============

VERSION=""
ENVIRONMENT="staging"
DRY_RUN=false

usage() {
    cat <<EOF
Usage: \${0##*/} [OPTIONS]

Options:
  -v VERSION     Version tag (required)
  -e ENV         Environment: staging|production (default: staging)
  -d             Dry run mode
  -h             Show this help
EOF
}

while getopts "v:e:dh" opt; do
    case \${opt} in
        v) VERSION="\${OPTARG}" ;;
        e) ENVIRONMENT="\${OPTARG}" ;;
        d) DRY_RUN=true ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

[[ -z "\${VERSION}" ]] && { error "Version is required (-v)"; usage; exit 1; }

# ============ Cleanup Trap ============

cleanup() {
    local exit_code=0
    if [[ \${exit_code} -ne 0 ]]; then
        error "Deploy failed with exit code \${exit_code}"
    fi
    rm -f /tmp/\${APP_NAME}-deploy-*.tmp
    info "Cleanup complete"
}
trap cleanup EXIT

# ============ Docker Build & Push ============

build_and_push() {
    local image="\${REGISTRY}/\${APP_NAME}:\${VERSION}"
    info "Building \${image}"

    if [[ "\${DRY_RUN}" == true ]]; then
        info "[DRY RUN] Would build and push \${image}"
        return 0
    fi

    docker build \
        --build-arg VERSION="\${VERSION}" \
        --build-arg BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        --tag "\${image}" \
        --tag "\${REGISTRY}/\${APP_NAME}:latest" \
        --file Dockerfile \
        .

    docker push "\${image}"
    docker push "\${REGISTRY}/\${APP_NAME}:latest"
    info "Pushed \${image}"
}

# ============ Health Check ============

wait_for_healthy() {
    local url="\${1}"
    local attempt=0

    info "Waiting for \${url} to be healthy..."
    while (( attempt < MAX_RETRIES )); do
        if curl -sf "\${url}\${HEALTH_ENDPOINT}" > /dev/null 2>&1; then
            info "Service is healthy after \${attempt} attempts"
            return 0
        fi
        (( attempt++ ))
        warn "Attempt \${attempt}/\${MAX_RETRIES} - retrying in \${RETRY_INTERVAL}s"
        sleep "\${RETRY_INTERVAL}"
    done

    error "Service failed to become healthy after \${MAX_RETRIES} attempts"
    return 1
}

# ============ Main ============

main() {
    info "Deploying \${APP_NAME} v\${VERSION} to \${ENVIRONMENT}"
    info "Dry run: \${DRY_RUN}"

    build_and_push

    if [[ "\${DRY_RUN}" == true ]]; then
        info "[DRY RUN] Skipping deploy and health check"
        exit 0
    fi

    kubectl set image "deployment/\${APP_NAME}" \
        "\${APP_NAME}=\${REGISTRY}/\${APP_NAME}:\${VERSION}" \
        --namespace="\${ENVIRONMENT}"

    kubectl rollout status "deployment/\${APP_NAME}" \
        --namespace="\${ENVIRONMENT}" \
        --timeout=300s

    wait_for_healthy "https://\${APP_NAME}.\${ENVIRONMENT}.example.com"

    info "Deploy complete: \${APP_NAME} v\${VERSION} -> \${ENVIRONMENT}"
}

main
