/**
 * Code Viewer - JavaScript Engine Mock
 * 
 * This file demonstrates modern ES6+ syntax, asynchronous programming,
 * classes, modules patterns, and JSDoc comments.
 */

'use strict';

// Constants
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = 'https://api.github.com';

// Utility helper using arrow function
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

/**
 * Represents a generic file in the file system
 */
class FileNode {
  constructor(name, size, type = 'file') {
    this.name = name;
    this.size = size;
    this.type = type;
    this.createdAt = new Date();
  }

  getInfo() {
    return `${this.type.toUpperCase()}: ${this.name} (${(this.size / 1024).toFixed(2)} KB)`;
  }
}

/**
 * Manages the Git operations
 */
class GitManager {
  constructor(authToken = null) {
    this._token = authToken;
    this.repositories = new Map();
    this.isOffline = false;
  }

  get token() {
    return this._token ? '****' : 'null';
  }

  set token(newToken) {
    if (!newToken.startsWith('ghp_')) {
      throw new Error('Invalid GitHub token format');
    }
    this._token = newToken;
  }

  /**
   * Simulates cloning a repo
   * @param {string} url 
   */
  async clone(url) {
    console.log(`[GIT] Starting clone of ${url}...`);
    
    try {
      await delay(800); // Simulate network
      
      const repoId = Math.random().toString(36).substr(2, 9);
      const repo = {
        id: repoId,
        url,
        status: 'cloned',
        timestamp: Date.now()
      };
      
      this.repositories.set(repoId, repo);
      console.log(`[GIT] Clone successful. Repo ID: ${repoId}`);
      return repo;
      
    } catch (error) {
      console.error('[GIT] Clone failed:', error);
      throw error;
    }
  }

  /**
   * Generator function to walk through commits
   */
  *commitHistory() {
    const commits = [
      { hash: 'a1b2c3d', msg: 'Initial commit' },
      { hash: 'e5f6g7h', msg: 'Add feature A' },
      { hash: 'i9j0k1l', msg: 'Fix bug #42' }
    ];

    for (const commit of commits) {
      yield commit;
    }
  }
}

// Module pattern (IIFE) for some internal logic
const ThemeService = (() => {
  let currentTheme = 'dark';
  
  return {
    setTheme: (theme) => {
      if (['light', 'dark'].includes(theme)) {
        currentTheme = theme;
        console.log(`Theme changed to ${theme}`);
      }
    },
    getTheme: () => currentTheme
  };
})();

// Main Execution
(async () => {
  console.log('--- JS Runtime Initialized ---');

  const git = new GitManager();

  // Array Higher-order functions
  const files = [
    new FileNode('index.js', 1024),
    new FileNode('style.css', 2048),
    new FileNode('logo.png', 15000, 'image'),
    new FileNode('readme.md', 512)
  ];

  console.log('\n--- File System ---');
  files
    .filter(f => f.size > 1000)
    .sort((a, b) => b.size - a.size)
    .map(f => f.getInfo())
    .forEach(info => console.log(info));

  console.log('\n--- Async Operations ---');
  try {
    const repo = await git.clone('https://github.com/facebook/react.git');
    
    // Spread operator & Destructuring
    const repoDetails = { ...repo, localPath: '/data/user/0/repos/react' };
    const { id, status } = repoDetails;
    console.log(`Repo ${id} is currently ${status}`);

  } catch (e) {
    console.error('Operation failed');
  }

  console.log('\n--- Iterators ---');
  const history = git.commitHistory();
  console.log('Latest:', history.next().value);
  console.log('Prev:', history.next().value);

  // Template literals
  const stats = `
    Memory Usage: ${process.memoryUsage().heapUsed / 1024 / 1024} MB
    Uptime: ${process.uptime()} sec
  `;
  console.log(stats);

})();

// Export for Node.js environments
if (typeof module !== 'undefined') {
  module.exports = { GitManager, FileNode };
}