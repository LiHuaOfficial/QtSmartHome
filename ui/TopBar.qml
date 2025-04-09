import QtQuick

Rectangle {
    id:topBar

    //property date currentDateTime: new Date()
    property bool topBarInDeviceView:false

    width:parent.width 
    signal sideBarButtonClicked
    signal returnButtonClicked

    states: [
        State {
            name: "topBarInDeviceView"
            when: topBar.topBarInDeviceView==true
            PropertyChanges {
                sideBarButton.opacity: 0
                returnButton.opacity: 1
            }
        },
        State {
            name: "topBarNotInDeviceView"
            when: topBar.topBarInDeviceView==false
            PropertyChanges {
                sideBarButton.opacity: 1 
                returnButton.opacity: 0
            }
        } 
    ]
    transitions:Transition{
        NumberAnimation{
            property:"opacity"
            duration:500
        }
    }

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
    Rectangle{
        id:returnButton
        anchors.left: parent.left

        z:topBar.topBarInDeviceView?3:0//sidebarbtn z=2
        
        width:topBar.height
        height:returnButton.width
        Image{
            anchors.fill: parent
            source: "../assets/return_icon.png"
        }
        MouseArea{
            anchors.fill: parent
            
            onClicked:{
                //console.log("ma:return button clicked")
                topBar.returnButtonClicked()
                topBar.topBarInDeviceView=false
            }
        }
    }
    SideBarButton{
        id:sideBarButton

        anchors.left: parent.left

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
