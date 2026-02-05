package com.xdnote.codeviewer.utils

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import java.io.File
import java.util.Date
import kotlin.math.roundToInt

/**
 * GitCode Viewer Utility Class
 * Demonstrating Kotlin features: Coroutines, Flows, Extensions, Data Classes, DSL
 */

// Data Class with Default Values
data class FileInfo(
    val name: String,
    val size: Long,
    val isDirectory: Boolean,
    val modifiedAt: Date = Date()
) {
    // Computed property
    val extension: String
        get() = name.substringAfterLast('.', "")
    
    fun toHumanReadableSize(): String {
        if (isDirectory) return "-"
        val kb = size / 1024.0
        return if (kb > 1024) {
            "${(kb / 1024).roundToInt()} MB"
        } else {
            "${kb.roundToInt()} KB"
        }
    }
}

// Sealed Class for State Management
sealed class UiState {
    object Loading : UiState()
    data class Success(val files: List<FileInfo>) : UiState()
    data class Error(val message: String) : UiState()
}

// Extension Function
fun String.isValidGitUrl(): Boolean {
    return this.startsWith("https://") && this.endsWith(".git")
}

// Singleton Object
object FileSystemManager {
    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    fun listFiles(path: String): Flow<UiState> = flow {
        emit(UiState.Loading)
        delay(500) // Simulate I/O delay
        
        try {
            // Mock file listing
            val mockFiles = listOf(
                FileInfo("src", 0, true),
                FileInfo("README.md", 1204, false),
                FileInfo("build.gradle.kts", 560, false),
                FileInfo("MainActivity.kt", 2048, false)
            )
            emit(UiState.Success(mockFiles))
        } catch (e: Exception) {
            emit(UiState.Error(e.message ?: "Unknown error"))
        }
    }
    
    // Suspend function
    suspend fun calculateTotalSize(files: List<FileInfo>): Long = withContext(Dispatchers.Default) {
        files.filter { !it.isDirectory }.sumOf { it.size }
    }
}

// DSL Example (Type-safe builder)
class RepoConfigBuilder {
    var url: String = ""
    var branch: String = "main"
    var autoSync: Boolean = true

    fun build(): Map<String, Any> = mapOf(
        "url" to url,
        "branch" to branch,
        "autoSync" to autoSync
    )
}

fun repoConfig(block: RepoConfigBuilder.() -> Unit): Map<String, Any> {
    val builder = RepoConfigBuilder()
    builder.block()
    return builder.build()
}

// Main Entry Point
fun main() = runBlocking {
    println(">>> Kotlin Runtime Started")

    // Null Safety
    val maybeName: String? = null
    println("Name length: ${maybeName?.length ?: 0}")

    // String Templates
    val appName = "GitCodeViewer"
    println("Welcome to $appName")

    // Using DSL
    val config = repoConfig {
        url = "https://github.com/jetbrains/kotlin.git"
        branch = "master"
        autoSync = false
    }
    println("Config created: $config")

    // Coroutine Flow Collection
    println("\nReading directory...")
    FileSystemManager.listFiles("/data/user/0/com.xdnote/files")
        .collect { state ->
            when (state) {
                is UiState.Loading -> println("⏳ Loading...")
                is UiState.Success -> {
                    println("✅ Found ${state.files.size} files:")
                    state.files.forEach { 
                        println("   - ${it.name} (${it.toHumanReadableSize()})")
                    }
                    
                    val total = FileSystemManager.calculateTotalSize(state.files)
                    println("   Total size: $total bytes")
                }
                is UiState.Error -> println("❌ Error: ${state.message}")
            }
        }

    // High order function
    val numbers = listOf(1, 2, 3, 4, 5)
    val evenSquared = numbers
        .filter { it % 2 == 0 }
        .map { it * it }
    println("\nFunctional processing: $evenSquared")
    
    // Destructuring Declaration
    val (name, size, _, _) = FileInfo("test.txt", 100, false)
    println("Processed file: $name, size: $size")
}