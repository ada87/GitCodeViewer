//
//  GitCodeViewer.swift
//  GitCodeViewer
//
//  Created by CodeViewer Team on 2024-02-05.
//  Copyright © 2024 CodeViewer. All rights reserved.
//

import Foundation
import UIKit
import Combine

// --- Models ---

struct Repository: Identifiable, Codable {
    let id: UUID
    var name: String
    var url: URL
    var isPrivate: Bool
    var lastSynced: Date?
    
    init(name: String, urlString: String, isPrivate: Bool = false) {
        self.id = UUID()
        self.name = name
        self.url = URL(string: urlString)!
        self.isPrivate = isPrivate
        self.lastSynced = nil
    }
}

enum AppError: Error {
    case networkError(String)
    case fileSystemError
    case unauthorized
}

// --- View Models (MVVM) ---

class RepoListViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        self.repositories = [
            Repository(name: "swift-algorithms", urlString: "https://github.com/apple/swift-algorithms"),
            Repository(name: "alamofire", urlString: "https://github.com/Alamofire/Alamofire")
        ]
    }
    
    func addRepository(url: String) {
        guard let validUrl = URL(string: url) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let name = validUrl.lastPathComponent.replacingOccurrences(of: ".git", with: "")
        let newRepo = Repository(name: name, urlString: url)
        
        withAnimation {
            repositories.append(newRepo)
        }
    }
    
    func syncRepo(id: UUID) {
        guard let index = repositories.firstIndex(where: { $0.id == id }) else { return }
        
        isLoading = true
        
        // Simulate network call with Combine
        Future<Bool, AppError> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                // Random success/fail
                if Bool.random() {
                    promise(.success(true))
                } else {
                    promise(.failure(.networkError("Timeout")))
                }
            }
        }
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            self.isLoading = false
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Sync failed: \(error)")
                self.errorMessage = "Sync failed. Please try again."
            }
        }, receiveValue: { success in
            self.repositories[index].lastSynced = Date()
            print("Sync successful for \(self.repositories[index].name)")
        })
        .store(in: &cancellables)
    }
}

// --- Protocols and Extensions ---

protocol Themeable {
    var primaryColor: UIColor { get }
    func applyTheme()
}

extension UIColor {
    static let gitBrand = UIColor(red: 0.94, green: 0.31, blue: 0.20, alpha: 1.0)
    static let darkBackground = UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1.0)
}

// --- Utility Classes ---

class GitManager {
    static let shared = GitManager()
    
    private init() {}
    
    func clone(repo: Repository) async throws -> URL {
        print("Cloning \(repo.url)...")
        
        // Simulate async await work
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = documents.appendingPathComponent(repo.name)
        
        // Mock file creation
        let readme = "This is a README for \(repo.name)"
        try readme.write(to: path.appendingPathComponent("README.md"), atomically: true, encoding: .utf8)
        
        return path
    }
}

// --- SwiftUI Views Mockup ---

struct RepoRow: View {
    let repo: Repository
    
    var body: some View {
        HStack {
            Image(systemName: "book.closed")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(repo.name)
                    .font(.headline)
                Text(repo.url.absoluteString)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if let date = repo.lastSynced {
                Text(date, style: .time)
                    .font(.caption2)
            } else {
                Text("Never")
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

// Main entry point logic (if this were a real app)
/*
 @main
 struct GitCodeViewerApp: App {
     var body: some Scene {
         WindowGroup {
             ContentView()
         }
     }
 }
 */