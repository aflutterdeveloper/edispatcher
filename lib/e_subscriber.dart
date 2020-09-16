import 'package:edispatcher/e_observable.dart';
import 'package:flutter/cupertino.dart';

import 'i_observable.dart';

@optionalTypeArgs
mixin ESubscriber<T extends StatefulWidget> on State<T> {
  @override
  void dispose() {
    EObservable.off(this);
    super.dispose();
  }

  void subscribe<E>(EObservable observable, EventCallbackFunction<E> callback) {
    observable.onType<E>(this, callback);
  }

  void unsubscribe<E>(EObservable observable) {
    observable.offType<E>(this);
  }
}
