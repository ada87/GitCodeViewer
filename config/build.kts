package com.gitcode.viewer.data

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import java.time.Instant

// ============ Domain Models ============

data class Repository(
    val id: String,
    val name: String,
    val url: String,
    val branch: String = "main",
    val lastSynced: Instant? = null,
    val sizeBytes: Long = 0,
)

sealed interface SyncResult {
    data class Success(val repo: Repository, val filesChanged: Int) : SyncResult
    data class Error(val repo: Repository, val message: String, val cause: Throwable? = null) : SyncResult
    data object Cancelled : SyncResult
}

// ============ Repository Layer ============

interface RepoStore {
    suspend fun getAll(): List<Repository>
    suspend fun getById(id: String): Repository?
    suspend fun upsert(repo: Repository): Repository
    suspend fun delete(id: String): Boolean
}

class InMemoryRepoStore : RepoStore {
    private val store = mutableMapOf<String, Repository>()

    override suspend fun getAll(): List<Repository> = store.values.toList()
    override suspend fun getById(id: String): Repository? = store[id]
    override suspend fun upsert(repo: Repository): Repository {
        store[repo.id] = repo
        return repo
    }
    override suspend fun delete(id: String): Boolean = store.remove(id) != null
}

// ============ Sync Service ============

class SyncService(
    private val store: RepoStore,
    private val maxConcurrent: Int = 3,
) {
    private val _syncState = MutableStateFlow<Map<String, SyncStatus>>(emptyMap())
    val syncState: StateFlow<Map<String, SyncStatus>> = _syncState.asStateFlow()

    enum class SyncStatus { IDLE, SYNCING, DONE, FAILED }

    fun syncAll(): Flow<SyncResult> = flow {
        val repos = store.getAll()
        repos.chunked(maxConcurrent).forEach { batch ->
            coroutineScope {
                val results = batch.map { repo ->
                    async { syncOne(repo) }
                }
                results.forEach { emit(it.await()) }
            }
        }
    }

    private suspend fun syncOne(repo: Repository): SyncResult {
        updateStatus(repo.id, SyncStatus.SYNCING)
        return try {
            delay(500)
            val updated = repo.copy(lastSynced = Instant.now())
            store.upsert(updated)
            updateStatus(repo.id, SyncStatus.DONE)
            SyncResult.Success(updated, filesChanged = (1..50).random())
        } catch (e: CancellationException) {
            updateStatus(repo.id, SyncStatus.IDLE)
            SyncResult.Cancelled
        } catch (e: Exception) {
            updateStatus(repo.id, SyncStatus.FAILED)
            SyncResult.Error(repo, e.message ?: "Unknown error", e)
        }
    }

    private fun updateStatus(id: String, status: SyncStatus) {
        _syncState.update { it + (id to status) }
    }

    companion object {
        private const val TAG = "SyncService"

        fun formatBytes(bytes: Long): String = when {
            bytes < 1024 -> "$bytes B"
            bytes < 1024 * 1024 -> "\${bytes / 1024} KB"
            else -> "\${"%.1f".format(bytes / (1024.0 * 1024.0))} MB"
        }
    }
}

// ============ Extension Functions ============

fun Repository.displayName(): String =
    url.substringAfterLast("/").removeSuffix(".git").ifEmpty { name }

fun List<Repository>.totalSize(): String =
    SyncService.formatBytes(sumOf { it.sizeBytes })

suspend fun main() {
    val store = InMemoryRepoStore()
    val service = SyncService(store)

    listOf("repo-alpha", "repo-beta", "repo-gamma").forEach { name ->
        store.upsert(Repository(id = name, name = name, url = "https://github.com/user/$name"))
    }

    service.syncAll().collect { result ->
        when (result) {
            is SyncResult.Success -> println("[OK] \${result.repo.displayName()}: \${result.filesChanged} files")
            is SyncResult.Error -> println("[ERR] \${result.repo.displayName()}: \${result.message}")
            is SyncResult.Cancelled -> println("[CANCEL]")
        }
    }
}
