# QtSmartHome
control custom home device

## 功能
- 控制自定义的家庭设备
- 支持自定义设备的控制方式
- 支持自定义设备的控制参数

## 思考
从qml中调用C++ api是不是不能创建线程（Q_INVOKABLE 会导致阻塞）（信号触发C++槽函数则会直接崩溃）
解决方案考虑在qml engine前创建线程，然后通过queue当中间件传递数据 
