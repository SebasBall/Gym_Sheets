pragma Singleton
import QtQuick

QtObject {
    property Loader screenManager: null

    function setLoader(loader) {
        screenManager = loader;
    }

    function goTo(screen) {
        screenManager.source = screen;
    }
}
