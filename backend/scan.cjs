const fs = require('node:fs')
const path = require('node:path')

const SAMPLE_DIR = path.resolve('D:/xdnote/GitCodeViewer')

function readFiles(dir) {
  return fs.readdirSync(dir)
    .filter((name) => fs.statSync(path.join(dir, name)).isFile())
    .map((name) => ({
      name,
      ext: path.extname(name).slice(1).toLowerCase(),
      fullPath: path.join(dir, name),
    }))
}

function toSummary(entry) {
  const text = fs.readFileSync(entry.fullPath, 'utf8')
  const lines = text.split(/\r?\n/).length
  const bytes = Buffer.byteLength(text)
  return {
    name: entry.name,
    ext: entry.ext || '(none)',
    lines,
    bytes,
  }
}

function groupByExtension(rows) {
  return rows.reduce((map, row) => {
    if (!map.has(row.ext)) {
      map.set(row.ext, [])
    }
    map.get(row.ext).push(row)
    return map
  }, new Map())
}

function formatRow(row) {
  const lineText = String(row.lines).padStart(4, ' ')
  const byteText = String(row.bytes).padStart(6, ' ')
  return `${lineText} lines  ${byteText} bytes  ${row.name}`
}

function printReport(groups) {
  const exts = [...groups.keys()].sort()
  for (const ext of exts) {
    const rows = groups.get(ext).sort((a, b) => a.name.localeCompare(b.name))
    console.log(`\n[${ext}] ${rows.length} file(s)`)
    for (const row of rows.slice(0, 4)) {
      console.log(`  ${formatRow(row)}`)
    }
    if (rows.length > 4) {
      console.log(`  ... ${rows.length - 4} more`) 
    }
  }
}

function findRangeViolations(rows) {
  return rows.filter((row) => row.lines < 80 || row.lines > 200)
}

function main() {
  const summaries = readFiles(SAMPLE_DIR).map(toSummary)
  const groups = groupByExtension(summaries)
  const violations = findRangeViolations(summaries)

  console.log(`Scanned ${summaries.length} sample files in ${SAMPLE_DIR}`)
  console.log(`Found ${groups.size} unique extensions`)

  if (violations.length) {
    console.log('\nLine range violations:')
    for (const row of violations) {
      console.log(`  ${row.name} -> ${row.lines} lines`)
    }
  } else {
    console.log('\nAll files are inside the 80-200 line target range.')
  }

  printReport(groups)
}

if (require.main === module) {
  main()
}

module.exports = {
  readFiles,
  toSummary,
  groupByExtension,
  findRangeViolations,
}
