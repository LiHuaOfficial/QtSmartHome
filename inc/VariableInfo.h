#ifndef VARIABLEINFO_H
#define VARIABLEINFO_H

#include <mutex>
#include <memory>

#include <QObject>
#include <vector>
#include <QMap>
#include <QVariantMap>
#include <QVariantList>
/*
这个类用于储存前端访问的数据信息
管理chartdata，较大时储存到本地
*/
class VariableInfo{
public:
    VariableInfo(QVariantMap vmap){
        QVariantList dataList=vmap["Data"].toList();
        for(auto it=dataList.begin();it!=dataList.end();it++){
           qDebug()<<"data v"<<it->toString();
           dataMap[it->toString()]=QString("");//初始化
        }
        QVariantList dataOnChartList=vmap["ChartData"].toList();
        for(auto it=dataOnChartList.begin();it!=dataOnChartList.end();it++){
           qDebug()<<"chart data v"<<it->toString();
           dataOnChartMap[it->toString()]=std::vector<QString>();//初始化
        }
    }
    VariableInfo(){qDebug()<<"variableinfo:this should not be called";};
    //VariableInfo(const VariableInfo&) = delete;

    bool addToData(QString key,QString value){
        if (dataMap.contains(key))
        {
            dataMap[key]=value;
        }else{
            return false;
        } 
    }
    bool addToChartData(QString key,QString value){
        if (dataOnChartMap.contains(key))
        {
            auto& vec=dataOnChartMap[key];
            if(vec.size()<MAX_CHART_INSIDE_VECTOR_NUM){
                vec.push_back(value); 
            }else{
                //TODO:储存到本地

            }
        }else{
            return false;
        }
    }
    QString getData(QString key){
        if (dataMap.contains(key)){
            return dataMap[key];
        }
        else{
            return ""; 
        }
    }
private:
    enum{MAX_CHART_INSIDE_VECTOR_NUM=512};


    QMap<QString,QString> dataMap;
    QMap<QString,std::vector<QString>> dataOnChartMap;
};

#endif // VARIABLEINFO_H