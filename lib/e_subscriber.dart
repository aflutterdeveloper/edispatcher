import 'package:edispatcher/e_observable.dart';
import 'package:flutter/cupertino.dart';

@optionalTypeArgs
mixin ESubscriber<T extends StatefulWidget> on State<T> {
  @override
  void dispose() {
    EObservable.off(this);
    super.dispose();
  }
}
