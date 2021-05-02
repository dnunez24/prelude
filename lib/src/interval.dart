import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '_matrix.dart';
import 'pitch.dart';

/// The quality of an [Interval].
class IntervalQuality {
  /// A diminished interval quality.
  static const diminished = IntervalQuality._('diminished', 'd');

  /// A minor interval quality.
  static const minor = IntervalQuality._('minor', 'm');

  /// A major interval quality.
  static const major = IntervalQuality._('major', 'M');

  /// A perfect interval quality.
  static const perfect = IntervalQuality._('perfect', 'P');

  /// An augmented interval quality.
  static const augmented = IntervalQuality._('augmented', 'A');

  /// The name of this [IntervalQuality].
  final String name;

  /// The abbreviation of this [IntervalQuality].
  final String abbreviation;

  const IntervalQuality._(this.name, this.abbreviation);

  static List<IntervalQuality> get values => [
        diminished,
        minor,
        major,
        perfect,
        augmented,
      ];

  IntervalQuality invert() {
    final inversions = {
      diminished: augmented,
      minor: major,
      perfect: perfect,
      major: minor,
      augmented: diminished,
    };

    return inversions[this];
  }
}

/// The number of staff positions between notes in an [Interval].
class IntervalNumber {
  /// A unison, notes are at the same staff position.
  static const unison = IntervalNumber._(1, 'unison');

  /// A second, notes are 1 staff potision apart.
  static const second = IntervalNumber._(2, 'second');

  /// A third, notes are 2 staff positions apart.
  static const third = IntervalNumber._(3, 'third');

  /// A fourth, notes are 3 staff positions apart.
  static const fourth = IntervalNumber._(4, 'fourth');

  /// A fifth, notes are 4 staff positions apart.
  static const fifth = IntervalNumber._(5, 'fifth');

  /// A sixth, notes are 5 staff positions apart.
  static const sixth = IntervalNumber._(6, 'sixth');

  /// A seventh, notes are 6 staff positions apart.
  static const seventh = IntervalNumber._(7, 'seventh');

  /// An octave, notes are 7 staff positions apart.
  static const octave = IntervalNumber._(8, 'octave');

  /// The common name of this [IntervalNumber], such as "third" or "octave".
  final String name;

  /// The value of this [IntervalNumber], which equals the number of staff lines
  /// between interval root and its other member.
  final int value;

  const IntervalNumber._(this.value, this.name);

  factory IntervalNumber.valueOf(int value) =>
      values.firstWhere((intervalNumber) => intervalNumber.value == value);

  /// List of all possible [IntervalNumber]s.
  static List<IntervalNumber> get values => [
        unison,
        second,
        third,
        fourth,
        fifth,
        sixth,
        seventh,
        octave,
      ];

  IntervalNumber invert() => IntervalNumber.valueOf((9 - value) % 12);
}

abstract class IntervalClass extends Equatable {
  final int value;

  IntervalClass(this.value);

  @override
  List<Object> get props => [value];

  @override
  bool get stringify => true;
}

class UnorderedPitchInterval extends IntervalClass {
  UnorderedPitchInterval(int value) : super(value);

  factory UnorderedPitchInterval.between(Pitch pitch1, Pitch pitch2) {
    // TODO: this is a no-no--violating Law of Demeter.
    // Find a better way to get this information directly from Pitch
    var difference = pitch1.pitchClass.setNumber - pitch2.pitchClass.setNumber;
    var octaves = (pitch1.octave.toInt() - pitch2.octave.toInt()) * 12;
    var interval = difference.abs() + octaves.abs();
    return UnorderedPitchInterval(interval);
  }
}

class UnorderedPitchClassInterval extends IntervalClass {
  UnorderedPitchClassInterval(int value)
      : assert(value >= 0),
        assert(value <= 11),
        super(value);

  factory UnorderedPitchClassInterval.between(
      PitchClass pitchClass1, PitchClass pitchClass2) {
    var difference = pitchClass1.setNumber - pitchClass2.setNumber;
    var interval = difference.abs();
    return UnorderedPitchClassInterval(interval);
  }
}

class OrderedPitchInterval extends IntervalClass {
  OrderedPitchInterval(int value) : super(value);

  factory OrderedPitchInterval.between(Pitch pitch1, Pitch pitch2) {
    var difference = pitch1.toInt() - pitch2.toInt();
    return OrderedPitchInterval(difference);
  }
}

