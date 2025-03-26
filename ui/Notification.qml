pragma ComponentBehavior: Bound


import QtQuick 2.15

//import "qrc:/../common"
import "../common"

Item {
    id: root

    width: 240//only default
    required property int contentHeight
    readonly property real textParentRatio:0.5
    
    function notify(message, type = Notification.Message, timeout = 1000) {
        listModel.append({
                             message: message,
                             type: type,
                             timeout: timeout
                         });
    }

    enum NotificationType {
        None = 0,
        Success = 1,
        Warning = 2,
        Message = 3,
        Error = 4
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 500 }
        }
        Repeater {
            id: repeater
            model: ListModel {
                id: listModel
            }
            delegate: Rectangle {
                id:notificationContent
                required property int timeout
                required property int type
                required property string message
                required property int index

                width: root.width-20
                height:root.contentHeight
                
                radius: 5
                color: {
                    switch (notificationContent.type) {
                        case Notification.Success:return "#f0f9ea";
                        case Notification.Warning:return "#fff3cd";
                        case Notification.Message:return "#d1ecf1";
                        case Notification.Error:return "#f8d7da";
                        default:return "#f0f9ea";    
                    }
                }
                clip: true

                
                Component.onCompleted: {
                    __timer.interval = timeout;
                    __timer.start();
                }

                NumberAnimation on opacity {
                    id: __removeAniamtion
                    to: 0
                    running: false
                    duration: 1000
                    alwaysRunToEnd: true
                    onFinished: {
                        listModel.remove(notificationContent.index);
                    }
                }

                Timer {
                    id: __timer
                    onTriggered: {
                        __removeAniamtion.start();
                    }
                }

                Row {
                    id: __column
                    width: parent.width
                    height: parent.height

                    
                    leftPadding:10
                    spacing: 10

                    Image{
                        height: parent.height*root.textParentRatio
                        width: height

                        anchors.verticalCenter: parent.verticalCenter
                        

                        source:{
                            switch (notificationContent.type) {
                            case Notification.Success:
                                return "../assets/notification_success_icon.png";
                            case Notification.Warning:
                                return "../assets/notification_warn_icon.png";
                            case Notification.Message:
                                return "../assets/notification_info_icon.png";
                            case Notification.Error:
                                return "../assets/notification_error_icon.png";
                            default:
                                return "";
                            }
                        }
                    }
                    
                    Text {
                        id: __message

                        property string typeString: {
                            switch (notificationContent.type) {
                            case Notification.Success:
                                return qsTr("Success");
                            case Notification.Warning:
                                return qsTr("Warning");
                            case Notification.Message:
                                return qsTr("Info");
                            case Notification.Error:
                                return qsTr("Error");
                            default:
                                return "";
                            }
                        }

                        anchors.verticalCenter: parent.verticalCenter

                        font.pixelSize:parent.height*root.textParentRatio*0.6

                        text: typeString+':'+notificationContent.message
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WrapAnywhere

                        color:{
                            switch (notificationContent.type) {
                            case Notification.Success:
                                return "#4f8a10";
                            case Notification.Warning:
                                return "#c09853";
                            case Notification.Message:
                                return "#3a87ad";
                            case Notification.Error:
                                return "#d8000c";
                            default:
                                return "";
                            }
                        }
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 6
                    text: "×"
                    font.bold: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            __timer.stop();
                            __removeAniamtion.restart();//大概没完成也会触发onfinished
                        }
                    }
                }
            }
        }
    }
}