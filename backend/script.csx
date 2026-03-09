using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace GitCodeViewer.Sync
{
    // ============ Domain Models ============

    public record Repository(
        string Id,
        string Name,
        string Url,
        string Branch = "main",
        DateTime? LastSynced = null,
        long SizeBytes = 0
    );

    public abstract record SyncResult
    {
        public record Success(Repository Repo, int FilesChanged) : SyncResult;
        public record Error(Repository Repo, string Message, Exception? Cause = null) : SyncResult;
        public record Cancelled : SyncResult;
    }

    public enum SyncStatus { Idle, Syncing, Done, Failed }

    // ============ Repository Layer ============

    public interface IRepoStore
    {
        Task<IReadOnlyList<Repository>> GetAllAsync();
        Task<Repository?> GetByIdAsync(string id);
        Task<Repository> UpsertAsync(Repository repo);
        Task<bool> DeleteAsync(string id);
    }

    public class InMemoryRepoStore : IRepoStore
    {
        private readonly Dictionary<string, Repository> _store = new();
        private readonly SemaphoreSlim _lock = new(1, 1);

        public async Task<IReadOnlyList<Repository>> GetAllAsync()
        {
            await _lock.WaitAsync();
            try { return _store.Values.ToList(); }
            finally { _lock.Release(); }
        }

        public async Task<Repository?> GetByIdAsync(string id)
        {
            await _lock.WaitAsync();
            try { return _store.TryGetValue(id, out var repo) ? repo : null; }
            finally { _lock.Release(); }
        }

        public async Task<Repository> UpsertAsync(Repository repo)
        {
            await _lock.WaitAsync();
            try { _store[repo.Id] = repo; return repo; }
            finally { _lock.Release(); }
        }

        public async Task<bool> DeleteAsync(string id)
        {
            await _lock.WaitAsync();
            try { return _store.Remove(id); }
            finally { _lock.Release(); }
        }
    }

    // ============ Sync Service ============

    public class SyncService
    {
        private readonly IRepoStore _store;
        private readonly int _maxConcurrent;
        private readonly Dictionary<string, SyncStatus> _statusMap = new();

        public SyncService(IRepoStore store, int maxConcurrent = 3)
        {
            _store = store;
            _maxConcurrent = maxConcurrent;
        }

        public async IAsyncEnumerable<SyncResult> SyncAllAsync(CancellationToken ct = default)
        {
            var repos = await _store.GetAllAsync();
            var semaphore = new SemaphoreSlim(_maxConcurrent);

            var tasks = repos.Select(async repo =>
            {
                await semaphore.WaitAsync(ct);
                try { return await SyncOneAsync(repo, ct); }
                finally { semaphore.Release(); }
            });

            foreach (var task in tasks)
                yield return await task;
        }

        private async Task<SyncResult> SyncOneAsync(Repository repo, CancellationToken ct)
        {
            UpdateStatus(repo.Id, SyncStatus.Syncing);
            try
            {
                await Task.Delay(500, ct);
                var updated = repo with { LastSynced = DateTime.UtcNow };
                await _store.UpsertAsync(updated);
                UpdateStatus(repo.Id, SyncStatus.Done);
                return new SyncResult.Success(updated, new Random().Next(1, 50));
            }
            catch (OperationCanceledException)
            {
                UpdateStatus(repo.Id, SyncStatus.Idle);
                return new SyncResult.Cancelled();
            }
            catch (Exception e)
            {
                UpdateStatus(repo.Id, SyncStatus.Failed);
                return new SyncResult.Error(repo, e.Message, e);
            }
        }

        private void UpdateStatus(string id, SyncStatus status) => _statusMap[id] = status;

        public static string FormatBytes(long bytes) => bytes switch
        {
            < 1024 => $"{bytes} B",
            < 1024 * 1024 => $"{bytes / 1024} KB",
            _ => $"{bytes / (1024.0 * 1024.0):F1} MB",
        };
    }

    // ============ Extensions ============

    public static class RepositoryExtensions
    {
        public static string DisplayName(this Repository repo) =>
            repo.Url.Split('/').Last().Replace(".git", "").DefaultIfEmpty(repo.Name);

        public static string TotalSize(this IEnumerable<Repository> repos) =>
            SyncService.FormatBytes(repos.Sum(r => r.SizeBytes));

        private static string DefaultIfEmpty(this string value, string fallback) =>
            string.IsNullOrEmpty(value) ? fallback : value;
    }
}
