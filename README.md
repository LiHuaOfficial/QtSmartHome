# QtSmartHome
control custom home device

## 功能
- 控制自定义的家庭设备
- 支持自定义设备的控制方式
- 支持自定义设备的控制参数

## 使用
- 安装Qt 6.8(并在CMake中配置CMAKE_PREFIX_PATH)(or conanfile.py中配置self.requires("qt/6.8.2"))
- conan install . --build=missing
- cmake插件选择preset后直接编译
## TODO
- 显示本机ip
