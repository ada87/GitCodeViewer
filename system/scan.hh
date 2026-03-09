#ifndef GITCODE_DIRECTORY_SCANNER_HH
#define GITCODE_DIRECTORY_SCANNER_HH

#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <functional>
#include <optional>
#include <string>
#include <vector>

namespace gitcode::scan {

struct IgnoreRule {
  std::string pattern;
  bool directory_only = false;
};

struct ScanRules {
  bool include_hidden = false;
  bool follow_symlinks = false;
  std::vector<IgnoreRule> ignore_rules;
  std::vector<std::string> allowed_extensions;
  std::size_t max_files = 10000;
};

struct ScanEntry {
  std::filesystem::path relative_path;
  std::uintmax_t size = 0;
  bool is_directory = false;
};

struct ScanStatistics {
  std::size_t visited = 0;
  std::size_t indexed = 0;
  std::size_t skipped = 0;
};

struct ScanResult {
  std::filesystem::path root;
  std::vector<ScanEntry> entries;
  std::vector<std::filesystem::path> skipped_paths;
  ScanStatistics statistics;
};

class DirectoryScanner {
 public:
  using ProgressCallback = std::function<void(const ScanEntry& entry)>;

  explicit DirectoryScanner(ScanRules rules = {});

  void SetProgressCallback(ProgressCallback callback);
  [[nodiscard]] const ScanRules& Rules() const;
  [[nodiscard]] ScanResult Scan(const std::filesystem::path& root) const;

 private:
  [[nodiscard]] bool ShouldSkip(const std::filesystem::path& relative_path,
                                bool is_directory) const;
  [[nodiscard]] bool MatchesExtension(const std::filesystem::path& path) const;

  ScanRules rules_;
  ProgressCallback callback_;
};

class IgnoreMatcher {
 public:
  explicit IgnoreMatcher(std::vector<IgnoreRule> rules = {});

  [[nodiscard]] bool Matches(std::string_view relative_path,
                             bool is_directory) const;
  [[nodiscard]] std::size_t RuleCount() const;
  [[nodiscard]] bool Empty() const;

 private:
  std::vector<IgnoreRule> rules_;
};

}  // namespace gitcode::scan

#endif  // GITCODE_DIRECTORY_SCANNER_HH