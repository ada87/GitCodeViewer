#pragma once

#include <algorithm>
#include <cstddef>
#include <stdexcept>
#include <utility>
#include <vector>

namespace gitcode::util {

template <typename T>
class RecentRingBuffer {
 public:
  explicit RecentRingBuffer(std::size_t capacity)
      : capacity_(capacity) {
    if (capacity_ == 0) {
      throw std::invalid_argument("capacity must be greater than zero");
    }
  }

  void Push(T value) {
    if (items_.size() == capacity_) {
      items_.erase(items_.begin());
    }
    items_.push_back(std::move(value));
  }

  [[nodiscard]] const T& Front() const {
    return items_.front();
  }

  [[nodiscard]] const T& Back() const {
    return items_.back();
  }

  [[nodiscard]] bool Empty() const {
    return items_.empty();
  }

  [[nodiscard]] std::size_t Size() const {
    return items_.size();
  }

  [[nodiscard]] std::size_t Capacity() const {
    return capacity_;
  }

  [[nodiscard]] bool Contains(const T& value) const {
    return std::find(items_.begin(), items_.end(), value) != items_.end();
  }

  [[nodiscard]] std::vector<T> Snapshot() const {
    return items_;
  }

  [[nodiscard]] std::vector<T> Tail(std::size_t count) const {
    if (count >= items_.size()) {
      return items_;
    }
    return std::vector<T>(items_.end() - static_cast<std::ptrdiff_t>(count), items_.end());
  }

  void Clear() {
    items_.clear();
  }

 private:
  std::size_t capacity_;
  std::vector<T> items_;
};

template <typename T>
inline RecentRingBuffer<T> MakeRecentRingBuffer(std::size_t capacity,
                                                std::vector<T> seed_values) {
  RecentRingBuffer<T> buffer(capacity);
  for (auto& value : seed_values) {
    buffer.Push(std::move(value));
  }
  return buffer;
}

}  // namespace gitcode::util