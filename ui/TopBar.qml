import QtQuick

Rectangle {
    id:topBar

    //property date currentDateTime: new Date()
    signal sideBarButtonClicked

    Component.onCompleted: timer.start()
    Timer{
        id: timer
        interval: 100
        repeat: true //重复

        onTriggered:{
            timer.interval=1000*10//首次刷新后
            var currentDateTime=Date()//qml has gc
            textTime.text = Qt.formatDateTime(currentDateTime,"hh:mm");
            textDate.text=Qt.formatDateTime(currentDateTime,"yyyy/MM/dd")
            //console.log("timer triggered")
        }
    }

    SideBarButton{
        id:sideBarButton

        //anchors.left: parent

        width:topBar.height
        height:sideBarButton.width

        onButtonClicked:{
            topBar.sideBarButtonClicked()
        }
    }

    //need a betterlooking logo
    Image {
        id: houseIcon

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        height: topBar.height*0.8
        width: houseIcon.height

        source: "../assets/house_icon.png"
    }

    //包含天气、温度、时间、日期等状态
    Item{
        id:infoArea

        anchors.right: parent.right

        height: topBar.height
        width: topBar.width/3

        // Text{
        //     id:textDateTime

        //     anchors.right: parent.right
        // }
        Column{
            id:timeColumn

            anchors.right: parent.right

            width: infoArea.width/2
            height: infoArea.height
            Text{
                id:textTime
                font.bold: true
                font.pixelSize:infoArea.height/2
                anchors.right: parent.right
            }
            Text{
                id:textDate
                //font.bold: true
                font.pixelSize:infoArea.height/4
                anchors.right: parent.right
            }
        }
    }

}
