import QtQuick

BaseView{
    id:deviceView

    property var infoMap

    onInfoMapChanged:{
        //刷新信息
        //console.log("deviceView infoMap changed",infoMap,infoMap["name"])
        t.text=qsTr("device:"+infoMap["name"]);

    }
    Text{
        id:t
        text:qsTr("nothing")
    }
}