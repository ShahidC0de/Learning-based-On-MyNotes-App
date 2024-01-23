// we are trying to filter any stream containing item which is T, and filling another stream with those items(only those which pass the specific test);
extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
