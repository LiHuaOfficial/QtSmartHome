import QtQuick
import QtQuick.Controls

BaseView {
    // Text{
    //     font.pixelSize: 16
    //     anchors.centerIn: parent
    //     text: "addview"
    // }
    id:addView

    Rectangle{
        readonly property int seperatorHeight:1

        id:addRect
        //anchors.centerIn:addView

        anchors.horizontalCenter:addView.horizontalCenter
        anchors.top:addView.top
        anchors.topMargin:addView.width*0.01

        width:addView.width*0.96
        height:addView.height*0.96

        radius:width/20
        // border.width:2
        // border.color:"black"

        color:"white"

        //添加设备的表单
        //需要的值有设备类型，设备名称，链接需要的信息，关注的变量
        //不同的设备类型需要的信息不同，还得切换显示
        Column{
            id:column

            anchors.fill: parent

            //topPadding:10
            spacing: 10

            states: [
                State {
                    name: "BLE"
                    when: deviceTypeBox.itemStatus==0

                },
                State {
                    name: "Socket"
                    when: deviceTypeBox.itemStatus==1

                },
                State {
                    name: "HTTP"
                    when: deviceTypeBox.itemStatus==2

                }
            ]
            property int itemHeight:column.height/6


            ViewRowItem{
                id:deviceTypeBox

                height:column.itemHeight

                choosedComponent: 'comboBox'
                componentDiscription: qsTr("Device type")
                comboBoxList: ['BLE', 'Socket', 'HTTP']
            }

            Rectangle{
                id:nameItem
                width:parent.width
                height:column.itemHeight
                Text{
                    anchors.left:parent.left
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.leftMargin: parent.width/30

                    fontSizeMode: Text.Fit
                    font.pixelSize: 20
                    text:qsTr("Device Name")
                }
                TextField{
                    anchors.right:parent.right
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.rightMargin: parent.width/30
                }
            }            
            
            //左边配置右边变量
            Row{
                id:row
                width:parent.width
                height:column.height-deviceTypeBox.height
                Item{//左半
                    width:parent.width/3*2
                    height:row.height

                    //根据设备显示不同item
                    Column{
                        id:bleItem
                        width:parent.width
                        height:parent.height
                    }
                    Column{
                        id:socketItem
                    }
                    Column{
                        id:httpItem
                    }
                }
                Item{//右半
                    width:parent.width/3
                    height:row.height
                    //color:"black"
                }
            }
        }
    }
}