class OrderedPitchClassInterval extends IntervalClass {
  OrderedPitchClassInterval(int value)
      : assert(value >= 0),
        assert(value <= 11),
        super(value);

  factory OrderedPitchClassInterval.between(
      PitchClass pitchClass1, PitchClass pitchClass2) {
    var interval = pitchClass1.setNumber - pitchClass2.setNumber;
    return OrderedPitchClassInterval(interval);
  }
}

// TODO: this should really be an IntervalClass because you will never be able
// to determine if the interval between two pitch classes is a unison vs an
// octave since there is no concept of octaves in the IntervalClass space.
/// An interval between two notes.
class Interval extends Equatable {
  /// A doubly diminished unison (10 semitones).
  static const Interval doublyDiminishedUnison = Interval._(
      number: IntervalNumber.unison,
      quality: IntervalQuality.diminished,
      semitones: 10);

  /// A diminished unison (11 semitones).
  static const Interval diminishedUnison = Interval._(
      number: IntervalNumber.unison,
      quality: IntervalQuality.diminished,
      semitones: 11);

  /// A unison, two notes sounding at the same pitch (0 semitones).
  static const Interval unison = Interval._(
      number: IntervalNumber.unison,
      quality: IntervalQuality.perfect,
      semitones: 0);

  /// An augmented unison (1 semitone).
  static const Interval augmentedUnison = Interval._(
      number: IntervalNumber.unison,
      quality: IntervalQuality.augmented,
      semitones: 1);

  /// A doubly augmented unison (2 semitone).
  static const Interval doublyAugmentedUnison = Interval._(
      number: IntervalNumber.unison,
      quality: IntervalQuality.augmented,
      semitones: 2);

  /// A doubly diminished 2nd (11 semitones).
  static const Interval doublyDiminished2nd = Interval._(
      number: IntervalNumber.second,
      quality: IntervalQuality.diminished,
      semitones: 11);

  /// A diminished 2nd (0 semitones).
  static const Interval diminished2nd = Interval._(
      number: IntervalNumber.second,
      quality: IntervalQuality.diminished,
      semitones: 0);

  /// A minor 2nd (1 semitone).
  static const Interval minor2nd = Interval._(
      number: IntervalNumber.second,
      quality: IntervalQuality.minor,
      semitones: 1);

  /// A major 2nd (2 semitones).
  static const Interval major2nd = Interval._(
      number: IntervalNumber.second,
      quality: IntervalQuality.major,
      semitones: 2);

  /// An augmented 2nd (3 semitones).
  static const Interval augmented2nd = Interval._(
      number: IntervalNumber.second,
      quality: IntervalQuality.augmented,
      semitones: 3);

  /// A doubly augmented 2nd (4 semitones).
  static const Interval doublyAugmented2nd = Interval._(
      number: IntervalNumber.second,
      quality: IntervalQuality.augmented,
      semitones: 4);

  /// A doubly diminished 3rd (1 semitones).
  static const Interval doublyDiminished3rd = Interval._(
      number: IntervalNumber.third,
      quality: IntervalQuality.diminished,
      semitones: 1);

  /// A diminished 3rd (2 semitones).
  static const Interval diminished3rd = Interval._(
      number: IntervalNumber.third,
      quality: IntervalQuality.diminished,
      semitones: 2);

  /// A minor 3rd (3 semitones).
  static const Interval minor3rd = Interval._(
      number: IntervalNumber.third,
      quality: IntervalQuality.minor,
      semitones: 3);

  /// A major 3rd (4 semitones).
  static const Interval major3rd = Interval._(
      number: IntervalNumber.third,
      quality: IntervalQuality.major,
      semitones: 4);

  /// An augmented 3rd (5 semitones).
  static const Interval augmented3rd = Interval._(
      number: IntervalNumber.third,
      quality: IntervalQuality.augmented,
      semitones: 5);

  /// A doubly diminished 4th interval (3 semitones).
  static const Interval doublyDiminished4th = Interval._(
      number: IntervalNumber.fourth,
      quality: IntervalQuality.diminished,
      semitones: 3);

  /// A diminished 4th interval (4 semitones).
  static const Interval diminished4th = Interval._(
      number: IntervalNumber.fourth,
      quality: IntervalQuality.diminished,
      semitones: 4);

