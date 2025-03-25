import QtQuick 2.15

Rectangle {

    color:"white"
    radius:10
    z: 5
    signal buttonClicked

    Image {
        anchors.fill: parent

        id: geer
        source: "../assets/geer_icon.png"
    }

    MouseArea{
        anchors.fill: parent
        onClicked:parent.buttonClicked()
    }

    onButtonClicked: console.log("sideBar button clicked")
}
