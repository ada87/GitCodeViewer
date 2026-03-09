package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

// Domain types

type User struct {
	ID        string    \`json:"id"\`
	Name      string    \`json:"name"\`
	Email     string    \`json:"email"\`
	Role      string    \`json:"role"\`
	CreatedAt time.Time \`json:"created_at"\`
}

type APIResponse struct {
	Success bool        \`json:"success"\`
	Data    interface{} \`json:"data,omitempty"\`
	Error   string      \`json:"error,omitempty"\`
}

// Thread-safe store

type Store struct {
	mu    sync.RWMutex
	users map[string]*User
}

func NewStore() *Store {
	return &Store{users: make(map[string]*User)}
}

func (s *Store) Get(id string) (*User, bool) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	u, ok := s.users[id]
	return u, ok
}

func (s *Store) List() []*User {
	s.mu.RLock()
	defer s.mu.RUnlock()
	result := make([]*User, 0, len(s.users))
	for _, u := range s.users {
		result = append(result, u)
	}
	return result
}

func (s *Store) Create(u *User) {
	s.mu.Lock()
	defer s.mu.Unlock()
	u.CreatedAt = time.Now()
	s.users[u.ID] = u
}

// Background worker with channels

func startWorker(ctx context.Context, jobs <-chan string, wg *sync.WaitGroup) {
	defer wg.Done()
	for {
		select {
		case <-ctx.Done():
			log.Println("Worker shutting down")
			return
		case job, ok := <-jobs:
			if !ok {
				return
			}
			log.Printf("Processing job: %s", job)
			time.Sleep(100 * time.Millisecond)
		}
	}
}

// HTTP handlers

func jsonResponse(w http.ResponseWriter, status int, resp APIResponse) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(resp)
}

func main() {
	store := NewStore()
	store.Create(&User{ID: "1", Name: "Alice", Email: "alice@example.com", Role: "admin"})
	store.Create(&User{ID: "2", Name: "Bob", Email: "bob@example.com", Role: "user"})

	// Start background workers
	ctx, cancel := context.WithCancel(context.Background())
	jobs := make(chan string, 100)
	var wg sync.WaitGroup
	for i := 0; i < 3; i++ {
		wg.Add(1)
		go startWorker(ctx, jobs, &wg)
	}

	mux := http.NewServeMux()
	mux.HandleFunc("GET /api/users", func(w http.ResponseWriter, r *http.Request) {
		jsonResponse(w, http.StatusOK, APIResponse{Success: true, Data: store.List()})
	})
	mux.HandleFunc("GET /api/users/{id}", func(w http.ResponseWriter, r *http.Request) {
		user, ok := store.Get(r.PathValue("id"))
		if !ok {
			jsonResponse(w, 404, APIResponse{Error: "not found"})
			return
		}
		jsonResponse(w, 200, APIResponse{Success: true, Data: user})
	})

	srv := &http.Server{Addr: ":8080", Handler: mux}

	// Graceful shutdown
	go func() {
		sigCh := make(chan os.Signal, 1)
		signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)
		<-sigCh
		log.Println("Shutting down...")
		cancel()
		close(jobs)
		wg.Wait()
		srv.Shutdown(context.Background())
	}()

	fmt.Println("Server listening on :8080")
	if err := srv.ListenAndServe(); err != http.ErrServerClosed {
		log.Fatal(err)
	}
}
