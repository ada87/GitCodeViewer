<?php

namespace App\Services;

use App\Models\Repository;
use App\Interfaces\GitInterface;
use Illuminate\Support\Facades\Log;
use Exception;

/**
 * GitManager Service
 * Handles Git operations for the backend API.
 */
class GitManager implements GitInterface {
    
    private $basePath;
    private $timeout;

    // Constant definition
    const MAX_CLONE_SIZE_MB = 500;
    const DEFAULT_BRANCH = 'main';

    public function __construct(string $basePath = '/var/www/repos') {
        $this->basePath = $basePath;
        $this->timeout = 60; // seconds
    }

    /**
     * Clone a remote repository
     * 
     * @param string $url The HTTPS URL of the repo
     * @param string $user The owner username
     * @return array Status result
     */
    public function cloneRepository(string $url, string $user): array {
        $targetDir = $this->basePath . '/' . $user . '/' . basename($url, '.git');
        
        Log::info("Starting clone for $url into $targetDir");

        if (file_exists($targetDir)) {
            return [
                'status' => 'error',
                'message' => 'Repository already exists locally.'
            ];
        }

        try {
            // Simulation of a shell command execution
            $command = sprintf("git clone --depth 1 %s %s", escapeshellarg($url), escapeshellarg($targetDir));
            $output = $this->executeCommand($command);

            return [
                'status' => 'success',
                'path' => $targetDir,
                'output' => $output
            ];

        } catch (Exception $e) {
            Log::error("Clone failed: " . $e->getMessage());
            return [
                'status' => 'error',
                'message' => $e->getMessage()
            ];
        }
    }

    /**
     * Get recent commits
     */
    public function getCommits(string $repoId, int $limit = 10): array {
        // Mock data returning associative array
        $commits = [];
        for ($i = 0; $i < $limit; $i++) {
            $commits[] = [
                'hash' => md5(uniqid()),
                'author' => 'Developer ' . $i,
                'message' => 'Fix bug #' . rand(100, 999),
                'date' => date('Y-m-d H:i:s', strtotime("-$i days"))
            ];
        }
        return $commits;
    }

    /**
     * Parse git log output
     */
    private function parseGitLog(string $rawOutput): array {
        $lines = explode("\n", $rawOutput);
        return array_map(function($line) {
            return trim($line);
        }, $lines);
    }

    private function executeCommand(string $cmd) {
        // In a real app, use proc_open or exec
        // Here we simulate randomness
        if (rand(0, 10) > 8) {
            throw new Exception("Git process timeout or network error.");
        }
        return "Cloning into 'repo'...\nUnpacking objects: 100% (50/50), done.";
    }
}

// --------------------------------------------------------------------------
// Example Usage Script
// --------------------------------------------------------------------------

// Autoload simulation
require_once 'vendor/autoload.php';

echo "PHP Git Manager Demo\n";
echo "PHP Version: " . phpversion() . "\n";
echo "----------------------\n";

$manager = new GitManager();

// Test Clone
$result = $manager->cloneRepository('https://github.com/laravel/laravel.git', 'xdnote');
print_r($result);

// Test Commits
echo "\nFetching recent commits:\n";
$commits = $manager->getCommits('123', 5);

foreach ($commits as $commit) {
    echo sprintf(
        "[%s] %s - %s\n", 
        substr($commit['hash'], 0, 7), 
        $commit['date'], 
        $commit['message']
    );
}

// Array destructuring (PHP 7.1+)
['status' => $status, 'message' => $msg] = $result;

if ($status === 'success') {
    echo "\nGreat success!";
} else {
    echo "\nSomething went wrong: " . ($msg ?? 'Unknown error');
}

// Anonymous Class (PHP 7+)
$logger = new class {
    public function log($msg) {
        echo "[LOG] " . $msg . "\n";
    }
};

$logger->log("Script finished execution.");
?>