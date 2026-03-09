const aliasMap = new Map([
  ['cts', 'typescript'],
  ['ets', 'typescript'],
  ['mts', 'typescript'],
  ['json5', 'json'],
  ['jsonc', 'json'],
  ['liquid', 'html'],
])

const packageMap = new Map([
  ['typescript', '@codemirror/lang-javascript'],
  ['json', '@codemirror/lang-json'],
  ['html', '@codemirror/lang-html'],
  ['jinja', '@codemirror/legacy-modes'],
  ['toml', '@codemirror/legacy-modes'],
])

export function normalizeExtension(ext) {
  const clean = String(ext || '').trim().toLowerCase().replace(/^\./, '')
  return aliasMap.get(clean) ?? clean
}

export function buildLanguageDescriptor(ext) {
  const language = normalizeExtension(ext)
  return {
    ext,
    language,
    packageName: packageMap.get(language) ?? '@codemirror/legacy-modes',
    isAlias: language !== ext,
  }
}

export function toTitleBadge(file, viewport = 'phone') {
  return {
    label: viewport === 'phone' ? file.name : file.language,
    tone: viewport === 'phone' ? 'soft-accent' : 'neutral',
    underline: viewport === 'phone',
  }
}

export function buildPreviewState(file, viewport = 'phone') {
  const descriptor = buildLanguageDescriptor(file.ext)
  return {
    id: file.id,
    title: file.name,
    language: descriptor.language,
    packageName: descriptor.packageName,
    showMobileTitleHint: viewport === 'phone',
    enableFoldGutter: !file.legacyWithoutFold,
    badge: toTitleBadge({ ...file, language: descriptor.language }, viewport),
    lastOpenedAt: file.lastOpenedAt,
  }
}

export function createFixtureIndex(files) {
  return files.map((file) => buildPreviewState(file)).sort((a, b) => {
    if (a.language === b.language) {
      return a.title.localeCompare(b.title)
    }
    return a.language.localeCompare(b.language)
  })
}

export function summarizePackages(index) {
  const counts = new Map()
  for (const item of index) {
    counts.set(item.packageName, (counts.get(item.packageName) ?? 0) + 1)
  }
  return [...counts.entries()].map(([packageName, count]) => ({ packageName, count }))
}

export function findLegacyWithoutFold(index) {
  return index.filter((item) => item.packageName === '@codemirror/legacy-modes' && !item.enableFoldGutter)
}

export const demoFiles = [
  { id: 'f1', name: 'Sample_typescript_ets.ets', ext: 'ets', lastOpenedAt: '2026-03-09T09:30:00Z', legacyWithoutFold: false },
  { id: 'f2', name: 'Sample_json_json5.json5', ext: 'json5', lastOpenedAt: '2026-03-09T09:32:00Z', legacyWithoutFold: false },
  { id: 'f3', name: 'Sample_jinja_jinja2.jinja2', ext: 'jinja2', lastOpenedAt: '2026-03-09T09:36:00Z', legacyWithoutFold: true },
  { id: 'f4', name: 'Sample_markdown_mdx.mdx', ext: 'mdx', lastOpenedAt: '2026-03-09T09:38:00Z', legacyWithoutFold: false },
  { id: 'f5', name: 'Sample_mermaid_mmd.mmd', ext: 'mmd', lastOpenedAt: '2026-03-09T09:41:00Z', legacyWithoutFold: true },
  { id: 'f6', name: 'Sample_xml_csproj.csproj', ext: 'csproj', lastOpenedAt: '2026-03-09T09:44:00Z', legacyWithoutFold: true },
]

const preview = createFixtureIndex(demoFiles)
const packageSummary = summarizePackages(preview)
const plainLegacy = findLegacyWithoutFold(preview)

for (const item of preview) {
  console.log(`${item.language.padEnd(12)} ${item.enableFoldGutter ? 'fold' : 'plain'} ${item.title}`)
}

console.log('packages', packageSummary)
console.log('legacy-without-fold', plainLegacy.map((item) => item.title))