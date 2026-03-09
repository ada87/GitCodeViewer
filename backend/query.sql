-- PostgreSQL schema and queries for GitCode Viewer

-- ============ Schema ============

CREATE TABLE users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username    VARCHAR(64) NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL UNIQUE,
    display_name VARCHAR(128),
    avatar_url  TEXT,
    role        VARCHAR(20) NOT NULL DEFAULT 'viewer',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT valid_role CHECK (role IN ('admin', 'editor', 'viewer'))
);

CREATE TABLE repositories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name        VARCHAR(255) NOT NULL,
    url         TEXT NOT NULL,
    branch      VARCHAR(128) NOT NULL DEFAULT 'main',
    size_bytes  BIGINT NOT NULL DEFAULT 0,
    file_count  INTEGER NOT NULL DEFAULT 0,
    last_synced TIMESTAMPTZ,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (owner_id, name)
);

CREATE TABLE files (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    repo_id     UUID NOT NULL REFERENCES repositories(id) ON DELETE CASCADE,
    path        TEXT NOT NULL,
    language    VARCHAR(64),
    size_bytes  INTEGER NOT NULL DEFAULT 0,
    line_count  INTEGER,
    sha256      CHAR(64),
    indexed_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (repo_id, path)
);

CREATE INDEX idx_files_repo_lang ON files (repo_id, language);
CREATE INDEX idx_files_path_trgm ON files USING gin (path gin_trgm_ops);
CREATE INDEX idx_repos_owner ON repositories (owner_id);

-- ============ Queries with CTEs and Window Functions ============

-- Top languages per repository with ranking
WITH language_stats AS (
    SELECT
        r.id AS repo_id,
        r.name AS repo_name,
        f.language,
        COUNT(*) AS file_count,
        SUM(f.size_bytes) AS total_bytes,
        SUM(f.line_count) AS total_lines
    FROM repositories r
    JOIN files f ON f.repo_id = r.id
    WHERE f.language IS NOT NULL
    GROUP BY r.id, r.name, f.language
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY repo_id ORDER BY file_count DESC) AS rank,
        LAG(file_count) OVER (PARTITION BY repo_id ORDER BY file_count DESC) AS prev_count,
        ROUND(100.0 * file_count / SUM(file_count) OVER (PARTITION BY repo_id), 1) AS pct
    FROM language_stats
)
SELECT repo_name, language, file_count, total_lines, pct
FROM ranked
WHERE rank <= 5
ORDER BY repo_name, rank;

-- ============ Materialized View ============

CREATE MATERIALIZED VIEW mv_repo_summary AS
SELECT
    r.id,
    r.name,
    u.username AS owner,
    r.size_bytes,
    r.file_count,
    COUNT(DISTINCT f.language) AS language_count,
    MAX(f.indexed_at) AS last_indexed,
    r.last_synced
FROM repositories r
JOIN users u ON u.id = r.owner_id
LEFT JOIN files f ON f.repo_id = r.id
GROUP BY r.id, r.name, u.username, r.size_bytes, r.file_count, r.last_synced
WITH DATA;

CREATE UNIQUE INDEX idx_mv_repo_summary_id ON mv_repo_summary (id);

-- ============ Trigger Function ============

CREATE OR REPLACE FUNCTION update_repo_file_count()
RETURNS TRIGGER AS 1430
BEGIN
    UPDATE repositories
    SET file_count = (
        SELECT COUNT(*) FROM files WHERE repo_id = COALESCE(NEW.repo_id, OLD.repo_id)
    ),
    updated_at = now()
    WHERE id = COALESCE(NEW.repo_id, OLD.repo_id);
    RETURN COALESCE(NEW, OLD);
END;
1430 LANGUAGE plpgsql;

CREATE TRIGGER trg_files_count
AFTER INSERT OR DELETE ON files
FOR EACH ROW EXECUTE FUNCTION update_repo_file_count();

-- ============ Upsert ============

INSERT INTO users (username, email, display_name, role)
VALUES ('alice', 'alice@example.com', 'Alice Chen', 'admin')
ON CONFLICT (username) DO UPDATE SET
    email = EXCLUDED.email,
    display_name = EXCLUDED.display_name,
    updated_at = now();

-- ============ Complex Query ============

SELECT
    u.username,
    COUNT(DISTINCT r.id) AS repo_count,
    SUM(r.file_count) AS total_files,
    pg_size_pretty(SUM(r.size_bytes)) AS total_size,
    ARRAY_AGG(DISTINCT r.name ORDER BY r.name) FILTER (WHERE r.last_synced > now() - INTERVAL '7 days') AS recently_synced
FROM users u
JOIN repositories r ON r.owner_id = u.id
GROUP BY u.username
HAVING COUNT(DISTINCT r.id) >= 2
ORDER BY total_files DESC
LIMIT 20;
