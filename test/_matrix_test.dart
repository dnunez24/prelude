import 'package:test/test.dart';
import 'package:prelude/src/_matrix.dart';

void main() {
  group('Matrix', () {
    Matrix matrix;

    setUp(() {
      matrix = Matrix([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);
    });

    test('[MatrixIndex(row, column)] returns the value '
         'at the given row and column', () {
      expect(matrix[MatrixIndex(0, 0)], [1]);
      expect(matrix[MatrixIndex(1, 2)], [6]);
      expect(matrix[MatrixIndex(2, 2)], [9]);
    });

    test('[MatrixIndex(row,)] returns values in the given row', () {
      expect(matrix[MatrixIndex(2, null)], [7, 8, 9]);
      expect(matrix[MatrixIndex.row(2)], [7, 8, 9]);
    });

    test('[MatrixIndex(,column)] returns values in the given column', () {
      expect(matrix[MatrixIndex(null, 2)], [3, 6, 9]);
      expect(matrix[MatrixIndex.column(2)], [3, 6, 9]);
    });

    test('empty value', () {
      // handle errors
    });
  });

  group('MatrixIndex', () {
    test('.row creates a MatrixIndex with the given row and null column', () {
      expect(MatrixIndex.row(2), MatrixIndex(2, null));
    });

    test(
        '.column creates a MatrixIndex with '
        'the given column and null row', () {
      expect(MatrixIndex.column(3), MatrixIndex(null, 3));
    });

    test('.notFound creates a MatrixIndex with indexes (-1, -1)', () {
      expect(MatrixIndex.notFound, MatrixIndex(-1, -1));
    });

    test('.toList() returns the indexes as [row, column]', () {
      expect(MatrixIndex(2, 3).toList(), [2, 3]);
    });
  });
}
