import QtQuick
import "../GeneralQml"

MyLabel {
    p_textFontName: Fonts.lexend.name
    p_textAlign: Text.AlignHCenter

    p_text: "Place Holder"
    p_textBold: false
    p_textSize: 16

    p_borderSize: 4
    p_radius: 10
    p_borderArray: [0, 0, 1, 1]
    p_radiusArray: [0, 0, 0, 0]

    p_rectangleColor: Colors.light
}
