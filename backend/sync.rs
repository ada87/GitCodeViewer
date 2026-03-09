use std::collections::HashMap;
use std::sync::Arc;
use tokio::sync::RwLock;
use serde::{Deserialize, Serialize};
use thiserror::Error;

// ============ Error Handling ============

#[derive(Error, Debug)]
pub enum AppError {
    #[error("Repository not found: {0}")]
    NotFound(String),
    #[error("Validation failed: {0}")]
    Validation(String),
    #[error("Internal error: {0}")]
    Internal(#[from] std::io::Error),
    #[error("Serialization error: {0}")]
    Serialization(#[from] serde_json::Error),
}

type Result<T> = std::result::Result<T, AppError>;

// ============ Domain Models ============

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct User {
    pub id: String,
    pub name: String,
    pub email: String,
    pub role: Role,
    pub tags: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum Role {
    Admin,
    Editor,
    Viewer,
}

impl User {
    pub fn new(name: impl Into<String>, email: impl Into<String>, role: Role) -> Self {
        Self {
            id: uuid::Uuid::new_v4().to_string(),
            name: name.into(),
            email: email.into(),
            role,
            tags: Vec::new(),
        }
    }

    pub fn is_admin(&self) -> bool {
        self.role == Role::Admin
    }
}

// ============ Repository Trait ============

#[async_trait::async_trait]
pub trait Repository: Send + Sync {
    async fn find_all(&self) -> Result<Vec<User>>;
    async fn find_by_id(&self, id: &str) -> Result<Option<User>>;
    async fn create(&self, user: User) -> Result<User>;
    async fn update(&self, id: &str, user: User) -> Result<User>;
    async fn delete(&self, id: &str) -> Result<bool>;
}

// ============ In-Memory Implementation ============

pub struct InMemoryRepo {
    store: Arc<RwLock<HashMap<String, User>>>,
}

impl InMemoryRepo {
    pub fn new() -> Self {
        Self {
            store: Arc::new(RwLock::new(HashMap::new())),
        }
    }
}

#[async_trait::async_trait]
impl Repository for InMemoryRepo {
    async fn find_all(&self) -> Result<Vec<User>> {
        let store = self.store.read().await;
        Ok(store.values().cloned().collect())
    }

    async fn find_by_id(&self, id: &str) -> Result<Option<User>> {
        let store = self.store.read().await;
        Ok(store.get(id).cloned())
    }

    async fn create(&self, user: User) -> Result<User> {
        let mut store = self.store.write().await;
        store.insert(user.id.clone(), user.clone());
        Ok(user)
    }

    async fn update(&self, id: &str, user: User) -> Result<User> {
        let mut store = self.store.write().await;
        if !store.contains_key(id) {
            return Err(AppError::NotFound(id.to_string()));
        }
        store.insert(id.to_string(), user.clone());
        Ok(user)
    }

    async fn delete(&self, id: &str) -> Result<bool> {
        let mut store = self.store.write().await;
        Ok(store.remove(id).is_some())
    }
}

// ============ Service Layer ============

pub struct UserService<R: Repository> {
    repo: R,
}

impl<R: Repository> UserService<R> {
    pub fn new(repo: R) -> Self {
        Self { repo }
    }

    pub async fn get_admins(&self) -> Result<Vec<User>> {
        let users = self.repo.find_all().await?;
        Ok(users.into_iter().filter(|u| u.is_admin()).collect())
    }

    pub async fn create_user(&self, name: &str, email: &str, role: Role) -> Result<User> {
        if name.is_empty() {
            return Err(AppError::Validation("Name cannot be empty".into()));
        }
        let user = User::new(name, email, role);
        self.repo.create(user).await
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let repo = InMemoryRepo::new();
    let service = UserService::new(repo);

    let admin = service.create_user("Alice", "alice@example.com", Role::Admin).await?;
    println!("Created: {} ({})", admin.name, admin.id);

    let admins = service.get_admins().await?;
    println!("Total admins: {}", admins.len());

    Ok(())
}
