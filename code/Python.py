"""
GitCode Viewer - Python Backend Simulation
Demonstrates: Classes, Decorators, Type Hints, AsyncIO, DataClasses
"""

import asyncio
import random
import json
import logging
from dataclasses import dataclass, field
from datetime import datetime
from typing import List, Optional, Dict

# Configuration
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("GitManager")

@dataclass
class Commit:
    hash: str
    author: str
    message: str
    timestamp: datetime = field(default_factory=datetime.now)

    def to_json(self) -> str:
        return json.dumps(self.__dict__, default=str)

@dataclass
class Repository:
    id: int
    name: str
    url: str
    is_private: bool = False
    tags: List[str] = field(default_factory=list)

class GitError(Exception):
    """Custom exception for Git operations"""
    pass

def retry(attempts: int = 3):
    """Decorator to retry async functions"""
    def decorator(func):
        async def wrapper(*args, **kwargs):
            for i in range(attempts):
                try:
                    return await func(*args, **kwargs)
                except Exception as e:
                    logger.warning(f"Attempt {i+1} failed: {e}")
                    await asyncio.sleep(0.5)
            raise GitError(f"Function {func.__name__} failed after {attempts} attempts")
        return wrapper
    return decorator

class RepoManager:
    def __init__(self, storage_path: str):
        self.storage_path = storage_path
        self._cache: Dict[int, Repository] = {}

    def add_repo(self, repo: Repository):
        self._cache[repo.id] = repo
        logger.info(f"Repository added: {repo.name}")

    @retry(attempts=3)
    async def clone(self, repo_id: int) -> bool:
        """Simulate a network clone operation"""
        if repo_id not in self._cache:
            raise ValueError("Repository ID not found")
        
        repo = self._cache[repo_id]
        logger.info(f"Starting clone for {repo.url}...")
        
        # Simulate network delay / uncertainty
        await asyncio.sleep(random.uniform(0.5, 1.5))
        
        if random.random() < 0.2:
            raise ConnectionError("Network timeout during clone")
            
        logger.info(f"Successfully cloned {repo.name}")
        return True

    def get_commit_history(self, repo_id: int, limit: int = 5) -> List[Commit]:
        """Generator simulation for commits"""
        commits = []
        for i in range(limit):
            commits.append(Commit(
                hash=f"a{i}b{i}c{i}",
                author="Alice Dev",
                message=f"Refactor module {i}"
            ))
        return commits

async def main():
    logger.info("Starting Python Git Engine...")
    
    manager = RepoManager("/var/data/repos")
    
    # Initialize some data
    repo1 = Repository(1, "fastapi-demo", "https://github.com/tiangolo/fastapi", tags=["python", "web"])
    repo2 = Repository(2, "react-native", "https://github.com/facebook/react-native", tags=["js", "mobile"])
    
    manager.add_repo(repo1)
    manager.add_repo(repo2)
    
    # Run async tasks
    try:
        results = await asyncio.gather(
            manager.clone(1),
            manager.clone(2)
        )
        print(f"Clone results: {results}")
    except GitError as e:
        logger.error(f"Critical error: {e}")

    # Process data
    print("\n--- Commit History for Repo 1 ---")
    history = manager.get_commit_history(1)
    for commit in history:
        print(f"[{commit.hash}] {commit.message} ({commit.timestamp})")

    # List Comprehension & Filter
    web_repos = [r.name for r in manager._cache.values() if "web" in r.tags]
    print(f"\nWeb Repositories: {web_repos}")
    
    # Context Manager example (File I/O)
    filename = "repo_export.json"
    with open(filename, "w") as f:
        data = {id: r.__dict__ for id, r in manager._cache.items()}
        json.dump(data, f, indent=2, default=str)
    print(f"\nExported config to {filename}")

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Stopped by user")