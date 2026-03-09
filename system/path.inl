#pragma once

#include <algorithm>
#include <cctype>
#include <string>
#include <string_view>
#include <vector>

namespace gitcode::path {

inline std::string TrimWhitespace(std::string_view value) {
  std::string result(value);
  result.erase(result.begin(), std::find_if(result.begin(), result.end(), [](unsigned char ch) {
    return !std::isspace(ch);
  }));
  result.erase(std::find_if(result.rbegin(), result.rend(), [](unsigned char ch) {
    return !std::isspace(ch);
  }).base(), result.end());
  return result;
}

inline std::string ToLowerCopy(std::string_view value) {
  std::string result(value);
  std::transform(result.begin(), result.end(), result.begin(), [](unsigned char ch) {
    return static_cast<char>(std::tolower(ch));
  });
  return result;
}

inline std::vector<std::string> SplitSegments(std::string_view value) {
  std::vector<std::string> segments;
  std::string current;
  for (char ch : value) {
    if (ch == '/' || ch == '\\') {
      if (!current.empty()) {
        segments.push_back(current);
        current.clear();
      }
      continue;
    }
    current.push_back(ch);
  }
  if (!current.empty()) {
    segments.push_back(current);
  }
  return segments;
}

inline std::string JoinSegments(const std::vector<std::string>& segments,
                                std::string_view separator) {
  std::string joined;
  for (size_t index = 0; index < segments.size(); ++index) {
    if (index > 0) {
      joined += separator;
    }
    joined += segments[index];
  }
  return joined;
}

inline bool HasTrailingSlash(std::string_view value) {
  return !value.empty() && (value.back() == '/' || value.back() == '\\');
}

inline std::string FileStem(std::string_view value) {
  const auto normalized = ToLowerCopy(value);
  const auto offset = normalized.find_last_of('/');
  const auto basename = offset == std::string::npos ? normalized : normalized.substr(offset + 1);
  const auto dot = basename.find_last_of('.');
  return dot == std::string::npos ? basename : basename.substr(0, dot);
}

inline std::string NormalizeDisplayPath(std::string_view value) {
  const auto segments = SplitSegments(TrimWhitespace(value));
  return JoinSegments(segments, "/");
}

inline bool IsReadmePath(std::string_view value) {
  const auto stem = FileStem(value);
  return stem == "readme" || stem == "changelog" || stem == "license";
}

}  // namespace gitcode::path