interface RepoSummary {
  id: string
  name: string
  branch: string
  author: string
  lastSyncLabel: string
  pinned: boolean
}

const RECENT_REPOS: RepoSummary[] = [
  { id: 'workspace-core', name: 'CodeReader', branch: 'main', author: 'ada', lastSyncLabel: '3 min ago', pinned: true },
  { id: 'mobile-ui', name: 'MobileWorkspace', branch: 'feature/header', author: 'lin', lastSyncLabel: '12 min ago', pinned: true },
  { id: 'syntax-lab', name: 'SyntaxFixtures', branch: 'refresh/samples', author: 'mo', lastSyncLabel: '42 min ago', pinned: false },
  { id: 'release-notes', name: 'ReleaseNotes', branch: 'release/1.3.2', author: 'yan', lastSyncLabel: '1 h ago', pinned: false },
  { id: 'android-shell', name: 'AndroidShell', branch: 'fix/safe-area', author: 'qi', lastSyncLabel: '2 h ago', pinned: false },
  { id: 'docs-site', name: 'DocsSite', branch: 'content/runbook', author: 'zhou', lastSyncLabel: 'yesterday', pinned: false },
]

function formatSubtitle(repo: RepoSummary): string {
  return `${repo.branch} · ${repo.author} · ${repo.lastSyncLabel}`
}

@Component
struct RepoCard {
  repo: RepoSummary
  onOpen?: (id: string) => void

  build() {
    Row({ space: 12 }) {
      Column() {
        Text(this.repo.name)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1F2937')
        Text(formatSubtitle(this.repo))
          .fontSize(12)
          .fontColor('#6B7280')
          .margin({ top: 6 })
      }
      .layoutWeight(1)
      if (this.repo.pinned) {
        Text('PINNED')
          .fontSize(11)
          .fontColor('#8A5A24')
          .backgroundColor('#FFF4DB')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(999)
      }
    }
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(14)
    .margin({ bottom: 10 })
    .onClick(() => this.onOpen?.(this.repo.id))
  }
}

@Entry
@Component
struct WorkspacePage {
  @State searchText: string = ''
  @State repos: RepoSummary[] = RECENT_REPOS
  @State lastOpenedId: string = 'workspace-core'

  private filteredRepos(): RepoSummary[] {
    const keyword = this.searchText.trim().toLowerCase()
    if (!keyword) {
      return this.repos
    }
    return this.repos.filter((repo: RepoSummary) => {
      return repo.name.toLowerCase().includes(keyword)
        || repo.branch.toLowerCase().includes(keyword)
        || repo.author.toLowerCase().includes(keyword)
    })
  }

  private openRepo(id: string): void {
    this.lastOpenedId = id
    console.info(`open repo ${id}`)
  }

  build() {
    Column({ space: 14 }) {
      Text('Recent Workspaces')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111827')
      Search({ placeholder: 'Filter by repo, branch, or author' })
        .value(this.searchText)
        .onChange((value: string) => this.searchText = value)
      Text(`Last opened: ${this.lastOpenedId}`)
        .fontSize(12)
        .fontColor('#6B7280')
      List() {
        ForEach(this.filteredRepos(), (repo: RepoSummary) => {
          ListItem() {
            RepoCard({ repo, onOpen: (id: string) => this.openRepo(id) })
          }
        }, (repo: RepoSummary) => repo.id)
      }
      .divider({ strokeWidth: 0 })
      .edgeEffect(EdgeEffect.None)
    }
    .padding(20)
    .width('100%')
    .height('100%')
    .backgroundColor('#F4F7FB')
  }
}