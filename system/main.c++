#include <filesystem>
#include <fstream>
#include <iostream>
#include <optional>
#include <string>
#include <string_view>
#include <unordered_set>
#include <vector>

namespace gitcode::cli {

struct Options {
  std::filesystem::path workspace_root;
  bool include_hidden = false;
  bool print_summary_only = false;
};

std::optional<Options> ParseArguments(int argc, char** argv) {
  Options options;
  for (int index = 1; index < argc; ++index) {
    std::string_view arg = argv[index];
    if (arg == "--all") {
      options.include_hidden = true;
      continue;
    }
    if (arg == "--summary") {
      options.print_summary_only = true;
      continue;
    }
    if (!arg.empty() && arg.front() == '-') {
      std::cerr << "unknown option: " << arg << std::endl;
      return std::nullopt;
    }
    options.workspace_root = std::filesystem::path(arg);
  }

  if (options.workspace_root.empty()) {
    std::cerr << "usage: workspace-index <repo-path> [--all] [--summary]" << std::endl;
    return std::nullopt;
  }
  return options;
}

bool ShouldInclude(const std::filesystem::directory_entry& entry, bool include_hidden) {
  const auto name = entry.path().filename().string();
  if (!include_hidden && !name.empty() && name.front() == '.') {
    return false;
  }
  static const std::unordered_set<std::string> ignored = {
      ".git", "node_modules", "build", "dist", ".turbo"};
  return ignored.find(name) == ignored.end();
}

std::vector<std::filesystem::path> CollectInterestingFiles(
    const std::filesystem::path& root,
    bool include_hidden) {
  std::vector<std::filesystem::path> files;
  for (const auto& entry : std::filesystem::recursive_directory_iterator(root)) {
    if (!entry.is_regular_file()) {
      continue;
    }
    if (!ShouldInclude(entry, include_hidden)) {
      continue;
    }
    const auto extension = entry.path().extension().string();
    if (extension == ".ts" || extension == ".tsx" || extension == ".md" ||
        extension == ".json" || extension == ".yml") {
      files.push_back(entry.path());
    }
  }
  return files;
}

void PrintWorkspaceSummary(const std::filesystem::path& root,
                           const std::vector<std::filesystem::path>& files) {
  std::cout << "workspace: " << root.string() << std::endl;
  std::cout << "indexed files: " << files.size() << std::endl;
  for (size_t index = 0; index < files.size() && index < 8; ++index) {
    std::cout << "  - " << files[index].lexically_relative(root).string() << std::endl;
  }
}

}  // namespace gitcode::cli

int main(int argc, char** argv) {
  const auto options = gitcode::cli::ParseArguments(argc, argv);
  if (!options) {
    return 1;
  }

  if (!std::filesystem::exists(options->workspace_root)) {
    std::cerr << "workspace does not exist: " << options->workspace_root << std::endl;
    return 2;
  }

  const auto files = gitcode::cli::CollectInterestingFiles(
      options->workspace_root, options->include_hidden);
  gitcode::cli::PrintWorkspaceSummary(options->workspace_root, files);

  if (options->print_summary_only) {
    return 0;
  }

  std::ofstream manifest(options->workspace_root / ".gitcode-index.txt");
  for (const auto& file : files) {
    manifest << file.lexically_relative(options->workspace_root).string() << '\n';
  }

  std::cout << "manifest written to .gitcode-index.txt" << std::endl;
  return 0;
}
