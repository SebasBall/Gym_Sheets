pragma ComponentBehavior: Bound
import QtQuick

MyLabel {
    id: root
    transformOrigin: Item.Center

    onClicked: {
        root.focus = true;
    }
    onPressed: {
        root.scale = 0.95;
    }
    onReleased: {
        root.scale = 1;
    }
    onEntered: {
        root.scale = 0.95;
    }
    onExited: {
        root.scale = 1;
    }
}
