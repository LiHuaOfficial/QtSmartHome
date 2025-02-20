import QtQuick

//侧边栏的按钮
Item {
    id:sideBarButton
    property string title
    property bool isSelected

    signal clicked

    Text{
        font.pixelSize: 16
        anchors.centerIn: parent
        text: parent.title

        color:sideBarButton.isSelected?"blue":"black"
    }

    MouseArea{
        id:ma
        anchors.fill:parent


        // Connections{
        //     target:ma
        //     function onClicked(){
        //         sideBarButton.clicked()
        //         console.log("sidebar content clicked")
        //     }
        // }

        onClicked:{
            sideBarButton.clicked()
            console.log("sidebar content clicked")
        }
    }

    Rectangle{
        anchors.leftMargin: parent
        color: "blue"

        width: parent.width/20
        height: parent.height

        visible: isSelected

        gradient:Gradient{
            orientation: Gradient.Vertical
            GradientStop { position: 0.2; color: "white" }
            GradientStop { position: 0.5; color: "blue" }
            GradientStop { position: 0.8; color: "white" }
        }
    }
}
