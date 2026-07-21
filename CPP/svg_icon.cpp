/* LIST OF CONTENTS
 * - () SvgIcon::SvgIcon | 20 - 20 | 9
 * - void (QPainter *) SvgIcon::paint | 22 - 36 | 14
 * - float () SvgIcon::updateViewPort | 38 - 54 | 15
 * - void () SvgIcon::loadFile | 56 - 77 | 14
 * - void () SvgIcon::addFillColor | 79 - 91 | 14
 * - void () SvgIcon::addStrokeColor | 93 - 105 | 14
 * - void () SvgIcon::addStrokeWidth | 107 - 124 | 14
 * - void () SvgIcon::addFillLinearGradient | 126 - 160 | 14
 * - void () SvgIcon::addStrokeLinearGradient | 162 - 196 | 14
 * - void (QString &) SvgIcon::setSource | 198 - 207 | 14
 * - void (QColor &) SvgIcon::setSvgFillColor | 209 - 218 | 14
 * - void (float &) SvgIcon::setSvgStrokeWidth | 220 - 229 | 14
 * - void (QColor &) SvgIcon::setSvgStrokeColor | 231 - 240 | 14
 * - void (QVariantMap &) SvgIcon::setSvgFillLinearGradient | 242 - 251 | 14
 * - void (QVariantMap &) SvgIcon::setSvgStrokeLinearGradient | 253 - 262 | 14
 * END OF CONTENTS */

#include "svg_icon.h"

SvgIcon::SvgIcon() {}

void SvgIcon::paint(QPainter *painter) {
  if (!svgFirstLoad) {
    loadFile();
    addFillColor();
    addStrokeColor();
    addStrokeWidth();
    addFillLinearGradient();
    addStrokeLinearGradient();
    svgFirstLoad = true;
  }

  updateViewPort();
  QSvgRenderer svgElement(m_finalSvg);
  svgElement.render(painter, m_viewport);
}

float SvgIcon::updateViewPort() {
  float strokeWidth;
  if (!(m_svgStrokeWidth > 0)) {
    m_viewport.setCoords(0, 0, width(), height());
  } else {
    float xScale = m_svgViewBoxWidth / 100;
    float yScale = m_svgViewBoxHeight / 100;

    strokeWidth = m_svgStrokeWidth * qMin(xScale, yScale);
    float hMargin = strokeWidth * (width() / m_svgViewBoxWidth) / 2;
    float vMargin = strokeWidth * (height() / m_svgViewBoxHeight) / 2;
    m_viewport.setCoords(hMargin, vMargin, width() - hMargin,
                         height() - vMargin);
  }

  return strokeWidth;
};

void SvgIcon::loadFile() {
  QFile file(m_source);
  if (!file.open(QIODevice::ReadOnly)) {
    qWarning() << "Failed to open file" << m_source;
    return;
  }

  QDomDocument doc;
  if (!doc.setContent(&file)) {
    qDebug() << "Failed to parse XML";
    file.close();
    return;
  }
  file.close();

  QDomElement svg = doc.elementsByTagName("svg").at(0).toElement();
  QStringList viewBoxValues = svg.attribute("viewBox").split(" ");
  m_svgViewBoxWidth = viewBoxValues[2].toFloat();
  m_svgViewBoxHeight = viewBoxValues[3].toFloat();

  m_finalSvg = doc.toByteArray();
}

void SvgIcon::addFillColor() {
  QDomDocument doc;
  doc.setContent(m_finalSvg);

  QDomElement path = doc.elementsByTagName("path").at(0).toElement();
  if (m_svgFillColor.isValid()) {
    path.setAttribute("fill", m_svgFillColor.name());
  } else {
    path.setAttribute("fill", "none");
  }

  m_finalSvg = doc.toByteArray();
}

void SvgIcon::addStrokeColor() {
  QDomDocument doc;
  doc.setContent(m_finalSvg);

  QDomElement path = doc.elementsByTagName("path").at(0).toElement();
  if (m_svgStrokeColor.isValid() && m_svgStrokeWidth > 0) {
    path.setAttribute("stroke", m_svgStrokeColor.name());
  } else {
    path.removeAttribute("stroke");
  }

  m_finalSvg = doc.toByteArray();
}

void SvgIcon::addStrokeWidth() {
  QDomDocument doc;
  doc.setContent(m_finalSvg);

  QDomElement path = doc.elementsByTagName("path").at(0).toElement();
  if (m_svgStrokeWidth > 0) {
    QDomElement svg = doc.elementsByTagName("svg").at(0).toElement();

    float strokeWidth = updateViewPort();
    path.setAttribute("stroke-width", QString::number(strokeWidth));

  } else {
    path.removeAttribute("stroke-width");
    m_viewport = QRectF();
  }

  m_finalSvg = doc.toByteArray();
}

