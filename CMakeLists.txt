cmake_minimum_required(VERSION 3.16)

project(QtSmartHome VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appQtSmartHome
    main.cpp
)

# when using pragma Singleton
set_source_files_properties(common/ColorStyle.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appQtSmartHome
    URI QtSmartHome
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES ui/SideBar.qml
        QML_FILES ui/SideBarButton.qml
        RESOURCES
        RESOURCES assets/geer_icon.png
        QML_FILES ui/SideBarContent.qml
        QML_FILES
        QML_FILES
        QML_FILES common/ColorStyle.qml
        QML_FILES
        QML_FILES ui/BaseView.qml
        QML_FILES ui/AddView.qml
        QML_FILES ui/SettingView.qml
        QML_FILES ui/MainView.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQtSmartHome PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQtSmartHome
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQtSmartHome
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appQtSmartHome
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
