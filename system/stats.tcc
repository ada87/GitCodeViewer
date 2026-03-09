#pragma once

#include <algorithm>
#include <map>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

namespace gitcode::stats {

template <typename Key>
class Histogram {
 public:
  void Add(const Key& key) {
    ++counts_[key];
  }

  void AddMany(const std::vector<Key>& keys) {
    for (const auto& key : keys) {
      Add(key);
    }
  }

  [[nodiscard]] std::size_t CountFor(const Key& key) const {
    const auto it = counts_.find(key);
    return it == counts_.end() ? 0u : it->second;
  }

  [[nodiscard]] std::vector<std::pair<Key, std::size_t>> Entries() const {
    return {counts_.begin(), counts_.end()};
  }

  [[nodiscard]] bool Empty() const {
    return counts_.empty();
  }

  [[nodiscard]] std::size_t UniqueKeys() const {
    return counts_.size();
  }

  void Clear() {
    counts_.clear();
  }

 private:
  std::map<Key, std::size_t> counts_;
};

template <typename Key>
inline Histogram<Key> BuildHistogram(const std::vector<Key>& keys) {
  Histogram<Key> histogram;
  histogram.AddMany(keys);
  return histogram;
}

template <typename Key>
inline std::vector<Key> KeysWithCountAtLeast(const Histogram<Key>& histogram,
                                             std::size_t minimum_count) {
  std::vector<Key> keys;
  for (const auto& entry : histogram.Entries()) {
    if (entry.second >= minimum_count) {
      keys.push_back(entry.first);
    }
  }
  return keys;
}

template <typename Key>
inline std::vector<std::pair<Key, std::size_t>> SortEntriesDescending(
    const Histogram<Key>& histogram) {
  auto entries = histogram.Entries();
  std::sort(entries.begin(), entries.end(), [](const auto& lhs, const auto& rhs) {
    if (lhs.second == rhs.second) {
      return lhs.first < rhs.first;
    }
    return lhs.second > rhs.second;
  });
  return entries;
}

}  // namespace gitcode::stats