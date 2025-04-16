#include "inc/CommunManager.h"
#include "CommunManager.h"

#include <QDebug>

CommunManager::CommunManager(QObject *parent)
{
    
}

void CommunManager::deviceEnable(int id)
{
    qDebug()<<"CM:deviceEnable:"<<id;
}
