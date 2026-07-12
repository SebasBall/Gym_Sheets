import QtQuick
import "../GeneralQml"

MyButton {
    p_text: "test"
    p_textFontName: Fonts.lexend.name
    p_textColor: Colors.light
    p_textBold: true
    p_textAlign: Text.AlignHCenter

    p_radius: 10
    p_shadowColor: Colors.primary
    p_shadowEnabled: true
    p_shadowOffset: 5

    p_gradientEnabled: true
    p_gradientColor1: Colors.primary
    p_gradientColor2: Colors.secondary
}