void SvgIcon::addFillLinearGradient() {
  QDomDocument doc;
  doc.setContent(m_finalSvg);
  QDomElement path = doc.elementsByTagName("path").at(0).toElement();
  QDomElement defs = doc.createElement("defs");

  if (!m_svgFillLinearGradient.isEmpty() && m_svgStrokeWidth > 0) {
    QDomElement gradient = doc.createElement("linearGradient");

    gradient.setAttribute("id", "fillGrad");
    gradient.setAttribute("x1", m_svgFillLinearGradient["x1"].toString());
    gradient.setAttribute("y1", m_svgFillLinearGradient["y1"].toString());
    gradient.setAttribute("x2", m_svgFillLinearGradient["x2"].toString());
    gradient.setAttribute("y2", m_svgFillLinearGradient["y2"].toString());

    for (QVariant &variatnStop : m_svgFillLinearGradient["stops"].toList()) {
      QVariantMap stopMap = variatnStop.toMap();
      QDomElement stop = doc.createElement("stop");
      stop.setAttribute("offset", stopMap["offset"].toString());
      stop.setAttribute("stop-color", stopMap["color"].toString());
      gradient.appendChild(stop);
    }

    defs.appendChild(gradient);
    doc.documentElement().appendChild(defs);

    path.setAttribute("fill", "url(#fillGrad)");

  } else if (!m_svgFillColor.isValid()) {
    doc.documentElement().removeChild(defs);
    path.setAttribute("fill", "none");
  }

  m_finalSvg = doc.toByteArray();
}

void SvgIcon::addStrokeLinearGradient() {
  QDomDocument doc;
  doc.setContent(m_finalSvg);
  QDomElement path = doc.elementsByTagName("path").at(0).toElement();
  QDomElement defs = doc.createElement("defs");

  if (!m_svgStrokeLinearGradient.isEmpty()) {
    QDomElement gradient = doc.createElement("linearGradient");

    gradient.setAttribute("id", "strokeGrad");
    gradient.setAttribute("x1", m_svgStrokeLinearGradient["x1"].toString());
    gradient.setAttribute("y1", m_svgStrokeLinearGradient["y1"].toString());
    gradient.setAttribute("x2", m_svgStrokeLinearGradient["x2"].toString());
    gradient.setAttribute("y2", m_svgStrokeLinearGradient["y2"].toString());

    for (QVariant &variatnStop : m_svgStrokeLinearGradient["stops"].toList()) {
      QVariantMap stopMap = variatnStop.toMap();
      QDomElement stop = doc.createElement("stop");
      stop.setAttribute("offset", stopMap["offset"].toString());
      stop.setAttribute("stop-color", stopMap["color"].toString());
      gradient.appendChild(stop);
    }

    defs.appendChild(gradient);
    doc.documentElement().appendChild(defs);

    path.setAttribute("stroke", "url(#strokeGrad)");

  } else if (!m_svgStrokeColor.isValid()) {
    doc.documentElement().removeChild(defs);
    path.removeAttribute("stroke");
  }

  m_finalSvg = doc.toByteArray();
}

void SvgIcon::setSource(QString &source) {
  if (m_source == source) {
    return;
  }
  m_source = source;
  if (svgFirstLoad) {
    loadFile();
  }
  emit sourceChanged();
}

void SvgIcon::setSvgFillColor(QColor &svgFillColor) {
  if (m_svgFillColor == svgFillColor) {
    return;
  }
  m_svgFillColor = svgFillColor;
  if (svgFirstLoad) {
    addFillColor();
  }
  emit svgFillColorChanged();
}

void SvgIcon::setSvgStrokeWidth(float &svgStrokeWidth) {
  if (m_svgStrokeWidth == svgStrokeWidth) {
    return;
  }
  m_svgStrokeWidth = svgStrokeWidth;
  if (svgFirstLoad) {
    addStrokeWidth();
  }
  emit svgStrokeWidthChanged();
}

void SvgIcon::setSvgStrokeColor(QColor &svgStrokeColor) {
  if (m_svgStrokeColor == svgStrokeColor) {
    return;
  }
  m_svgStrokeColor = svgStrokeColor;
  if (svgFirstLoad) {
    addStrokeColor();
  }
  emit svgStrokeColorChanged();
}

void SvgIcon::setSvgFillLinearGradient(QVariantMap &svgFillLinearGradient) {
  if (m_svgFillLinearGradient == svgFillLinearGradient) {
    return;
  }
  m_svgFillLinearGradient = svgFillLinearGradient;
  if (svgFirstLoad) {
    addFillLinearGradient();
  }
  emit svgFillLinearGradientChanged();
}

void SvgIcon::setSvgStrokeLinearGradient(QVariantMap &svgStrokeLinearGradient) {
  if (m_svgStrokeLinearGradient == svgStrokeLinearGradient) {
    return;
  }
  m_svgStrokeLinearGradient = svgStrokeLinearGradient;
  if (svgFirstLoad) {
    addStrokeLinearGradient();
  }
  emit svgStrokeLinearGradientChanged();
}
