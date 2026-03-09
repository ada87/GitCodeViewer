#ifndef GITCODE_WORKSPACE_INDEX_HPP
#define GITCODE_WORKSPACE_INDEX_HPP

#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

namespace gitcode::index {

struct FileRecord {
  std::filesystem::path relative_path;
  std::string language;
  std::string digest;
  std::uint32_t line_count = 0;
  bool fold_enabled = false;
};

struct WorkspaceRecord {
  std::string id;
  std::string name;
  std::string branch;
  std::filesystem::path root;
  std::vector<FileRecord> files;
};

struct IndexOptions {
  bool include_hidden = false;
  bool prefer_cached_tree = true;
  std::size_t max_preview_lines = 120;
  std::size_t max_indexed_files = 10000;
};

class WorkspaceIndex {
 public:
  explicit WorkspaceIndex(IndexOptions options = {});

  void SetWorkspaceRoot(std::filesystem::path root);
  void Reserve(std::size_t count);
  void AddFile(FileRecord file);
  void Clear();

  [[nodiscard]] std::size_t FileCount() const;
  [[nodiscard]] bool Empty() const;
  [[nodiscard]] const std::filesystem::path& Root() const;
  [[nodiscard]] const IndexOptions& Options() const;
  [[nodiscard]] const std::vector<FileRecord>& Files() const;

  [[nodiscard]] std::optional<FileRecord> FindByPath(
      std::string_view relative_path) const;
  [[nodiscard]] std::vector<FileRecord> FilesForLanguage(
      std::string_view language) const;
  [[nodiscard]] std::vector<FileRecord> FilesWithFoldSupport() const;
  [[nodiscard]] std::unordered_map<std::string, std::size_t> CountByLanguage() const;

  [[nodiscard]] WorkspaceRecord Snapshot(std::string id,
                                         std::string name,
                                         std::string branch) const;

 private:
  IndexOptions options_;
  std::filesystem::path root_;
  std::vector<FileRecord> files_;
};

[[nodiscard]] std::string NormalizeLanguageAlias(std::string_view extension);
[[nodiscard]] bool SupportsFoldGutter(std::string_view language);
[[nodiscard]] bool IsLegacyLanguage(std::string_view language);
[[nodiscard]] std::string BuildPreviewTitle(std::string_view workspace_name,
                                            std::string_view file_name);
[[nodiscard]] std::string ShortDigest(std::string_view digest);
[[nodiscard]] std::size_t EstimatePreviewLines(std::size_t line_count,
                                               const IndexOptions& options);

}  // namespace gitcode::index

#endif  // GITCODE_WORKSPACE_INDEX_HPP
