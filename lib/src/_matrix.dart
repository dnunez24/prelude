import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// A 2-dimensional matrix that contains values of type [E].
///
/// Note: indexes begin at 0 (as in common in computing) and not at 1 (as is
/// common in mathematical descriptions of matrixes).
class Matrix<E> extends DelegatingIterable<List<E>> {
  /// The values in this [Matrix] as a 2-dimensional array.
  final List<List<E>> values;

  /// Returns the count of rows in this [Matrix].
  int get rowsCount => values.length;

  /// Returns the count of columns in this [Matrix].
  int get columnsCount => values.isEmpty ? 0 : values.first.length;

  /// Creates a new [Matrix] with the given [values]. The values must be a
  /// 2-dimensional array of elements [E].
  Matrix(this.values) : super(values);

  /// Returns the index of the given [element]. If [element] cannot be
  /// found in this [Matrix] then the index will be the pair (-1, -1).
  MatrixIndex indexOf(E element) {
    for (var row = 0; row < rowsCount; row++) {
      for (var col = 0; col < columnsCount; col++) {
        if (element == values[row][col]) return MatrixIndex(row, col);
      }
    }

    return MatrixIndex.notFound;
  }

  /// Returns the row at the given [index].
  List<E> row(MatrixIndex index) => values[index.row];

  /// Returns the column at the given [index].
  List<E> column(MatrixIndex index) => [
    for (var row in values) row[index.column]
  ];

  /// Returns the value stored at the given [index];
  // TODO: handle if row doesn't exist then column access will break.
  List<E> operator [](MatrixIndex index) {
    if (index.row == null) return column(index);
    if (index.column == null) return row(index);
    return [values[index.row][index.column]];
  }
}

class MatrixIndex extends Equatable {
  final int row;
  final int column;

  static const notFound = MatrixIndex(-1, -1);

  /// Index of (-1, -1) indcates that a value could not be found in the matrix.
  const MatrixIndex(this.row, this.column)
      : assert(row == null || row >= -1),
        assert(column == null || column >= -1);

  MatrixIndex.row(int row) : this(row, null);

  MatrixIndex.column(int column) : this(null, column);

  List<int> toList() => [row, column];

  @override
  List<Object> get props => [column, row];

  @override
  bool get stringify => true;

}
