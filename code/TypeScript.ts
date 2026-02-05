/**
 * GitCode Viewer - TypeScript Core Types & Utils
 * 
 * Demonstrates: Interfaces, Generics, Enums, Type Guards, Decorators, Async/Await
 */

// --- Constants & Enums ---

export enum Theme {
  Light = 'light',
  Dark = 'dark',
  System = 'system'
}

export enum GitStatus {
  Clean = 'clean',
  Modified = 'modified',
  Detached = 'detached',
  Conflict = 'conflict'
}

// --- Interfaces ---

export interface User {
  id: string;
  username: string;
  avatarUrl?: string;
  isPro: boolean;
}

export interface Repository {
  id: string;
  name: string;
  url: string;
  branch: string;
  status: GitStatus;
  lastSyncedAt: Date;
  // Index signature
  [key: string]: any;
}

export interface FileNode {
  path: string;
  type: 'file' | 'directory';
  size: number;
  children?: FileNode[];
}

// --- Generics ---

export interface ApiResponse<T> {
  data: T;
  success: boolean;
  timestamp: number;
  error?: string;
}

// --- Decorators ---

function LogExecutionTime(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
  const originalMethod = descriptor.value;
  descriptor.value = async function (...args: any[]) {
    const start = performance.now();
    const result = await originalMethod.apply(this, args);
    const end = performance.now();
    console.log(`${propertyKey} took ${(end - start).toFixed(2)}ms`);
    return result;
  };
  return descriptor;
}

// --- Core Class ---

export class RepoManager {
  private repos: Map<string, Repository> = new Map();

  constructor(private readonly user: User) {
    console.log(`Initialized manager for user ${user.username}`);
  }

  @LogExecutionTime
  public async fetchRepos(): Promise<ApiResponse<Repository[]>> {
    // Simulate API Fetch
    await new Promise(resolve => setTimeout(resolve, 800));

    const mockRepos: Repository[] = [
      {
        id: '1',
        name: 'react-native-code-viewer',
        url: 'https://github.com/ada87/GitCodeViewer',
        branch: 'main',
        status: GitStatus.Clean,
        lastSyncedAt: new Date(),
        language: 'TypeScript'
      },
      {
        id: '2',
        name: 'linux',
        url: 'https://github.com/torvalds/linux',
        branch: 'master',
        status: GitStatus.Modified,
        lastSyncedAt: new Date(Date.now() - 3600000)
      }
    ];

    mockRepos.forEach(r => this.repos.set(r.id, r));

    return {
      data: mockRepos,
      success: true,
      timestamp: Date.now()
    };
  }

  public getRepo(id: string): Repository | undefined {
    return this.repos.get(id);
  }

  // Union Types & Type Guards
  public processItem(item: Repository | User) {
    if (this.isRepository(item)) {
      console.log(`Processing repo: ${item.name}`);
    } else {
      console.log(`Processing user: ${item.username}`);
    }
  }

  private isRepository(item: any): item is Repository {
    return (item as Repository).url !== undefined;
  }
}

// --- Utility Functions ---

export const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

// --- Execution ---

async function main() {
  const user: User = {
    id: 'u123',
    username: 'dev_hero',
    isPro: true
  };

  const manager = new RepoManager(user);
  
  try {
    const response = await manager.fetchRepos();
    if (response.success) {
      console.log(`Fetched ${response.data.length} repositories.`);
      
      const firstRepo = response.data[0];
      manager.processItem(firstRepo);
      
      console.log(`Repo 1 Size: ${formatFileSize(2048576)}`);
    }
  } catch (error) {
    console.error('Error:', error);
  }
}

main();