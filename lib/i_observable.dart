abstract class IObservable<T> {
  bool dispatch(T data);
  void close();
}
