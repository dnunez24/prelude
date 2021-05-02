/// Extension on the [List] class that simplifies the process of rotating list
/// elements until a given element is at the desired position in the list.
extension ListRotation<T> on List<T> {
  /// Rotates the elements of a [List] until the element at index [index] is
  /// the first element in the new [List]. This is an immutable operation and
  /// returns a new [List] without modifying the original.
  List<T> rotateToStart(int index) => [
        ...sublist(index),
        ...sublist(0, index),
      ];

  /// Rotates the elements of a [List] until the element at index [index] is
  /// the last element in the new [List]. This is an immutable operation and
  /// returns a new [List] without modifying the original.
  List<T> rotateToEnd(int index) => [
        ...sublist(index + 1),
        ...sublist(0, index + 1),
      ];
}

extension ListMath<T extends num> on List<T> {
  /// Computes the sum of all numbers in this [List].
  ///
  /// Example: Summing a list of integers.
  /// ```
  /// var ints = [1, 2, 3, 4, 5];
  /// assert(numbers.sum(), 15);
  /// ```
  ///
  /// Example: Summing a list of floating point numbers.
  /// ```
  /// var floats = [1.5, 2.5, 3.5, 4.5];
  /// assert(numbers.sum(), 12.0);
  /// ```
  ///
  /// Example: Summing a list that includes negative numbers.
  /// ```
  /// var withNegatives = [-2, -1, 0, 1, 2];
  /// assert(withNegatives.sum(), 0);
  /// ```
  T sum() => this.reduce((a, b) => a + b);

  /// Computes the product of all numbers in this [List].
  T product() => this.reduce((a, b) => a * b);
}
