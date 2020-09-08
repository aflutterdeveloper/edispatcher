import 'dart:async';

import 'package:edispatcher/e_subscriber.dart';
import 'package:edispatcher/i_observable.dart';

import 'i_subscriber.dart';

typedef e_dispatcher_logger = void Function(String tag, String message);

class EObservable<T> implements ISubscriber<T>, IObservable<T> {
  StreamController<T> _controller = StreamController<T>.broadcast();
  Map<dynamic, StreamSubscription> _listeners =
      Map<dynamic, StreamSubscription>();

  Map<_TypeEvent, StreamSubscription> _typeListeners =
      Map<_TypeEvent, StreamSubscription>();

  static Map<dynamic, Set<EObservable>> _observableMap = Map();

  static void off(dynamic listener) {
    Set<EObservable> dispatchList = _observableMap.remove(listener);
    if (null != dispatchList) {
      dispatchList.forEach((element) {
        element.offAll(listener);
      });
    }
  }

  static e_dispatcher_logger logger;

  static void _listen(dynamic listener, EObservable dispatcher) {
    Set<EObservable> dispatchList = _observableMap[listener];
    if (null == dispatchList) {
      dispatchList = Set();
      _observableMap[listener] = dispatchList;
    }
    dispatchList.add(dispatcher);
  }

  String get _tag => "$T";

  @override
  bool dispatch(T data) {
    if (_controller.isClosed) {
      return false;
    }
    _controller.add(data);
    return true;
  }

  @override
  void onAll(listener, EventCallbackFunction<T> callback) {
    if (T == dynamic) {
      _logger(_tag, "EventDispatcher addListener reject, dynamic on broadcast");
      return;
    }

    if (!_controller.isClosed) {
      if (_listeners.containsKey(listener)) {
        _logger(_tag, "EventDispatcher addListener reject");
        return;
      }
      _listeners[listener] = _controller.stream.listen(callback);
      _listen(listener, this);
      _logger(_tag, "EventDispatcher addListener");
    } else {
      _logger(_tag, "EventDispatcher addListener failed");
    }
  }

  @override
  void offAll(listener) {
    _listeners.remove(listener)?.cancel();

    _typeListeners.removeWhere((key, value) {
      if (key.listener == listener) {
        value.cancel();
        return true;
      }
      return false;
    });

    _logger(_tag,
        "$_tag EventDispatcher removeListener ${_listeners.length}, ${_typeListeners.length}");
  }

  @override
  void onType<E extends T>(listener, EventCallbackFunction<E> callback) {
    if (E == dynamic) {
      _logger(_tag, "can't listen dynamic type");
      return;
    }

    if (!_controller.isClosed) {
      final type = _TypeEvent(listener, E);
      if (_typeListeners.containsKey(type)) {
        _logger(_tag, "EventDispatcher ${E.runtimeType} addListener reject");
        return;
      }
      _typeListeners[type] = _controller.stream
          .where((event) => event is E)
          .cast<E>()
          .listen(callback);

      _listen(listener, this);
      _logger(_tag, "EventDispatcher ${E.runtimeType} addListener");
    } else {
      _logger(_tag, "EventDispatcher ${E.runtimeType} addListener failed");
    }
  }

  @override
  void offType<E extends T>(listener) {
    if (E == dynamic) {
      _logger(_tag, "can't listen dynamic type");
      return;
    }

    final type = _TypeEvent(listener, E);
    _typeListeners.remove(type)?.cancel();
    _logger(_tag,
        "$_tag EventDispatcher removeListener ${_listeners.length}, ${_typeListeners.length}");
  }

  @override
  void close() {
    _observableMap.forEach((key, value) {
      if (value.contains(this)) {
        value.remove(this);
      }
    });

    _listeners.forEach((listener, dispose) {
      dispose.cancel();
    });

    _typeListeners.forEach((listener, dispose) {
      dispose.cancel();
    });

    _listeners.clear();
    if (!_controller.isClosed) {
      _controller.close();
    }
  }

  void _logger(String tag, String message) {
    if (null != logger) {
      logger(tag, message);
    }
  }
}

class _TypeEvent {
  _TypeEvent(this.listener, this.eventType);

  final dynamic listener;
  final dynamic eventType;

  @override
  bool operator ==(other) {
    if (other is _TypeEvent) {
      return listener == other.listener && eventType == other.eventType;
    }
    return super == other;
  }

  @override
  int get hashCode {
    int result = 17;
    result = result * 31 + listener.hashCode;
    result = result * 31 + eventType.hashCode;
    return result;
  }
}
