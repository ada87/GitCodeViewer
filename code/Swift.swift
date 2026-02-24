import SwiftUI
import Observation

// ============ Models ============

struct Repository: Identifiable, Hashable {
    let id: String
    var name: String
    var url: String
    var branch: String
    var lastSynced: Date?
    var fileCount: Int

    var displayName: String {
        url.split(separator: "/").last.map(String.init) ?? name
    }
}

enum SyncStatus: Equatable {
    case idle
    case syncing(progress: Double)
    case completed(filesChanged: Int)
    case failed(message: String)

    var isActive: Bool {
        if case .syncing = self { return true }
        return false
    }
}

// ============ ViewModel ============

@Observable
class RepoListViewModel {
    var repositories: [Repository] = []
    var syncStatuses: [String: SyncStatus] = [:]
    var searchText: String = ""
    var showAddSheet: Bool = false
    var errorMessage: String?

    var filteredRepos: [Repository] {
        guard !searchText.isEmpty else { return repositories }
        return repositories.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.url.localizedCaseInsensitiveContains(searchText)
        }
    }

    var activeSyncCount: Int {
        syncStatuses.values.filter(\.isActive).count
    }

    func addRepository(name: String, url: String) {
        let repo = Repository(
            id: UUID().uuidString,
            name: name,
            url: url,
            branch: "main",
            lastSynced: nil,
            fileCount: 0
        )
        repositories.append(repo)
    }

    func syncRepository(_ repo: Repository) async {
        syncStatuses[repo.id] = .syncing(progress: 0)
        do {
            for i in 1...10 {
                try await Task.sleep(for: .milliseconds(200))
                syncStatuses[repo.id] = .syncing(progress: Double(i) / 10.0)
            }
            let changed = Int.random(in: 1...30)
            syncStatuses[repo.id] = .completed(filesChanged: changed)
            if let idx = repositories.firstIndex(where: { $0.id == repo.id }) {
                repositories[idx].lastSynced = Date()
                repositories[idx].fileCount += changed
            }
        } catch {
            syncStatuses[repo.id] = .failed(message: error.localizedDescription)
        }
    }

    func deleteRepository(_ repo: Repository) {
        repositories.removeAll { $0.id == repo.id }
        syncStatuses.removeValue(forKey: repo.id)
    }
}

// ============ Views ============

struct RepoListView: View {
    @State private var viewModel = RepoListViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredRepos) { repo in
                    RepoRowView(repo: repo, status: viewModel.syncStatuses[repo.id] ?? .idle)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteRepository(repo)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                Task { await viewModel.syncRepository(repo) }
                            } label: {
                                Label("Sync", systemImage: "arrow.triangle.2.circlepath")
                            }
                            .tint(.blue)
                        }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search repositories")
            .navigationTitle("Repositories")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { viewModel.showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .status) {
                    if viewModel.activeSyncCount > 0 {
                        Text("Syncing \(viewModel.activeSyncCount)...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddSheet) {
                AddRepoView { name, url in
                    viewModel.addRepository(name: name, url: url)
                }
            }
        }
    }
}

struct RepoRowView: View {
    let repo: Repository
    let status: SyncStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(repo.displayName)
                .font(.headline)
            Text(repo.url)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            HStack {
                Label("\(repo.fileCount)", systemImage: "doc")
                    .font(.caption2)
                if let date = repo.lastSynced {
                    Text("Synced \(date, style: .relative) ago")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                switch status {
                case .syncing(let progress):
                    ProgressView(value: progress)
                        .frame(width: 60)
                case .failed(let msg):
                    Text(msg).font(.caption2).foregroundStyle(.red)
                default:
                    EmptyView()
                }
            }
        }
        .padding(.vertical, 2)
    }
}

struct AddRepoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var url = ""
    var onAdd: (String, String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Repository name", text: $name)
                TextField("Git URL", text: $url)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
            }
            .navigationTitle("Add Repository")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(name, url)
                        dismiss()
                    }
                    .disabled(name.isEmpty || url.isEmpty)
                }
            }
        }
    }
}
