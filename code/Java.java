package com.example.api;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * REST API with records, sealed interfaces, and streams.
 */
public class UserController {

    // Sealed interface for API responses
    sealed interface ApiResult<T> permits Success, Failure {
        record Success<T>(T data, long timestamp) implements ApiResult<T> {}
        record Failure<T>(String error, int code) implements ApiResult<T> {}
    }

    // Domain model
    record User(String id, String name, String email, Role role, List<String> permissions) {
        enum Role { ADMIN, EDITOR, VIEWER }

        boolean hasPermission(String perm) {
            return permissions.contains(perm) || role == Role.ADMIN;
        }

        User withRole(Role newRole) {
            return new User(id, name, email, newRole, permissions);
        }
    }

    record PageRequest(int page, int size, String sortBy) {
        PageRequest {
            if (page < 0) throw new IllegalArgumentException("page must be >= 0");
            if (size < 1 || size > 100) throw new IllegalArgumentException("size must be 1-100");
        }
    }

    record Page<T>(List<T> items, long total, int page, int totalPages) {}

    // Repository
    private final Map<String, User> users = new ConcurrentHashMap<>();

    public Page<User> findAll(PageRequest req) {
        var sorted = users.values().stream()
            .sorted(Comparator.comparing(u -> switch (req.sortBy()) {
                case "name" -> u.name();
                case "email" -> u.email();
                default -> u.id();
            }))
            .toList();

        int total = sorted.size();
        int totalPages = (int) Math.ceil((double) total / req.size());
        int start = req.page() * req.size();
        var items = sorted.stream().skip(start).limit(req.size()).toList();

        return new Page<>(items, total, req.page(), totalPages);
    }

    public Optional<User> findById(String id) {
        return Optional.ofNullable(users.get(id));
    }

    public List<User> findByRole(User.Role role) {
        return users.values().stream()
            .filter(u -> u.role() == role)
            .collect(Collectors.toList());
    }

    public Map<User.Role, Long> countByRole() {
        return users.values().stream()
            .collect(Collectors.groupingBy(User::role, Collectors.counting()));
    }

    public User create(String name, String email, User.Role role, List<String> perms) {
        var id = UUID.randomUUID().toString();
        var user = new User(id, name, email, role, List.copyOf(perms));
        users.put(id, user);
        return user;
    }

    public static void main(String[] args) {
        var ctrl = new UserController();
        ctrl.create("Alice", "alice@example.com", User.Role.ADMIN, List.of("read", "write"));
        ctrl.create("Bob", "bob@example.com", User.Role.EDITOR, List.of("read", "write"));
        ctrl.create("Charlie", "charlie@example.com", User.Role.VIEWER, List.of("read"));

        var page = ctrl.findAll(new PageRequest(0, 10, "name"));
        System.out.printf("Found %d users (page %d/%d)%n", page.total(), page.page() + 1, page.totalPages());

        ctrl.countByRole().forEach((role, count) ->
            System.out.printf("  %s: %d%n", role, count));
    }
}
