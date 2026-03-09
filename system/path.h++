#ifndef GITCODE_PATH_TOOLS_H_PLUS_PLUS
#define GITCODE_PATH_TOOLS_H_PLUS_PLUS

#include <filesystem>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace gitcode::path {

enum class PathKind {
  kUnknown,
  kDirectory,
  kSourceFile,
  kConfigFile,
  kDocument,
  kGenerated,
};

struct ParsedPath {
  std::filesystem::path full_path;
  std::filesystem::path relative_path;
  std::vector<std::string> segments;
  std::string base_name;
  std::string extension;
  PathKind kind = PathKind::kUnknown;
};

struct PathDiff {
  std::vector<std::string> shared_segments;
  std::vector<std::string> removed_segments;
  std::vector<std::string> added_segments;
};

struct WorkspacePathPolicy {
  bool treat_readme_as_document = true;
  bool hide_generated_directories = true;
  bool collapse_duplicate_slashes = true;
};

class PathMatcher {
 public:
  explicit PathMatcher(WorkspacePathPolicy policy = {});

  [[nodiscard]] bool IsHiddenPath(std::string_view value) const;
  [[nodiscard]] bool IsWorkspaceMetadataFile(std::string_view value) const;
  [[nodiscard]] bool IsGeneratedArtifact(std::string_view value) const;
  [[nodiscard]] bool IsReadmePath(std::string_view value) const;
  [[nodiscard]] PathKind DetectPathKind(std::string_view value) const;

 private:
  WorkspacePathPolicy policy_;
};

[[nodiscard]] std::vector<std::string> SplitSegments(std::string_view value);
[[nodiscard]] std::string JoinSegments(const std::vector<std::string>& segments,
                                       std::string_view separator);
[[nodiscard]] std::filesystem::path EnsureForwardSlashes(const std::filesystem::path& path);
[[nodiscard]] std::filesystem::path ReplaceExtension(const std::filesystem::path& path,
                                                     std::string_view extension);
[[nodiscard]] std::string BaseName(std::string_view value);
[[nodiscard]] std::string DirectoryName(std::string_view value);
[[nodiscard]] std::string ExtensionWithoutDot(std::string_view value);
[[nodiscard]] std::string NormalizeDisplayPath(std::string_view value);
[[nodiscard]] std::string CollapseDotSegments(std::string_view value);
[[nodiscard]] std::string FileStem(std::string_view value);
[[nodiscard]] bool HasTrailingSlash(std::string_view value);
[[nodiscard]] PathDiff DiffPaths(std::string_view from,
                                 std::string_view to);
[[nodiscard]] ParsedPath ParsePath(const std::filesystem::path& root,
                                   const std::filesystem::path& full_path);
[[nodiscard]] std::optional<std::filesystem::path> CommonPrefix(
    const std::vector<std::filesystem::path>& paths);
[[nodiscard]] std::filesystem::path ToRelativePath(const std::filesystem::path& root,
                                                   const std::filesystem::path& full_path);

}  // namespace gitcode::path

#endif  // GITCODE_PATH_TOOLS_H_PLUS_PLUS