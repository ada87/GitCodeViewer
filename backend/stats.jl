# Julia sample for syntax highlighting
module RepoAnalytics

using Dates
using Statistics

struct Repo
    id::Int
    name::String
    language::String
    stars::Int
    updated::Date
end

const REPOS = [
    Repo(1, "code-reader", "julia", 1300, Date(2026, 3, 1)),
    Repo(2, "gitcode-viewer", "typescript", 980, Date(2026, 3, 3)),
    Repo(3, "mobile-kit", "kotlin", 640, Date(2026, 2, 27)),
    Repo(4, "data-tools", "python", 820, Date(2026, 2, 25)),
]

normalize_name(name::String) = lowercase(strip(name))

function score(repo::Repo)
    base = repo.stars * 0.8
    bonus = length(repo.name) * 2
    stale_penalty = repo.updated < Date(2026, 2, 28) ? -25 : 15
    return round(Int, base + bonus + stale_penalty)
end

function by_language(repos::Vector{Repo})
    grouped = Dict{String, Vector{Repo}}()
    for repo in repos
        if !haskey(grouped, repo.language)
            grouped[repo.language] = Repo[]
        end
        push!(grouped[repo.language], repo)
    end
    return grouped
end

function language_stats(repos::Vector{Repo})
    rows = NamedTuple[]
    grouped = by_language(repos)
    for (lang, items) in grouped
        total_stars = sum(r -> r.stars, items)
        avg_score = mean(score.(items))
        push!(rows, (language=lang, count=length(items), stars=total_stars, avg=avg_score))
    end
    sort(rows, by = x -> (-x.stars, -x.count))
end

function search_repos(repos::Vector{Repo}, q::String)
    qn = normalize_name(q)
    filter(repos) do r
        contains(normalize_name(r.name), qn) || contains(lowercase(r.language), qn)
    end
end

function top_repo(repos::Vector{Repo})
    first(sort(repos, by = r -> -r.stars))
end

function print_report(repos::Vector{Repo})
    println("=== Julia Repo Report ===")
    println("Total repos: ", length(repos))
    println("Mean stars: ", round(mean(map(r -> r.stars, repos)); digits=2))
    println("Max stars: ", maximum(map(r -> r.stars, repos)))
    println("Min stars: ", minimum(map(r -> r.stars, repos)))
    println()

    for row in language_stats(repos)
        println("$(row.language): count=$(row.count), stars=$(row.stars), avg=$(round(row.avg; digits=2))")
    end

    best = top_repo(repos)
    println()
    println("Top repo: $(best.name) ($(best.stars))")
end

function transform_a(x::Int)
    y = x + 10
    return (step="a", input=x, output=y, ok=(y > x))
end

function transform_b(x::Int)
    y = x * 2
    return (step="b", input=x, output=y, ok=(y >= x))
end

function transform_c(x::Int)
    y = x * 3 - 1
    return (step="c", input=x, output=y, ok=true)
end

function transform_d(x::Int)
    y = div(x + 7, 2)
    return (step="d", input=x, output=y, ok=true)
end

function transform_e(x::Int)
    y = mod(x + 17, 5)
    return (step="e", input=x, output=y, ok=true)
end

function run_demo()
    print_report(REPOS)
    filtered = search_repos(REPOS, "code")
    println("Filtered count: ", length(filtered))
    println(transform_a(8))
    println(transform_b(8))
    println(transform_c(8))
    println(transform_d(8))
    println(transform_e(8))
end

run_demo()

end # module RepoAnalytics

