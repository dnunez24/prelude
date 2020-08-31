import 'dart:math' show log, pow;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ValueInRange<T extends num> extends Equatable {
  /// The value of this object.
  final T _value;

  // ignore: unused_field
  final T _minValue;

  // ignore: unused_field
  final T _maxValue;

  /// Creates a numeric value object and checks that the given value falls
  /// between the minmum and maximum limits.
  const ValueInRange(this._value, this._minValue, this._maxValue)
      : assert(_value >= _minValue),
        assert(_value <= _maxValue);

  @override
  List<Object> get props => [_value];

  @override
  bool get stringify => true;

  /// Converts this object's value to an [int].
  int toInt() => _value.toInt();

  /// Converts this object's value to a [double].
  double toDouble() => _value.toDouble();

  void _validate(T value) {
    if (value < _minValue || value > _maxValue) {
      throw RangeError.range(
          value, _minValue.toInt(), _maxValue.toInt(), 'value');
    }
  }
}

/// An accidental symbol used in the Western musical notation system.
@immutable
class Accidental extends Equatable {
  /// The double flat (𝄫) [Accidental].
  static const Accidental doubleFlat = Accidental._('doubleFlat');

  /// The flat (♭) [Accidental].
  static const Accidental flat = Accidental._('flat');

  /// The natural (♮) [Accidental].
  static const Accidental natural = Accidental._('natural');

  /// The sharp (♯) [Accidental].
  static const Accidental sharp = Accidental._('sharp');

  /// The double sharp (𝄪) [Accidental].
  static const Accidental doubleSharp = Accidental._('doubleSharp');

  /// A [String] name for the [Accidental].
  final String name;

  const Accidental._(this.name);

  /// Returns the accidental symbol as a [String].
  String get symbol {
    final symbolMap = <Accidental, String>{
      doubleFlat: '𝄫',
      flat: '♭',
      natural: '♮',
      sharp: '♯',
      doubleSharp: '𝄪',
    };
    return symbolMap[this];
  }

  @override
  List<Object> get props => [name];

  @override
  bool get stringify => true;

  /// Returns a [Set] containing all possible [Accidental] values.
  static Set<Accidental> get values =>
      {doubleFlat, flat, natural, sharp, doubleSharp};

  /// Returns the [Accidental] that corresponds to [name].
  static Accidental valueOf(String name) {
    final lookupResult = values.lookup(Accidental._(name));
    if (lookupResult != null) return lookupResult;
    throw ArgumentError.value(name, 'name', 'invalid accidental name');
  }
}

@immutable
class Octave extends ValueInRange<int> with EquatableMixin {
  static const int semitones = 12;
  static const int _minimum = -1;
  static const int _maximum = 9;
  final int _number;

  /// Creates a new [Octave] with the given number.
  const Octave(this._number) : super(_number, _minimum, _maximum);

  // Octave.fromNoteNumber(NoteNumber noteNumber) {
  //   throw UnimplementedError();
  // }

  /// Returns the range of valid [Octave]s as a [List].
  static List<Octave> get range =>
      [for (var i = _minimum; i <= _maximum; i++) Octave(i)];

  @override
  List<Object> get props => [_number];

  @override
  bool get stringify => true;

  /// Converts this [Octave] into a [NoteNumber].
  NoteNumber toNoteNumber() => NoteNumber((_number + 1) * semitones);
}

/// A frequency
@immutable
class Frequency extends ValueInRange<double> with EquatableMixin {
  /// The standard tuning frequency, also known as [A440](https://en.wikipedia.org/wiki/A440_(pitch_standard)).
  static const iso16TuningPitch = Frequency(440.0);
  static const double _minimum = 0.0;
  static const double _maximum = 22050.0;

  /// Creates a new [Frequency] from a given value.
  const Frequency(double value) : super(value, _minimum, _maximum);

  /// Creates a new [Frequency] from a given [NoteNumber].
  factory Frequency.fromNoteNumber(NoteNumber noteNumber,
      {Frequency tuningPitch}) {
    final tuningPitchNoteNumber = NoteNumber.iso16tuningPitch;
    final actualTuningPitch = tuningPitch ?? Frequency.iso16TuningPitch;
    final frequencyValue = pow(
            2.0,
            (noteNumber.toDouble() - tuningPitchNoteNumber.toDouble()) /
                Octave.semitones) *
        actualTuningPitch.toDouble();
    return Frequency(frequencyValue);
  }

  /// Convert this [Frequency] into a [NoteNumber].
  NoteNumber toNoteNumber() => NoteNumber.fromFrequency(this);

  /// Adds the value of two [Frequency] values together and returns a new
  /// [Frequency].
  Frequency operator +(Frequency other) =>
      _performArithmeticOperation(other, (a, b) => a + b);

  /// Subtracts the the given [Frequency] from this one and returns a new
  /// [Frequency].
  Frequency operator -(Frequency other) =>
      _performArithmeticOperation(other, (a, b) => a - b);