  /// A perfect 4th interval (5 semitones).
  static const Interval perfect4th = Interval._(
      number: IntervalNumber.fourth,
      quality: IntervalQuality.perfect,
      semitones: 5);

  /// An augmented 4th interval (6 semitones);
  static const Interval augmented4th = Interval._(
      number: IntervalNumber.fourth,
      quality: IntervalQuality.augmented,
      semitones: 6);

  /// A doubly augmented 4th interval (7 semitones);
  static const Interval doublyAugmented4th = Interval._(
      number: IntervalNumber.fourth,
      quality: IntervalQuality.augmented,
      semitones: 7);

  /// A doubly diminished 5th interval (5 semitones).
  static const Interval doublyDiminished5th = Interval._(
      number: IntervalNumber.fifth,
      quality: IntervalQuality.diminished,
      semitones: 5);

  /// A diminished 5th interval (6 semitones).
  static const Interval diminished5th = Interval._(
      number: IntervalNumber.fifth,
      quality: IntervalQuality.diminished,
      semitones: 6);

  /// A perfect 5th interval (7 semitones).
  static const Interval perfect5th = Interval._(
      number: IntervalNumber.fifth,
      quality: IntervalQuality.perfect,
      semitones: 7);

  /// An augmented 5th interval (8 semitones).
  static const Interval augmented5th = Interval._(
      number: IntervalNumber.fifth,
      quality: IntervalQuality.augmented,
      semitones: 8);

  /// A doubly augmented 5th interval (9 semitones).
  static const Interval doublyAugmented5th = Interval._(
      number: IntervalNumber.fifth,
      quality: IntervalQuality.augmented,
      semitones: 9);

  /// A diminished 6th (7 semitones).
  static const Interval diminished6th = Interval._(
      number: IntervalNumber.sixth,
      quality: IntervalQuality.diminished,
      semitones: 7);

  /// A minor 6th (8 semitones).
  static const Interval minor6th = Interval._(
      number: IntervalNumber.sixth,
      quality: IntervalQuality.minor,
      semitones: 8);

  /// A major 6th (9 semitones).
  static const Interval major6th = Interval._(
      number: IntervalNumber.sixth,
      quality: IntervalQuality.major,
      semitones: 9);

  /// An augmented 6th (10 semitones).
  static const Interval augmented6th = Interval._(
      number: IntervalNumber.sixth,
      quality: IntervalQuality.augmented,
      semitones: 10);

  /// A doubly augmented 6th (11 semitones).
  static const Interval doublyAugmented6th = Interval._(
      number: IntervalNumber.sixth,
      quality: IntervalQuality.augmented,
      semitones: 11);

  /// A diminished 7th (9 semitones).
  static const Interval diminished7th = Interval._(
      number: IntervalNumber.seventh,
      quality: IntervalQuality.diminished,
      semitones: 9);

  /// A minor 7th (10 semitones).
  static const Interval minor7th = Interval._(
      number: IntervalNumber.seventh,
      quality: IntervalQuality.minor,
      semitones: 10);

  /// A major 7th (11 semitones).
  static const Interval major7th = Interval._(
      number: IntervalNumber.seventh,
      quality: IntervalQuality.major,
      semitones: 11);

  /// An augmented 7th (12 semitones).
  static const Interval augmented7th = Interval._(
      number: IntervalNumber.seventh,
      quality: IntervalQuality.augmented,
      semitones: 12);

  /// A doubly augmented 7th (13 semitones).
  static const Interval doublyAugmented7th = Interval._(
      number: IntervalNumber.seventh,
      quality: IntervalQuality.augmented,
      semitones: 13);

  /// An octave (12 semitones).
  static const Interval octave = Interval._(
      number: IntervalNumber.octave,
      quality: IntervalQuality.perfect,
      semitones: 12);

  /// The number of staff positions between notes in this [Interval].
  final IntervalNumber number;

  /// The quality of this [Interval].
  final IntervalQuality quality;

  /// The number of semitones between notes in this [Interval].
  final int semitones;

  // TODO: does this need to be removed since multiple interval types can have
  // the same number of semitones? Perhaps a method that returns all intervals
  // with the same number of semitones?
  // factory Interval.fromSemitones(int semitones) =>
  //     values.elementAt(semitones - 1);

  const Interval._(
      {@required this.number,
      @required this.quality,
      @required this.semitones});

