import 'dart:async';
import 'dart:convert';
import 'dart:math';

/// Code Viewer Core Library
/// Demonstrating Classes, Mixins, Async, and Streams
void main() async {
  print('Starting GitCodeViewer Dart Engine...');

  final viewer = CodeViewerApp();
  
  // Initialize app
  await viewer.initialize();

  // Create some dummy repositories
  final repo1 = Repository(
    id: '1',
    name: 'flutter_engine',
    url: 'https://github.com/flutter/engine',
    isPrivate: false,
  );

  final repo2 = Repository(
    id: '2',
    name: 'personal_notes',
    url: 'https://github.com/user/notes',
    isPrivate: true,
  );

  viewer.addRepository(repo1);
  viewer.addRepository(repo2);

  // Demonstrate Stream
  print('\nStarting Sync Stream:');
  viewer.syncStream.listen((event) {
    print('[Stream] $event');
  });

  // Trigger some actions
  await viewer.syncAll();
  
  print('\nGenerating stats...');
  viewer.printStats();

  print('\nDart Engine Stopped.');
}

// Interface definition
abstract class Searchable {
  bool matches(String query);
}

// Mixin for logging
mixin Logger {
  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] $message');
  }
}

// Data Class for Repository
class Repository implements Searchable {
  final String id;
  final String name;
  final String url;
  final bool isPrivate;
  DateTime? lastSynced;

  Repository({
    required this.id,
    required this.name,
    required this.url,
    this.isPrivate = false,
  });

  @override
  bool matches(String query) {
    return name.toLowerCase().contains(query.toLowerCase());
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'private': isPrivate,
  };

  @override
  String toString() => '$name ($url) [${isPrivate ? "Private" : "Public"}]';
}

// Main App Controller
class CodeViewerApp with Logger {
  final List<Repository> _repos = [];
  final StreamController<String> _syncController = StreamController<String>();

  Stream<String> get syncStream => _syncController.stream;

  Future<void> initialize() async {
    log('Initializing services...');
    // Simulate delay
    await Future.delayed(Duration(milliseconds: 500));
    log('Services ready.');
  }

  void addRepository(Repository repo) {
    _repos.add(repo);
    log('Added repository: ${repo.name}');
  }

  Future<void> syncAll() async {
    log('Syncing ${_repos.length} repositories...');
    
    for (var repo in _repos) {
      _syncController.add('Starting sync for ${repo.name}...');
      
      // Simulate network request
      try {
        await _fakeNetworkCall();
        repo.lastSynced = DateTime.now();
        _syncController.add('✅ Synced ${repo.name}');
      } catch (e) {
        _syncController.add('❌ Failed to sync ${repo.name}: $e');
      }
    }
  }

  Future<void> _fakeNetworkCall() async {
    final random = Random();
    await Future.delayed(Duration(milliseconds: 300 + random.nextInt(500)));
    if (random.nextDouble() < 0.1) {
      throw Exception('Network timeout');
    }
  }

  void printStats() {
    print('--- App Stats ---');
    print('Total Repos: ${_repos.length}');
    final privateCount = _repos.where((r) => r.isPrivate).length;
    print('Private: $privateCount');
    print('Public: ${_repos.length - privateCount}');
    
    // Using fold for calculation
    final totalNameLength = _repos.fold<int>(0, (sum, r) => sum + r.name.length);
    print('Total char count in names: $totalNameLength');
    print('-----------------');
  }

  void dispose() {
    _syncController.close();
  }
}

// Enum extension (Dart 2.17+)
enum ThemeMode {
  system,
  light,
  dark;

  String get label {
    switch (this) {
      case ThemeMode.system: return 'Follow System';
      case ThemeMode.light: return 'Light Theme';
      case ThemeMode.dark: return 'Dark Theme';
    }
  }
}