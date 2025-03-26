import QtQuick

import "../common"

Item {
    id: root

    property int selectedView: -1
    property int index: -1

    signal notificationTrigged(string msg,int type,int timeout)

    visible:opacity>0.01

    Behavior on opacity {
        NumberAnimation {duration:200}
    }
    Behavior on x { NumberAnimation {} }

    states: [
        State {
            id: selected
            name: "selected"
            when: root.selectedView == root.index
            PropertyChanges { root.opacity: 1 }
        },
        State {
            name: "notSelected"
            when: root.selectedView != root.index
            PropertyChanges { root.opacity: 0 }
        }
    ]
}
