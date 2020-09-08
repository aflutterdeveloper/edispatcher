

typedef void EventCallbackFunction<T>(T event);

abstract class ISubscriber<T> {
  /// 监听EventDispatcher发出的所有事件
  /// param listener 事件接收者对象
  /// param callback 事件接收者响应函数
  void onAll(dynamic listener, EventCallbackFunction<T> callback);

  /// 取监听EventDispatcher发出的所有事件
  /// param listener 事件接收者对象
  void offAll(dynamic listener);

  /// 监听某一个特定类型事件
  /// param listener 事件接收者对象
  /// param callback 事件接收者响应函数
  /// type E 触发的具体事件类型
  void onType<E extends T>(listener, EventCallbackFunction<E> callback);

  /// 取消监听某一个特定类型事件
  /// param listener 事件接收者对象
  /// type E 触发的具体事件类型
  void offType<E extends T>(listener);
}