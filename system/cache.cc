#include <chrono>
#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

namespace gitcode::cache {

struct CachedDocument {
  std::string path;
  std::string language;
  std::string sha;
  std::chrono::system_clock::time_point opened_at;
  int line_count = 0;
};

class WorkspaceCacheStore {
 public:
  bool Put(std::string workspace_id, CachedDocument document) {
    auto& bucket = documents_[std::move(workspace_id)];
    bucket.emplace_back(std::move(document));
    return true;
  }

  std::optional<CachedDocument> FindByPath(
      std::string_view workspace_id,
      std::string_view path) const {
    const auto it = documents_.find(std::string(workspace_id));
    if (it == documents_.end()) {
      return std::nullopt;
    }
    for (const auto& document : it->second) {
      if (document.path == path) {
        return document;
      }
    }
    return std::nullopt;
  }

  size_t RemoveOlderThan(std::string_view workspace_id,
                         std::chrono::system_clock::time_point threshold) {
    const auto it = documents_.find(std::string(workspace_id));
    if (it == documents_.end()) {
      return 0;
    }

    auto& bucket = it->second;
    const auto original_size = bucket.size();
    bucket.erase(
        std::remove_if(bucket.begin(), bucket.end(), [&](const CachedDocument& doc) {
          return doc.opened_at < threshold;
        }),
        bucket.end());
    return original_size - bucket.size();
  }

  std::vector<std::string> ListLanguages(std::string_view workspace_id) const {
    std::vector<std::string> languages;
    const auto it = documents_.find(std::string(workspace_id));
    if (it == documents_.end()) {
      return languages;
    }
    for (const auto& document : it->second) {
      if (std::find(languages.begin(), languages.end(), document.language) == languages.end()) {
        languages.push_back(document.language);
      }
    }
    return languages;
  }

  size_t Size(std::string_view workspace_id) const {
    const auto it = documents_.find(std::string(workspace_id));
    return it == documents_.end() ? 0u : it->second.size();
  }

 private:
  std::unordered_map<std::string, std::vector<CachedDocument>> documents_;
};

}  // namespace gitcode::cache

int main() {
  using gitcode::cache::CachedDocument;
  using gitcode::cache::WorkspaceCacheStore;

  WorkspaceCacheStore store;
  const auto now = std::chrono::system_clock::now();

  store.Put("workspace-core", {"src/utils/string.ts", "typescript", "2c1f7a1", now, 146});
  store.Put("workspace-core", {"web/codemirror/core.ts", "typescript", "71a1ce4", now, 288});
  store.Put("workspace-core", {"docs/LanguageSupport.md", "markdown", "2eb3140", now, 164});

  const auto doc = store.FindByPath("workspace-core", "src/utils/string.ts");
  const auto languages = store.ListLanguages("workspace-core");

  if (doc) {
    return static_cast<int>(store.Size("workspace-core") + languages.size());
  }
  return 1;
}
