const EXTENSION_ALIASES: Record<string, string> = {
  astro: 'astro',
  cjs: 'javascript',
  cts: 'typescript',
  ets: 'typescript',
  j2: 'jinja2',
  jinja: 'jinja2',
  jinja2: 'jinja2',
  json5: 'json',
  jsonc: 'json',
  jsx: 'jsx',
  liquid: 'liquid',
  mdx: 'mdx',
  mjs: 'javascript',
  mmd: 'mermaid',
  mts: 'typescript',
  njk: 'jinja2',
  phtml: 'php',
  tsx: 'tsx',
}

const GROUP_LABELS = new Map<string, string>([
  ['code', 'Code'],
  ['document', 'Document'],
])

const CODE_GROUPS = new Set(['backend', 'config', 'frontend', 'mobile', 'system', 'template'])
const DOCUMENT_GROUPS = new Set(['office', 'document', 'diagram'])
const GROUP_ORDER = new Map<string, number>([
  ['code', 0],
  ['document', 1],
])

export interface PreviewEntry {
  path: string
  size: number
  modifiedAt: string
  featured?: boolean
}

export interface SidebarGroup {
  key: string
  label: string
  items: Array<PreviewEntry & { language: string; title: string }>
}

function splitPath(filePath: string): { group: string; fileName: string } {
  const [group = 'misc', fileName = filePath] = filePath.split('/')
  if (CODE_GROUPS.has(group)) {
    return { group: 'code', fileName }
  }
  if (DOCUMENT_GROUPS.has(group)) {
    return { group: 'document', fileName }
  }
  return { group, fileName }
}

function extensionOf(fileName: string): string {
  const parts = fileName.toLowerCase().split('.')
  return parts.length > 1 ? parts.at(-1) ?? '' : ''
}

export function languageOf(filePath: string): string {
  const { fileName } = splitPath(filePath)
  const extension = extensionOf(fileName)
  return EXTENSION_ALIASES[extension] ?? extension ?? 'text'
}

export function titleOf(filePath: string): string {
  const { fileName } = splitPath(filePath)
  const stem = fileName.replace(/\.[^.]+$/, '')
  return stem
    .split(/[-_.]/g)
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(' ')
}

export function normalizeEntry(entry: Partial<PreviewEntry>): PreviewEntry {
  return {
    path: String(entry.path ?? ''),
    size: Number(entry.size ?? 0),
    modifiedAt: String(entry.modifiedAt ?? new Date(0).toISOString()),
    featured: Boolean(entry.featured),
  }
}

export function compareEntries(left: PreviewEntry, right: PreviewEntry): number {
  if (left.featured !== right.featured) {
    return left.featured ? -1 : 1
  }

  if (left.path !== right.path) {
    return left.path.localeCompare(right.path)
  }

  return right.modifiedAt.localeCompare(left.modifiedAt)
}

export function buildSidebar(entries: PreviewEntry[]): SidebarGroup[] {
  const groups = new Map<string, SidebarGroup>()

  for (const rawEntry of entries.map(normalizeEntry).sort(compareEntries)) {
    const { group } = splitPath(rawEntry.path)
    const bucket = groups.get(group) ?? {
      key: group,
      label: GROUP_LABELS.get(group) ?? group,
      items: [],
    }

    bucket.items.push({
      ...rawEntry,
      language: languageOf(rawEntry.path),
      title: titleOf(rawEntry.path),
    })

    groups.set(group, bucket)
  }

  return [...groups.values()].sort((left, right) => {
    const leftOrder = GROUP_ORDER.get(left.key) ?? Number.MAX_SAFE_INTEGER
    const rightOrder = GROUP_ORDER.get(right.key) ?? Number.MAX_SAFE_INTEGER
    if (leftOrder !== rightOrder) {
      return leftOrder - rightOrder
    }
    return left.label.localeCompare(right.label)
  })
}

export function resolveDemoUrl(baseUrl: string | URL, filePath: string): string {
  const base = typeof baseUrl === 'string' ? new URL(baseUrl) : new URL(baseUrl.toString())
  base.searchParams.set('file', filePath)
  return base.toString()
}

export function pickLanding(entries: PreviewEntry[]): PreviewEntry | undefined {
  return entries
    .map(normalizeEntry)
    .sort((left, right) => {
      const leftScore = Number(Boolean(left.featured)) * 100000 + left.size
      const rightScore = Number(Boolean(right.featured)) * 100000 + right.size
      return rightScore - leftScore
    })
    .at(0)
}
