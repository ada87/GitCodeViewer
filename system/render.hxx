#ifndef GITCODE_RENDER_PREVIEW_HXX
#define GITCODE_RENDER_PREVIEW_HXX

#include <string>
#include <string_view>
#include <vector>

namespace gitcode::render {

enum class Tone {
  kNeutral,
  kSoftAccent,
  kWarning,
};

struct TitlePresentation {
  std::string text;
  Tone tone = Tone::kNeutral;
  bool underline = false;
  bool center_aligned = true;
};

struct PreviewLine {
  int number = 0;
  std::string text;
  bool highlighted = false;
};

struct RenderSpan {
  std::string text;
  Tone tone = Tone::kNeutral;
};

struct PreviewDocument {
  std::string language;
  bool fold_gutter_visible = false;
  std::vector<PreviewLine> lines;
};

struct PreviewSettings {
  bool phone_layout = true;
  bool clickable_title = true;
  bool fold_supported = false;
};

struct ViewportMetrics {
  int width = 0;
  int height = 0;
  bool compact = false;
};

struct Palette {
  std::string foreground;
  std::string muted;
  std::string soft_accent;
  std::string warning;
};

class PreviewRenderer {
 public:
  explicit PreviewRenderer(Palette palette = {});

  [[nodiscard]] TitlePresentation BuildTitle(std::string_view workspace_name,
                                             const PreviewSettings& settings,
                                             const ViewportMetrics& viewport) const;
  [[nodiscard]] PreviewDocument BuildDocument(std::string_view language,
                                              const PreviewSettings& settings,
                                              const std::vector<std::string>& source_lines) const;

 private:
  Palette palette_;
};

[[nodiscard]] TitlePresentation BuildMobileTitle(std::string_view workspace_name,
                                                 bool clickable);
[[nodiscard]] TitlePresentation BuildTabletTitle(std::string_view workspace_name);
[[nodiscard]] PreviewDocument BuildCodePreview(std::string_view language,
                                               bool fold_supported,
                                               const std::vector<std::string>& source_lines);
[[nodiscard]] std::string RenderPlainTextNotice(std::string_view extension);
[[nodiscard]] std::string RenderLineNumber(int line_number);
[[nodiscard]] std::string RenderStatusBadge(Tone tone,
                                            std::string_view text);
[[nodiscard]] RenderSpan RenderLanguageChip(std::string_view language,
                                            bool legacy_mode);
[[nodiscard]] RenderSpan RenderSyncStatus(bool stale);
[[nodiscard]] Palette DefaultPalette();
[[nodiscard]] ViewportMetrics ClassifyViewport(int width,
                                               int height);

}  // namespace gitcode::render

#endif  // GITCODE_RENDER_PREVIEW_HXX