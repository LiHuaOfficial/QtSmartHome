
# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)

# # 添加编译器选项
# add_compile_options("/permissive-")
# add_compile_options("/Zc:__cplusplus")

cmake_minimum_required(VERSION 3.16)

project(QtSmartHome VERSION 0.1 LANGUAGES CXX)



set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT_QML_GENERATE_QMLLS_INI ON)#generate .qmlls.ini needed by language server,helping complete qml module create by cpp


find_package(Boost REQUIRED COMPONENTS boost::asio)
find_package(fmt)
#set(CMAKE_PREFIX_PATH "D:/Application/Qt/6.8.1/mingw_64")
find_package(Qt6 REQUIRED COMPONENTS Quick)

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    MESSAGE("building on Windows")
    link_libraries(ws2_32 mswsock)
endif(CMAKE_SYSTEM_NAME MATCHES "Windows")

qt_standard_project_setup(REQUIRES 6.5)

qt_policy(SET QTP0004 NEW)

qt_add_executable(appQtSmartHome
    main.cpp
    inc/CommunManager.h 
    src/CommunManager.cpp
    src/SocketServer.cpp
    inc/SocketServer.h
)

#help finding headers(qml module create by cpp)
target_include_directories(appQtSmartHome PRIVATE inc common)

# when using pragma Singleton
set_source_files_properties(common/ColorStyle.qml common/Common.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appQtSmartHome
    URI QtSmartHome
    VERSION 1.0
    QML_FILES Main.qml
    QML_FILES ui/SideBar.qml
    QML_FILES ui/SideBarButton.qml
    QML_FILES ui/SideBarContent.qml
    QML_FILES common/ColorStyle.qml
    QML_FILES common/Common.qml
    QML_FILES ui/ViewRowItem.qml
    QML_FILES ui/BaseView.qml
    QML_FILES ui/AddView.qml
    QML_FILES ui/SettingView.qml
    QML_FILES ui/MainView.qml
    QML_FILES ui/TopBar.qml
    QML_FILES ui/DeviceApp.qml
    QML_FILES ui/Notification.qml
    QML_FILES ui/DeviceView.qml
    RESOURCES assets/house_icon.png assets/bluetooth_icon.png assets/wifi_icon.png assets/http_icon.png
    RESOURCES assets/app_icon_ai.png assets/app_icon_ai.ico assets/tick_icon.png assets/add_icon.png
    RESOURCES assets/delete_icon.png assets/plus_icon.png assets/return_icon.png assets/geer_icon.png
    RESOURCES assets/notification_error_icon.png assets/notification_info_icon.png assets/notification_success_icon.png assets/notification_warn_icon.png
    SOURCES inc/DeviceManager.h src/DeviceManager.cpp
    SOURCES common/QtSmartHomeGlobal.h
    SOURCES inc/DeviceInfo.h src/DeviceInfo.cpp #DEPENDENCIES QObject
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQtSmartHome PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQtSmartHome
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE OFF
)

target_link_libraries(appQtSmartHome
    PRIVATE Qt6::Quick fmt::fmt boost::boost
)

include(GNUInstallDirs)
install(TARGETS appQtSmartHome
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
