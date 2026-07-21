import QtQuick
import "../GeneralQml"

MyTextField {
    p_placeHolderText: "Testing"
    p_textFontName: Fonts.lexend.name
    p_textAlign: Text.AlignHCenter

    p_textBold: false
    p_textSize: 14

    p_borderSize: 4
    p_radius: 10
    p_borderArray: [0, 0, 1, 1]
    p_radiusArray: [0, 0, 0, 0]

    p_rectangleColor: "white"
}
