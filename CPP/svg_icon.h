/* LIST OF CONTENTS
 * - // CLASS APPLIED MACROS | 43
 * - // QML PROPERTIES | 47
 * - // SIGNALS | 67
 * - // PUBLIC METHODS | 83
 * - // PRIVATE METHODS | 123
 * - // PRIVATE MEMBERS | 146
 * END OF CONTENTS */

/**
 * @file svg_icon.h
 * @brief Declares the SvgIcon QQuickPaintedItem that paints an SVG with custom
 *        fill, stroke, and linear gradient properties.
 * @author Sebastian Ballesteros
 * @date 2026-07-18
 *
 * This probably need to be changed on the future to a QQuickItem or
 * an open gl element directly for performance as it has a lot of bloat
 * variables and functions inherited from the QQuickPaintedItem but
 * for the time being it is going to remain like this for simplicity and
 * lack of knowledge
 */
#ifndef SVG_ICON_H
#define SVG_ICON_H

#include <QColor>
#include <QDomDocument>
#include <QFile>
#include <QPainter>
#include <QQmlEngine>
#include <QQuickPaintedItem>
#include <QSvgRenderer>

/**
 * @class SvgIcon
 * @brief A QQuickPaintedItem that renders an SVG file with QML-bindable
 *        styling: fill/stroke color, stroke width, and linear gradients.
 *
 * Exposed to QML via QML_ELEMENT. Designed to mutate the SVG DOM in-memory
 * (via QDomDocument) and cache the result for fast repaints.
 */
class SvgIcon : public QQuickPaintedItem {
  // CLASS APPLIED MACROS
  Q_OBJECT
  QML_ELEMENT

  // QML PROPERTIES
  Q_PROPERTY(QString source READ getSource WRITE setSource NOTIFY sourceChanged)

  Q_PROPERTY(QColor svgFillColor READ getSvgFillColor WRITE setSvgFillColor
                 NOTIFY svgFillColorChanged)

  Q_PROPERTY(float svgStrokeWidth READ getSvgStrokeWidth WRITE setSvgStrokeWidth
                 NOTIFY svgStrokeWidthChanged)

  Q_PROPERTY(QColor svgStrokeColor READ getSvgStrokeColor WRITE
                 setSvgStrokeColor NOTIFY svgStrokeColorChanged)

  Q_PROPERTY(
      QVariantMap svgFillLinearGradient READ getSvgFillLinearGradient WRITE
          setSvgFillLinearGradient NOTIFY svgFillLinearGradientChanged)

  Q_PROPERTY(
      QVariantMap svgStrokeLinearGradient READ getSvgStrokeLinearGradient WRITE
          setSvgStrokeLinearGradient NOTIFY svgStrokeLinearGradientChanged)

  // SIGNALS
signals:
  /** @brief Emitted when @ref source changes. */
  void sourceChanged();
  /** @brief Emitted when @ref svgFillColor changes. */
  void svgFillColorChanged();
  /** @brief Emitted when @ref svgStrokeWidth changes. */
  void svgStrokeWidthChanged();
  /** @brief Emitted when @ref svgStrokeColor changes. */
  void svgStrokeColorChanged();
  /** @brief Emitted when @ref svgFillLinearGradient changes. */
  void svgFillLinearGradientChanged();
  /** @brief Emitted when @ref svgStrokeLinearGradient changes. */
  void svgStrokeLinearGradientChanged();

public:
  // PUBLIC METHODS

  /** @brief Default constructor, but the class is loaded on the first
   * paint as the wait is needed because qml assigns the values after
   * the element construction*/
  SvgIcon();

  /**
   * @brief Renders the SVG into the item's bounds.
   * @param painter The QPainter provided by the QML scene graph.
   *
   * On the first call, loads the file and applies all current style
   * properties. Subsequent calls just re-render the cached SVG.
   */
  void paint(QPainter *painter) override;

  /// @name Property setters and getters
  /// @{
  QString getSource() { return m_source; };
  void setSource(QString &source);

  QColor getSvgFillColor() { return m_svgFillColor; };
  void setSvgFillColor(QColor &svgFillColor);

  float getSvgStrokeWidth() { return m_svgStrokeWidth; };
  void setSvgStrokeWidth(float &svgStrokeWidth);

  QColor getSvgStrokeColor() { return m_svgStrokeColor; };
  void setSvgStrokeColor(QColor &svgStrokeColor);

  QVariantMap getSvgFillLinearGradient() { return m_svgFillLinearGradient; };
  void setSvgFillLinearGradient(QVariantMap &svgFillLinearGradient);

  QVariantMap getSvgStrokeLinearGradient() {
    return m_svgStrokeLinearGradient;
  };
  void setSvgStrokeLinearGradient(QVariantMap &svgStrokeLinearGradient);
  /// @}

private:
  // PRIVATE METHODS

  /**
   * @brief Recomputes the render viewport, accounting for stroke margins,
   * and leaves a default one when no margins
   * @return Effective stroke width in scene pixels for stroke calculations.
   */
  float updateViewPort();

  /// @brief Loads and parses the SVG file referenced by @ref m_source.
  void loadFile();

  /// @brief Applies @ref m_svgFillColor to the SVG.
  void addFillColor();
  /// @brief Applies @ref m_svgStrokeColor to the SVG.
  void addStrokeColor();
  /// @brief Applies @ref m_svgStrokeWidth to the SVG.
  void addStrokeWidth();
  /// @brief Injects a <linearGradient> for the fill if one is set.
  void addFillLinearGradient();
  /// @brief Injects a <linearGradient> for the stroke if one is set.
  void addStrokeLinearGradient();

  // PRIVATE MEMBERS

  QString m_source;                      ///< SVG file path.
  QByteArray m_finalSvg;                 ///< Cached, styled SVG bytes.
  bool svgFirstLoad = false;             ///< True once the SVG is in cache.
  QRectF m_viewport;                     ///< Computed render region.
  float m_svgViewBoxWidth;               ///< Parsed SVG viewBox width.
  float m_svgViewBoxHeight;              ///< Parsed SVG viewBox height.
  QColor m_svgFillColor;                 ///< Fill color.
  float m_svgStrokeWidth;                ///< Stroke width (user units).
  QColor m_svgStrokeColor;               ///< Stroke color.
  QVariantMap m_svgFillLinearGradient;   ///< Fill gradient config.
  QVariantMap m_svgStrokeLinearGradient; ///< Stroke gradient config.
};
;

#endif // SVG_ICON_H