  /// Multiplies the value of this [Frequency] by the given [Frequency] and
  /// returns a new [Frequency].
  Frequency operator *(Frequency other) =>
      _performArithmeticOperation(other, (a, b) => a * b);

  /// Divides the value of this [Frequency] by the given [Frequency] and
  /// returns a new Frequency.
  Frequency operator /(Frequency other) =>
      _performArithmeticOperation(other, (a, b) => a / b);

  Frequency _performArithmeticOperation(
      Frequency other, double Function(double, double) operation) {
    final newValue = operation(toDouble(), other.toDouble());
    _validate(newValue);
    return Frequency(newValue);
  }
}

@immutable
class NoteName extends Equatable {
  static const NoteName A = NoteName._('A');
  static const NoteName B = NoteName._('B');
  static const NoteName C = NoteName._('C');
  static const NoteName D = NoteName._('D');
  static const NoteName E = NoteName._('E');
  static const NoteName F = NoteName._('F');
  static const NoteName G = NoteName._('G');
  final String name;

  // TODO: use factory to cache and always return same object if values equal?
  const NoteName._(this.name);

  @override
  List<Object> get props => [name];

  @override
  bool get stringify => true;

  static Set<NoteName> get values => {A, B, C, D, E, F, G};

  static NoteName valueOf(String name) {
    final lookupResult = values.lookup(NoteName._(name));
    if (lookupResult != null) return lookupResult;
    throw ArgumentError.value(name, 'name', 'invalid note name');
  }
}

/// A note number in the pitch spectrum corresponding to the allowed
/// FiniteRange of [Octave]s. Matches the MIDI spec for note numbers, for example,
/// C-1 == 0.
class NoteNumber extends ValueInRange<int> {
  /// The note number corresponding to middle C on a standard piano keyboard.
  static const NoteNumber middleC = NoteNumber(60);

  /// The ISO 16 standard tuning pitch [NoteNumber], perhaps better known as A4
  /// or the A above middle C on a piano keyboard.
  static const iso16tuningPitch = NoteNumber(69);

  static const int _minimum = 0;
  static const int _maximum = 127;

  /// Creates a new [NoteNumber] from a given value.
  const NoteNumber(int value) : super(value, _minimum, _maximum);

  /// Creates a [NoteNumber] from a [Frequency], with option to use an
  /// alternative tuning pitch (default is [TuningPitch.A_440] or A above middle
  /// C == 440Hz).
  factory NoteNumber.fromFrequency(Frequency frequency,
      {Frequency tuningPitch}) {
    final actualTuningPitch = tuningPitch ?? Frequency.iso16TuningPitch;
    final tuningPitchNoteNumber = NoteNumber.iso16tuningPitch.toInt();
    final tuningRatio = frequency.toDouble() / actualTuningPitch.toDouble();
    final noteValue =
        tuningPitchNoteNumber + Octave.semitones * log(tuningRatio);
    return NoteNumber(noteValue.round());
  }

  /// Converts the [NoteNumber] into a [Frequency].
  Frequency toFrequency({Frequency tuningPitch}) =>
      Frequency.fromNoteNumber(this,
          tuningPitch: tuningPitch ?? Frequency.iso16TuningPitch);

  // /// Returns the [Interval] between this [NoteNumber] and another.
  // Interval interval(NoteNumber number) => Interval(value % number.value);
}

class Pitch {
  final NoteNumber noteNumber;
  final Frequency frequency;
  final PitchClass pitchClass;
  final Octave octave;

  const Pitch({this.noteNumber, this.frequency, this.octave, this.pitchClass});

  // TODO: implement Pitch.fromNoteNumber()
  // Pitch.fromNoteNumber(this.noteNumber)
  //     : octave = Octave.fromNoteNumber(noteNumber),
  //       pitchClass = PitchClass.fromNoteNumber(noteNumber),
  //       frequency = Frequency.fromNoteNumber(noteNumber);

  // TODO: implement Pitch.fromFrequency()
  // Pitch.fromFrequency(this.frequency, {Frequency tuningPitch})
  //     : noteNumber = NoteNumber.fromFrequency(frequency, tuningPitch: tuningPitch),
  //       octave = Octave.fromFrequency(frequency),
  //       pitchClass = PitchClass.fromFrequency(frequency, tuningPitch: tuningPitch);

  /// Returns a new [Pitch] that results from adding the given number of
  /// semitones to this [Pitch].
  ///
  /// ```
  /// const oldPitch = Pitch.fromNoteNumber(NoteNumber(60));
  /// const newPitch = oldPitch + Interval.major3rd.toSemitones();
  /// assert(newPitch == Pitch.fromNoteNumber(NoteNumber(64)));
  /// ```
  Pitch operator +(int semitones) =>
      _pitchFromNoteNumber(noteNumber.toInt() + semitones);

