import QtQuick
Rectangle {
    id: sideBar
    color: "white"
    visible:opacity>0.01

    property bool foldStatus: true
    property int selectedContent: 0

    signal viewSwitched(int index)

    onSelectedContentChanged:viewSwitched(selectedContent)

    //和状态切换配合实现的淡入淡出动画
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    states: [
        State {
            name: "folded"
            when: sideBar.foldStatus==true
            PropertyChanges {sideBar.opacity:1}
        },
        State {
            name: "unfolded"
            when: sideBar.foldStatus==false
            PropertyChanges {sideBar.opacity:0}
        }
    ]

    Column{
        id:column
        anchors.fill: parent
        SideBarContent{
            width: parent.width
            height: parent.height/4
            title: qsTr("View")

            //why Connections?
            isSelected:sideBar.selectedContent===0
            onClicked:{
                sideBar.selectedContent=0;
            }
        }
        SideBarContent{
            width: parent.width
            height: parent.height/4
            title: qsTr("Add view")
            isSelected:sideBar.selectedContent===1
            onClicked:{
                sideBar.selectedContent=1;
            }
        }
        SideBarContent{
            width: parent.width
            height: parent.height/4
            title: qsTr("Setting")
            isSelected:sideBar.selectedContent===2
            onClicked:{
                sideBar.selectedContent=2;
            }
        }
        SideBarContent{
            width: parent.width
            height: parent.height/4
            title: qsTr("Quit")
            isSelected:sideBar.selectedContent===3
            onClicked: {
                sideBar.selectedContent=3;
            }
        }
    }

    function setSelectedContent(index:int){
        sideBar.selectedContent=index
    }
}
