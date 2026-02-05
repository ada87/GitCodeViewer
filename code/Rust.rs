// GitCode Viewer - Rust Engine Prototype
// Demonstrates: Structs, Enums, Traits, Matching, Options, Results, Concurrency

use std::collections::HashMap;
use std::fmt;
use std::thread;
use std::time::Duration;

// Type alias
type RepoId = u32;

// Custom Error Type
#[derive(Debug)]
enum GitError {
    NetworkError,
    NotFound,
    PermissionDenied,
}

// Status Enum
#[derive(Debug, PartialEq)]
enum RepoStatus {
    Unsynced,
    Syncing,
    Synced,
    Error(String),
}

// Data Struct
struct Repository {
    id: RepoId,
    name: String,
    url: String,
    status: RepoStatus,
    size_kb: u64,
}

impl Repository {
    fn new(id: RepoId, name: &str, url: &str) -> Self {
        Repository {
            id,
            name: name.to_string(),
            url: url.to_string(),
            status: RepoStatus::Unsynced,
            size_kb: 0,
        }
    }

    fn sync(&mut self) -> Result<(), GitError> {
        println!("Starting sync for {}...", self.name);
        self.status = RepoStatus::Syncing;

        // Simulate work
        thread::sleep(Duration::from_millis(500));

        if self.url.contains("invalid") {
            self.status = RepoStatus::Error("Invalid URL".to_string());
            return Err(GitError::NotFound);
        }

        self.status = RepoStatus::Synced;
        self.size_kb = 1024; // Mock size
        Ok(())
    }
}

// Display Trait Implementation
impl fmt::Display for Repository {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[{}] {} ({:?})", self.id, self.name, self.status)
    }
}

// Trait Definition
trait Searchable {
    fn contains_query(&self, query: &str) -> bool;
}

impl Searchable for Repository {
    fn contains_query(&self, query: &str) -> bool {
        self.name.to_lowercase().contains(&query.to_lowercase())
    }
}

// Database Manager
struct RepoManager {
    repos: HashMap<RepoId, Repository>,
}

impl RepoManager {
    fn new() -> Self {
        RepoManager {
            repos: HashMap::new(),
        }
    }

    fn add(&mut self, repo: Repository) {
        self.repos.insert(repo.id, repo);
    }

    fn get_mut(&mut self, id: RepoId) -> Option<&mut Repository> {
        self.repos.get_mut(&id)
    }

    fn list_all(&self) {
        println!("\n--- Repository List ---");
        for repo in self.repos.values() {
            println!("{}", repo);
        }
        println!("-----------------------");
    }
}

fn main() {
    println!("Initializing Rust Git Engine...");

    let mut manager = RepoManager::new();

    // Adding mock data
    manager.add(Repository::new(1, "tokio", "https://github.com/tokio-rs/tokio"));
    manager.add(Repository::new(2, "actix", "https://github.com/actix/actix"));
    manager.add(Repository::new(3, "broken-repo", "https://invalid.url/test"));

    manager.list_all();

    // Matching and Results
    println!("\n--- Performing Sync Operations ---");
    let ids_to_sync = vec![1, 2, 3, 4]; // 4 does not exist

    for id in ids_to_sync {
        match manager.get_mut(id) {
            Some(repo) => {
                match repo.sync() {
                    Ok(_) => println!("✅ Sync success: {}", repo.name),
                    Err(e) => println!("❌ Sync failed for {}: {:?}", repo.name, e),
                }
            }
            None => println!("⚠️  Repo ID {} not found in database.", id),
        }
    }

    manager.list_all();

    // Functional features: Iterators and Closures
    println!("\n--- Search Results ('act') ---");
    let search_term = "act";
    let results: Vec<&Repository> = manager.repos.values()
        .filter(|r| r.contains_query(search_term))
        .collect();

    for r in results {
        println!("Found: {}", r.name);
    }

    // Ownership and Borrowing demonstration
    let config_str = String::from("Theme=Dark");
    process_config(&config_str); // Borrow
    // process_config(config_str); // This would move ownership if signature was String
    println!("Config is still valid: {}", config_str);
}

fn process_config(cfg: &str) {
    println!("Processing config: {}", cfg);
}