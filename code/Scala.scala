package gitcode.viewer.sync

import scala.concurrent.{ExecutionContext, Future}
import scala.concurrent.duration.*
import java.time.Instant

// ============ Domain Models ============

case class Repository(
  id: String,
  name: String,
  url: String,
  branch: String = "main",
  lastSynced: Option[Instant] = None,
  sizeBytes: Long = 0,
)

enum SyncResult:
  case Success(repo: Repository, filesChanged: Int)
  case Error(repo: Repository, message: String, cause: Option[Throwable] = None)
  case Cancelled

enum SyncStatus:
  case Idle, Syncing, Done, Failed

// ============ Repository Layer ============

trait RepoStore:
  def getAll: Future[List[Repository]]
  def getById(id: String): Future[Option[Repository]]
  def upsert(repo: Repository): Future[Repository]
  def delete(id: String): Future[Boolean]

class InMemoryRepoStore(using ExecutionContext) extends RepoStore:
  private var store = Map.empty[String, Repository]

  def getAll: Future[List[Repository]] = Future.successful(store.values.toList)

  def getById(id: String): Future[Option[Repository]] = Future.successful(store.get(id))

  def upsert(repo: Repository): Future[Repository] = Future.successful:
    store = store + (repo.id -> repo)
    repo

  def delete(id: String): Future[Boolean] = Future.successful:
    val existed = store.contains(id)
    store = store - id
    existed

// ============ Sync Service ============

class SyncService(store: RepoStore, maxConcurrent: Int = 3)(using ExecutionContext):
  private var statusMap = Map.empty[String, SyncStatus]

  def syncAll(): Future[List[SyncResult]] =
    store.getAll.flatMap: repos =>
      Future.sequence(repos.map(syncOne))

  private def syncOne(repo: Repository): Future[SyncResult] =
    updateStatus(repo.id, SyncStatus.Syncing)
    Future:
      Thread.sleep(500)
      val updated = repo.copy(lastSynced = Some(Instant.now()))
      store.upsert(updated)
      updateStatus(repo.id, SyncStatus.Done)
      SyncResult.Success(updated, scala.util.Random.nextInt(50) + 1)
    .recover:
      case e: InterruptedException =>
        updateStatus(repo.id, SyncStatus.Idle)
        SyncResult.Cancelled
      case e: Exception =>
        updateStatus(repo.id, SyncStatus.Failed)
        SyncResult.Error(repo, e.getMessage, Some(e))

  private def updateStatus(id: String, status: SyncStatus): Unit =
    statusMap = statusMap + (id -> status)

object SyncService:
  def formatBytes(bytes: Long): String = bytes match
    case b if b < 1024            => s"$b B"
    case b if b < 1024 * 1024     => s"${b / 1024} KB"
    case b                        => f"${b / (1024.0 * 1024.0)}%.1f MB"

// ============ Extension Methods ============

extension (repo: Repository)
  def displayName: String =
    repo.url.split("/").lastOption.map(_.stripSuffix(".git")).filter(_.nonEmpty).getOrElse(repo.name)

extension (repos: List[Repository])
  def totalSize: String = SyncService.formatBytes(repos.map(_.sizeBytes).sum)
