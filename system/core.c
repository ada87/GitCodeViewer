#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Define constants
#define MAX_BUFFER 1024
#define APP_NAME "GitCodeViewer"
#define VERSION "1.0.0"

// Structure definition
typedef struct {
    int id;
    char name[100];
    char language[50];
    long size_bytes;
    int is_public;
} Repository;

// Function prototypes
void print_header();
Repository* create_repo(int id, const char* name, const char* lang);
void print_repo_details(const Repository* repo);
void simulate_clone(const Repository* repo);
void free_repo(Repository* repo);
int calculate_lines_of_code(const char* filename);

/**
 * Main entry point of the application
 */
int main(int argc, char *argv[]) {
    srand(time(NULL));

    print_header();

    printf("Initializing core engine...\n");

    // Array of mock repositories
    Repository* repos[5];
    
    repos[0] = create_repo(1, "react", "JavaScript");
    repos[1] = create_repo(2, "linux", "C");
    repos[2] = create_repo(3, "rust", "Rust");
    repos[3] = create_repo(4, "tensorflow", "C++");
    repos[4] = create_repo(5, "GitCodeViewer", "TypeScript");

    printf("\n[INFO] Found %d repositories in local database.\n\n", 5);

    // Iterate and process
    for (int i = 0; i < 5; i++) {
        if (repos[i] != NULL) {
            print_repo_details(repos[i]);
            
            // Simulate random processing
            if (rand() % 2 == 0) {
                simulate_clone(repos[i]);
            }
            
            free_repo(repos[i]);
        }
    }

    // File I/O example
    FILE *fp;
    char buffer[MAX_BUFFER];

    fp = fopen("config.ini", "w");
    if (fp != NULL) {
        fprintf(fp, "[Settings]\nTheme=Dark\nFontSize=14\n");
        fclose(fp);
        printf("\n[Config] Configuration saved successfully.\n");
    } else {
        perror("Error opening file");
    }

    printf("\nExiting %s v%s. Have a nice day!\n", APP_NAME, VERSION);
    return 0;
}

void print_header() {
    printf("=======================================\n");
    printf("      %s - Core Engine (C)     \n", APP_NAME);
    printf("=======================================\n");
}

Repository* create_repo(int id, const char* name, const char* lang) {
    Repository* r = (Repository*)malloc(sizeof(Repository));
    if (r == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    
    r->id = id;
    strncpy(r->name, name, sizeof(r->name) - 1);
    strncpy(r->language, lang, sizeof(r->language) - 1);
    r->size_bytes = rand() % 1000000 + 1024; // Random size
    r->is_public = 1;
    
    return r;
}

void print_repo_details(const Repository* repo) {
    printf("Repo ID: %d\n", repo->id);
    printf("  Name:     %s\n", repo->name);
    printf("  Language: %s\n", repo->language);
    printf("  Size:     %.2f KB\n", repo->size_bytes / 1024.0);
    printf("---------------------------------------\n");
}

void simulate_clone(const Repository* repo) {
    printf(">> Cloning %s... ", repo->name);
    
    // Simulate progress bar
    for(int i=0; i<5; i++) {
        printf(".");
    }
    printf(" Done! (%.2f KB)\n", repo->size_bytes / 1024.0);
}

void free_repo(Repository* repo) {
    if (repo != NULL) {
        free(repo);
    }
}

int calculate_lines_of_code(const char* filename) {
    // Dummy implementation
    return 100;
}