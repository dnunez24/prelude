import 'package:built_collection/built_collection.dart';
import 'pitch.dart';

class Interval extends EnumClass {
  // A unison interval (two notes sounding at the same pitch).
  static const Interval unison = _$unison;
  // A minor 2nd interval.
  static const Interval minor2nd = _$minor2nd;
  // A major 2nd interval.
  static const Interval major2nd = _$major2nd;
  // A minor 3rd interval.
  static const Interval minor3rd = _$minor3rd;
  // A major 3rd interval.
  static const Interval major3rd = _$major3rd;
  // A perfect 4th interval.
  static const Interval perfect4th = _$perfect4th;
  // A tritone (augmented 4th / diminished 5th) interval.
  static const Interval tritone = _$tritone;
  // A perfect 5th interval.
  static const Interval perfect5th = _$perfect5th;
  // A minor 6th interval.
  static const Interval minor6th = _$minor6th;
  // A major 6th interval.
  static const Interval major6th = _$major6th;
  // A minor 7th interval.
  static const Interval minor7th = _$minor7th;
  // A major 7th interval.
  static const Interval major7th = _$major7th;
  // An octave interval.
  static const Interval octave = _$octave;

  final int value;

  // TODO: add attribute to represent value in semitones (int)

  // factory Interval(int number) {
  //   // TODO: handle out of range value OR turn it into a valid interval via modulo
  //   // or other calculation
  //   var index = number;
  //   return Interval._(values.elementAt(index).name);
  // }
  factory Interval.fromSemitones(int semitones) =>
      values.elementAt(semitones - 1);

  const Interval._(String name) : super(name);

  factory Interval.between(PitchClass pitch1, PitchClass pitch2) {
    // final difference = (note1.value - note2.value).abs();
    final index = pitch1.value % pitch2.value;
    return Interval._(values.elementAt(index).name);
  }

  static BuiltSet<Interval> get values => _$iValues;
  static Interval valueOf(String name) => _$iValueOf(name);

  int toSemitones() => values.toList().indexOf(this);

  Interval invert() {
    // TODO: validate this logic (with tests, obvs)
    // 9 - number % 12
    final semitones = toSemitones() % 12;
    return Interval.fromSemitones(semitones);
  }

  // TODO: implement <, >, <=, >= methods to check if intervals are larger
  // or smaller than one another

  Interval operator +(Interval other) =>
      Interval.fromSemitones(value + other.value);
}
