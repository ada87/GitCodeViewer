package com.xdnote.codeviewer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.time.LocalDateTime;
import java.io.Serializable;

/**
 * GitCode Viewer Backend Service Simulation
 * Demonstrates Java 8+ features, OOP, Generics, and Annotations.
 */
public class Java {

    public static void main(String[] args) {
        System.out.println("Starting Java Repo Service...");

        RepoService service = new RepoService();

        // Adding mock data
        service.addRepo(new Repository("101", "spring-boot", "Java", true));
        service.addRepo(new Repository("102", "react-native", "TypeScript", false));
        service.addRepo(new Repository("103", "linux-kernel", "C", false));

        // Stream API usage
        System.out.println("\n--- Public Repositories ---");
        List<Repository> publicRepos = service.findPublicRepos();
        publicRepos.forEach(System.out::println);

        // Optional usage
        System.out.println("\n--- Search Result ---");
        String searchId = "102";
        service.findRepoById(searchId).ifPresentOrElse(
            repo -> System.out.println("Found: " + repo.getName()),
            () -> System.out.println("Repo with ID " + searchId + " not found.")
        );

        // Lambda & sorting
        System.out.println("\n--- Sorted by Name ---");
        service.getAllRepos().stream()
            .sorted((r1, r2) -> r1.getName().compareToIgnoreCase(r2.getName()))
            .forEach(r -> System.out.println(r.getName() + " (" + r.getLanguage() + ")"));

        // Exception handling
        try {
            service.cloneRepo("999"); // Non-existent
        } catch (RepoNotFoundException e) {
            System.err.println("Error: " + e.getMessage());
        }
        
        // Polymorphism
        GitOperation pushOp = new PushOperation();
        GitOperation pullOp = new PullOperation();
        
        executeOperation(pushOp);
        executeOperation(pullOp);
    }
    
    public static void executeOperation(GitOperation op) {
        op.execute();
    }
}

// Custom Exception
class RepoNotFoundException extends Exception {
    public RepoNotFoundException(String message) {
        super(message);
    }
}

// Interface
interface Identifiable {
    String getId();
}

// Model Class
class Repository implements Identifiable, Serializable {
    private static final long serialVersionUID = 1L;
    
    private String id;
    private String name;
    private String language;
    private boolean isPrivate;
    private LocalDateTime createdAt;

    public Repository(String id, String name, String language, boolean isPrivate) {
        this.id = id;
        this.name = name;
        this.language = language;
        this.isPrivate = isPrivate;
        this.createdAt = LocalDateTime.now();
    }

    @Override
    public String getId() {
        return id;
    }

    public String getName() { return name; }
    public String getLanguage() { return language; }
    public boolean isPrivate() { return isPrivate; }

    @Override
    public String toString() {
        return String.format("Repo[id=%s, name=%s, lang=%s, private=%s]", 
            id, name, language, isPrivate);
    }
}

// Service Class
class RepoService {
    private Map<String, Repository> database = new HashMap<>();

    public void addRepo(Repository repo) {
        database.put(repo.getId(), repo);
    }

    public Optional<Repository> findRepoById(String id) {
        return Optional.ofNullable(database.get(id));
    }

    public List<Repository> getAllRepos() {
        return new ArrayList<>(database.values());
    }

    public List<Repository> findPublicRepos() {
        return database.values().stream()
                .filter(r -> !r.isPrivate())
                .collect(Collectors.toList());
    }

    public void cloneRepo(String id) throws RepoNotFoundException {
        if (!database.containsKey(id)) {
            throw new RepoNotFoundException("Repository " + id + " does not exist.");
        }
        System.out.println("Cloning repo " + id + "...");
        // Simulation of IO
        try { Thread.sleep(500); } catch (InterruptedException e) {}
        System.out.println("Clone complete.");
    }
}

// Abstract Class & Polymorphism
abstract class GitOperation {
    abstract void execute();
}

class PushOperation extends GitOperation {
    @Override
    void execute() {
        System.out.println(">> git push origin main");
        System.out.println("   Uploading objects... 100%");
    }
}

class PullOperation extends GitOperation {
    @Override
    void execute() {
        System.out.println(">> git pull origin main");
        System.out.println("   Fast-forward merge...");
    }
}

// Generics Example
class Response<T> {
    private T data;
    private int status;
    private String message;

    public Response(T data, int status, String message) {
        this.data = data;
        this.status = status;
        this.message = message;
    }

    public T getData() { return data; }
}