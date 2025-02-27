import QtQuick

import "../common/"

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

        color:sideBarButton.isSelected?ColorStyle.blue:"black"
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
        //anchors.verticalCenter: parent
        anchors.leftMargin: parent
        color: ColorStyle.blue

        width: parent.width/20
        height: parent.height

        radius:10

        visible: isSelected


    }


}
