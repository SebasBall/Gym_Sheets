pragma Singleton
import QtQuick

QtObject {
    property Loader screenManager: null

    function setLoader(loader) {
        screenManager = loader;
    }

    function goTo(screen) {
        screenManager.source = "";
        screenManager.source = screen;
    }

    function reload() {
        var currentScreen = screenManager.source;
        screenManager.source = "";
        screenManager.source = currentScreen;
    }
}