  /// Returns a new [Pitch] that results from subtracting the given number of
  /// semitones from this [Pitch].
  ///
  /// ```
  /// const oldPitch = Pitch.fromNoteNumber(NoteNumber(60));
  /// const newPitch = oldPitch - Interval.minor6th.toSemitones();
  /// assert(newPitch == Pitch.fromNoteNumber(NoteNumber(52)));
  /// ```
  Pitch operator -(int semitones) =>
      _pitchFromNoteNumber(noteNumber.toInt() - semitones);

  // TODO: find a better name for this function
  // _pitchFromNoteNumber(int number) => Pitch.fromNoteNumber(NoteNumber(number));
  _pitchFromNoteNumber(int number) => throw UnimplementedError();

  // NoteName.fromNoteNumber(NoteNumber number) : _value = _fromNoteNumber(number);

  // static String _fromNoteNumber(NoteNumber number) {
  //   Interval interval = Interval.between(NoteNumber.middleC, number);
  //   NoteName noteInScale = values[interval.value];
  //   return noteInScale.toString();
  // }
}

/// Combination of note name and accidental (independent of octave).
class PitchClass {
  static const aFlat =
      PitchClass._(noteName: NoteName.A, accidental: Accidental.flat);
  static const aNatural =
      PitchClass._(noteName: NoteName.A, accidental: Accidental.natural);
  static const aSharp =
      PitchClass._(noteName: NoteName.A, accidental: Accidental.sharp);
  static const bFlat =
      PitchClass._(noteName: NoteName.B, accidental: Accidental.flat);
  static const bNatural =
      PitchClass._(noteName: NoteName.B, accidental: Accidental.natural);
  static const bSharp =
      PitchClass._(noteName: NoteName.B, accidental: Accidental.sharp);
  static const cFlat =
      PitchClass._(noteName: NoteName.C, accidental: Accidental.flat);
  static const cNatural =
      PitchClass._(noteName: NoteName.C, accidental: Accidental.natural);
  static const cSharp =
      PitchClass._(noteName: NoteName.C, accidental: Accidental.sharp);
  static const dFlat =
      PitchClass._(noteName: NoteName.D, accidental: Accidental.flat);
  static const dNatural =
      PitchClass._(noteName: NoteName.D, accidental: Accidental.natural);
  static const dSharp =
      PitchClass._(noteName: NoteName.D, accidental: Accidental.sharp);
  static const eFlat =
      PitchClass._(noteName: NoteName.E, accidental: Accidental.flat);
  static const eNatural =
      PitchClass._(noteName: NoteName.E, accidental: Accidental.natural);
  static const eSharp =
      PitchClass._(noteName: NoteName.E, accidental: Accidental.sharp);
  static const fFlat =
      PitchClass._(noteName: NoteName.F, accidental: Accidental.flat);
  static const fNatural =
      PitchClass._(noteName: NoteName.F, accidental: Accidental.natural);
  static const fSharp =
      PitchClass._(noteName: NoteName.F, accidental: Accidental.sharp);
  static const gFlat =
      PitchClass._(noteName: NoteName.G, accidental: Accidental.flat);
  static const gNatural =
      PitchClass._(noteName: NoteName.G, accidental: Accidental.natural);
  static const gSharp =
      PitchClass._(noteName: NoteName.G, accidental: Accidental.sharp);

  final NoteName noteName;
  final Accidental accidental;

  const PitchClass._({this.noteName, this.accidental});

  // TODO: implement PitchClass.fromNoteNumber()
  // PitchClass.fromNoteNumber(NoteNumber noteNumber) {
  //   throw UnimplementedError();
  // }

  fromSemitones(int semitones) {
    // var map = {
    //   aNatural: 0,
    //   aSharp: 1,
    //   bFlat: 1,
    //   bNatural: 2,
    //   cFlat: 2,
    //   bSharp: 3,
    //   cNatural: 3,
    //   cSharp: 4,
    //   dFlat: 4,
    //   dNatural: 5,
    //   dSharp: 6,
    //   eFlat: 6,
    //   eNatural: 7,
    //   aFlat: 11,
    // };
  }

  static List<PitchClass> get values => List.unmodifiable([
    cNatural,
    cSharp,
  ]);

  static PitchClass valueOf(String name) {
    // TODO: implement me
  }

  PitchClass enharmonicEquivalent() {
    final enharmonicNotes = {
      aFlat: gSharp,
      // aNatural is itself
      aSharp: bFlat,
      bFlat: aSharp,
      bNatural: cFlat,
      bSharp: cNatural,
      cFlat: bNatural,
      cNatural: bSharp,
      cSharp: dFlat,
      dFlat: cSharp,
      // dNatural is itself
      dSharp: eFlat,
      eFlat: dSharp,
      eNatural: fFlat,
      eSharp: fNatural,
      fFlat: eNatural,
      fNatural: eSharp,
      fSharp: gFlat,
      // gNatural is itself
      gSharp: aFlat,
    };
    return enharmonicNotes[this] ?? this;
  }

  PitchClass operator +(Interval interval) {}

  PitchClass operator -(Interval interval) {}
}
