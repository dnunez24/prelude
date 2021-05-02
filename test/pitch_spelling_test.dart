import 'package:prelude/src/_matrix.dart';
import 'package:test/test.dart';
import 'package:prelude/src/pitch_spelling.dart';
import 'package:prelude/src/pitch.dart';

void main() {
  group('PitchSpellingMatrix', () {
    test(
        '.indexesOfPitchClass() returns the matrix index '
        'of the given pitch class', () {
      expect(PitchSpellingMatrix().indexesOfPitchClass(PitchClass.cNatural),
          [MatrixIndex(2, 0), MatrixIndex(0, 2), MatrixIndex(4, 6)]);
    });
  });
}
