import QtQuick
Rectangle {
    id: sideBar
    color: "white"
    // border.color: "gray"
    // border.width: 2

    property bool foldStatus: true
    property int selectedContent: 0

    Behavior on foldStatus{
        PropertyAnimation{
            id: foldAnimation
            target: sideBar
            property: "x"
            from: sideBar.foldStatus?-sideBar.width:0
            to: sideBar.foldStatus?0:-sideBar.width
            duration: 200
        }
    }

    Column{
        id:column
        anchors.fill: parent
        SideBarContent{//单纯占位的框
            width: parent.width
            height: parent.height/5
        }
        SideBarContent{
            width: parent.width
            height: parent.height/5
            title: qsTr("View")

            //why Connections?
            isSelected:sideBar.selectedContent===0
            onClicked:{
                sideBar.selectedContent=0;
            }
        }
        SideBarContent{
            width: parent.width
            height: parent.height/5
            title: qsTr("Add view")
            isSelected:sideBar.selectedContent===1
            onClicked:{
                sideBar.selectedContent=1;
            }
        }
        SideBarContent{
            width: parent.width
            height: parent.height/5
            title: qsTr("Setting")
            isSelected:sideBar.selectedContent===2
            onClicked:{
                sideBar.selectedContent=2;
            }
        }
        SideBarContent{
            width: parent.width
            height: parent.height/5
            title: qsTr("Quit")
            onClicked: {
                Qt.quit()
            }
        }
    }


}
