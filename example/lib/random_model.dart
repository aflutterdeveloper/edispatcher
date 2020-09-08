import 'dart:math';

import 'package:edispatcher/e_observable.dart';

class RandomModel extends EObservable {
  void random() {
    final r = Random().nextInt(0x7FFFFFFF).toString();
    dispatch(RandomNotifyEvent(r));
  }
}

abstract class IRandomEvent {}

class RandomNotifyEvent implements IRandomEvent {
  final String random;
  RandomNotifyEvent(this.random);
}
