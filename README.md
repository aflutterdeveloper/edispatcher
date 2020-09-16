# edispatcher

event dispatcher

## Getting Started
```dart
//event define
abstract class IRandomEvent {}
class RandomNotifyEvent implements IRandomEvent {
  final String random;
  RandomNotifyEvent(this.random);
}

//event observable
class RandomModel extends EObservable {
  void random() {
    final r = Random().nextInt(0x7FFFFFFF).toString();
    dispatch(RandomNotifyEvent(r));
  }
}

//event subscriber
subscribe<RandomNotifyEvent>(_random, (event) {
      //event dispatched, refresh ui
      setState(() {
        _randomText = event.random;
      });
    });
}
```

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