  // factory Interval.between(PitchClass pitch1, PitchClass pitch2, {pitchSpeller = EqualTempermentPitchSpeller()}) {
  // factory Interval.between(PitchClass pitch1, PitchClass pitch2) {
  factory Interval.between(PitchClass pitch1, PitchClass pitch2) {
    // final difference = (note1.value - note2.value).abs();
    final index = pitch1.setNumber % pitch2.setNumber;
    // TODO: need a note spelling algorithm to determine which interval quality
    // to return here
    return values[index];
  }

  // static Set<Interval> get values => _$iValues;
  // static Interval valueOf(String name) => _$iValueOf(name);

  static List<Interval> get values => [];

  @override
  List<Object> get props => [semitones];

  @override
  bool get stringify => true;

  String get abbreviation => '${quality.abbreviation}${number.value}';

  String get description => '${quality.name} ${number.name}';

  Interval invert() => Interval._(
      number: number.invert(),
      quality: quality.invert(),
      semitones: 12 - semitones);

  // TODO: implement <, >, <=, >= methods to check if intervals are larger
  // or smaller than one another

  Interval operator +(Interval other) {
    // values.where((element) => interval.number == other.number)
    var newNumber = (number.value + other.number.value);
    var newSemitones = (semitones + other.semitones);
    IntervalNumber.valueOf(newNumber);
    // 0h == unison
    // 1h == 2nd
    // 2h == 2nd
    // 3h == 3rd
    // 4h == 3rd
    //

    // aug 2 + dim 3 = dd5
    // (3 semi, 2 num) + (2 semi, 3 num)
    // (5 semi, 5 num)

    // M2 + M3 == d5
    // Interval.from(semis, number)

    // same interval number but larger by 1 semitone == augmented
    // same interval number but smaller by 1 semitone == diminished
  }
}

class IntervalMatrix extends Matrix<Interval> {
  static const _values = [
    // 0 semitones
    [
      Interval.unison, // 0 staff positions
      Interval.diminished2nd, // 1 staff positions
      null, // 2 staff positions
      null, // 3 staff positions
      null, // 4 staff positions
      null, // 5 staff positions
      null, // 6 staff positions
      null // 7 staff positions
    ],
    // 1 semitones
    [
      Interval.augmentedUnison,
      Interval.minor2nd,
      null,
      null,
      null,
      null,
      null,
      null
    ],
    // 2 semitones
    [
      Interval.doublyAugmentedUnison,
      Interval.major2nd,
      Interval.diminished3rd,
      null,
      null,
      null,
      null,
      null
    ],
    // 3 semitones
    [
      null,
      Interval.augmented2nd,
      Interval.minor3rd,
      Interval.doublyDiminished4th,
      null,
      null,
      null,
      null
    ],
    // 4 semitones
    [
      null,
      Interval.doublyAugmented2nd,
      Interval.major3rd,
      Interval.diminished4th,
      null,
      null,
      null,
      null
    ],
    // 5 semitones
    [
      null,
      null,
      Interval.augmented3rd,
      Interval.perfect4th,
      Interval.doublyDiminished5th,
      null,
      null,
      null
    ],
    // 6 semitones
    [
      null,
      null,
      Interval.doublyAugmented3rd,
      Interval.augmented4th,
      Interval.diminished5th,
      null,
      null,
      null
    ],
    // 7 semitones
    [
      null,
      null,
      null,
      Interval.doublyAugmented4th,
      Interval.perfect5th,
      Interval.diminished6th,
      null,
      null
    ],
    // 8 semitones
    [
      null,
      null,
      null,
      null,
      Interval.augmented5th,
      Interval.minor6th,
      null,
      null
    ],
    // 9 semitones
    [
      null,
      null,
      null,
      null,
      Interval.doublyAugmented5th,
      Interval.major6th,
      Interval.diminished7th,
      null
    ],
    // 10 semitones
    [
      null,
      null,
      null,
      null,
      null,
      Interval.augmented6th,
      Interval.minor7th,
      Interval.doublyDiminishedOctave,
    ],
    // 11 semitones
    [
      null,
      null,
      null,
      null,
      null,
      Interval.doublyAugmented6th,
      Interval.major7th,
      Interval.diminishedOctave,
    ],
  ];

  /// Row index is the number of semitones
  /// Column index is the number of staff positions
  Interval operator [](MatrixIndex index) {
    var interval = _values[index.row][index.column];
    if (interval == null) throw RangeError.index(index, _values);
    return interval;
  }
}
