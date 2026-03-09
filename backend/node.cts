import fs = require('node:fs')
import path = require('node:path')

type RepoRecord = {
  id: string
  owner: string
  name: string
  defaultBranch: string
  updatedAt: string
  stars: number
  languages: string[]
  tags: string[]
}

type RepoIndex = {
  byOwner: Map<string, RepoRecord[]>
  featured: RepoRecord[]
}

function readJsonFile<T>(filePath: string): T {
  return JSON.parse(fs.readFileSync(filePath, 'utf8')) as T
}

function normalizeRecord(row: Partial<RepoRecord>): RepoRecord {
  const owner = String(row.owner ?? 'unknown')
  const name = String(row.name ?? 'repo')

  return {
    id: String(row.id ?? `${owner}/${name}`),
    owner,
    name,
    defaultBranch: String(row.defaultBranch ?? 'main'),
    updatedAt: String(row.updatedAt ?? new Date(0).toISOString()),
    stars: Number(row.stars ?? 0),
    languages: Array.isArray(row.languages) ? row.languages.map((item) => String(item)) : [],
    tags: Array.isArray(row.tags) ? row.tags.map((item) => String(item)) : [],
  }
}

function listSnapshotFiles(rootDir: string): string[] {
  return fs
    .readdirSync(rootDir, { withFileTypes: true })
    .filter((entry) => entry.isFile() && entry.name.endsWith('.json'))
    .map((entry) => path.join(rootDir, entry.name))
    .sort((left, right) => left.localeCompare(right))
}

function loadSnapshots(rootDir: string): RepoRecord[] {
  const files = listSnapshotFiles(rootDir)
  const records: RepoRecord[] = []

  for (const filePath of files) {
    const rows = readJsonFile<Partial<RepoRecord>[]>(filePath)
    if (!Array.isArray(rows)) {
      continue
    }

    for (const row of rows) {
      records.push(normalizeRecord(row))
    }
  }

  return records.sort((left, right) => right.updatedAt.localeCompare(left.updatedAt))
}

function buildIndex(records: RepoRecord[]): RepoIndex {
  const byOwner = new Map<string, RepoRecord[]>()

  for (const record of records) {
    const bucket = byOwner.get(record.owner) ?? []
    bucket.push(record)
    byOwner.set(record.owner, bucket)
  }

  for (const bucket of byOwner.values()) {
    bucket.sort((left, right) => left.name.localeCompare(right.name))
  }

  const featured = records
    .filter((record) => record.tags.includes('featured') || record.stars >= 500)
    .sort((left, right) => right.stars - left.stars)
    .slice(0, 12)

  return { byOwner, featured }
}

function toMarkdown(index: RepoIndex): string {
  const lines: string[] = []
  lines.push('# Repo Snapshot')
  lines.push('')
  lines.push('## Featured')
  lines.push('')

  for (const record of index.featured) {
    const summary = `${record.owner}/${record.name} (${record.defaultBranch})`
    const langs = record.languages.join(', ') || 'n/a'
    lines.push(`- ${summary} - ${record.stars} stars - ${langs}`)
  }

  lines.push('')
  lines.push('## Owners')
  lines.push('')

  for (const [owner, repos] of [...index.byOwner.entries()].sort((a, b) => a[0].localeCompare(b[0]))) {
    lines.push(`### ${owner}`)
    for (const repo of repos) {
      lines.push(`- ${repo.name} (${repo.defaultBranch}) updated ${repo.updatedAt}`)
    }
    lines.push('')
  }

  return lines.join('\n')
}

function writeReport(snapshotDir: string, outputFile: string): string {
  const records = loadSnapshots(snapshotDir)
  const report = toMarkdown(buildIndex(records))
  fs.writeFileSync(outputFile, report)
  return outputFile
}

if (require.main === module) {
  const [snapshotDir = '.', outputFile = path.resolve('repo-report.md')] = process.argv.slice(2)
  const target = writeReport(snapshotDir, outputFile)
  console.log(`wrote ${target}`)
}

export = {
  loadSnapshots,
  buildIndex,
  toMarkdown,
  writeReport,
}
