#include <algorithm>
#include <iomanip>
#include <iostream>
#include <map>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>

namespace gitcode::report {

struct FileEntry {
  std::string path;
  std::string language;
  int lines;
  bool fold_enabled;
};

std::map<std::string, int> CountByLanguage(const std::vector<FileEntry>& files) {
  std::map<std::string, int> counts;
  for (const auto& file : files) {
    counts[file.language] += 1;
  }
  return counts;
}

std::string RenderTableRow(const FileEntry& file) {
  std::ostringstream stream;
  stream << std::left << std::setw(34) << file.path
         << std::setw(14) << file.language
         << std::setw(8) << file.lines
         << (file.fold_enabled ? "fold" : "plain");
  return stream.str();
}

std::string BuildSummary(const std::vector<FileEntry>& files) {
  std::ostringstream stream;
  const auto counts = CountByLanguage(files);
  const auto total_lines = std::accumulate(files.begin(), files.end(), 0,
      [](int sum, const FileEntry& file) { return sum + file.lines; });

  stream << "Workspace Fixture Report\n";
  stream << "=======================\n";
  stream << "files: " << files.size() << "\n";
  stream << "total lines: " << total_lines << "\n\n";

  stream << "language counts\n";
  for (const auto& [language, count] : counts) {
    stream << "  - " << std::setw(12) << std::left << language << count << '\n';
  }

  stream << "\npreview\n";
  stream << std::left << std::setw(34) << "path"
         << std::setw(14) << "language"
         << std::setw(8) << "lines"
         << "mode\n";

  for (const auto& file : files) {
    stream << RenderTableRow(file) << '\n';
  }
  return stream.str();
}

}  // namespace gitcode::report

int main() {
  using gitcode::report::FileEntry;

  std::vector<FileEntry> files = {
      {"src/utils/string.ts", "typescript", 146, true},
      {"web/codemirror/core.ts", "typescript", 288, true},
      {"docs/LanguageSupport.md", "markdown", 164, false},
      {"Sample_typescript_ets.ets", "typescript", 109, true},
      {"Sample_jinja_j2.j2", "jinja", 84, false},
      {"Sample_xml_csproj.csproj", "xml", 88, false},
  };

  std::ranges::sort(files, [](const FileEntry& lhs, const FileEntry& rhs) {
    if (lhs.language == rhs.language) {
      return lhs.path < rhs.path;
    }
    return lhs.language < rhs.language;
  });

  std::cout << gitcode::report::BuildSummary(files);
  return 0;
}
