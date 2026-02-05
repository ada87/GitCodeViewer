package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"sync"
	"time"
)

// Constants
const (
	AppName    = "GitCodeViewer-Backend"
	ApiVersion = "v1.0"
	Port       = ":8080"
)

// Repository struct with JSON tags
type Repository struct {
	ID          int       `json:"id"`
	Name        string    `json:"name"`
	FullName    string    `json:"full_name"`
	Description string    `json:"description"`
	Private     bool      `json:"private"`
	Stars       int       `json:"stargazers_count"`
	Language    string    `json:"language"`
	UpdatedAt   time.Time `json:"updated_at"`
}

// Service interface
type RepoService interface {
	GetRepo(ctx context.Context, owner, repo string) (*Repository, error)
	ListRepos(ctx context.Context, user string) ([]Repository, error)
}

// GitHubService implementation
type GitHubService struct {
	client *http.Client
}

func NewGitHubService() *GitHubService {
	return &GitHubService{
		client: &http.Client{Timeout: 10 * time.Second},
	}
}

func (s *GitHubService) GetRepo(ctx context.Context, owner, name string) (*Repository, error) {
	url := fmt.Sprintf("https://api.github.com/repos/%s/%s", owner, name)
	
	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, err
	}
	
	resp, err := s.client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("API request failed with status: %d", resp.StatusCode)
	}

	var repo Repository
	if err := json.NewDecoder(resp.Body).Decode(&repo); err != nil {
		return nil, err
	}

	return &repo, nil
}

// Worker function for concurrency demo
func repoWorker(id int, jobs <-chan string, results chan<- string, wg *sync.WaitGroup) {
	defer wg.Done()
	for repoName := range jobs {
		// Simulate processing time
		time.Sleep(time.Millisecond * 500)
		results <- fmt.Sprintf("Worker %d processed repo: %s", id, repoName)
	}
}

func main() {
	// Setup logging
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	log.Printf("Starting %s %s...\n", AppName, ApiVersion)

	// Context with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	svc := NewGitHubService()

	// Example: Fetch generic repo info
	fmt.Println("Fetching repo info for facebook/react...")
	repo, err := svc.GetRepo(ctx, "facebook", "react")
	if err != nil {
		log.Printf("Error fetching repo: %v\n", err)
	} else {
		printRepoInfo(repo)
	}

	// Concurrency Demo: Processing queue
	fmt.Println("\n--- Starting Background Processing Queue ---")
	
	jobs := make(chan string, 10)
	results := make(chan string, 10)
	var wg sync.WaitGroup

	// Start 3 workers
	for w := 1; w <= 3; w++ {
		wg.Add(1)
		go repoWorker(w, jobs, results, &wg)
	}

	// Send jobs
	repoList := []string{"vuejs/vue", "angular/angular", "sveltejs/svelte", "solidjs/solid"}
	for _, name := range repoList {
		jobs <- name
	}
	close(jobs)

	// Close results channel when all workers are done
	go func() {
		wg.Wait()
		close(results)
	}()

	// Collect results
	for res := range results {
		fmt.Println(res)
	}

	// Simple HTTP Server
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{"status": "ok", "uptime": "100%"})
	})

	log.Printf("Server listening on %s (Demo mode, not actually binding port in this file)", Port)
	// log.Fatal(http.ListenAndServe(Port, nil))
}

func printRepoInfo(r *Repository) {
	fmt.Println("------------------------------------------------")
	fmt.Printf("📦 %s (ID: %d)\n", r.FullName, r.ID)
	fmt.Printf("⭐ Stars: %d | 🗣️ Language: %s\n", r.Stars, r.Language)
	fmt.Printf("📝 Desc: %s\n", r.Description)
	fmt.Printf("🔒 Private: %v\n", r.Private)
	fmt.Println("------------------------------------------------")
}

// Utility to verify file existence
func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

// Interfaces and Struct embedding
type Reader interface {
	Read(p []byte) (n int, err error)
}

type Writer interface {
	Write(p []byte) (n int, err error)
}

type ReadWriter interface {
	Reader
	Writer
}