import 'dart:math' show log, pow;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:prelude/prelude.dart';
import 'interval.dart';
import 'pitch_spelling.dart';

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

  Octave.fromFrequency(Frequency frequency) {}

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

  /// Converts this [Octave] into a [MidiNote].
  MidiNote toNoteNumber() => MidiNote((_number + 1) * semitones);
}

/// A frequency
@immutable
class Frequency extends ValueInRange<double> with EquatableMixin {
  /// The standard tuning frequency, also known as [A440](https://en.wikipedia.org/wiki/A440_(pitch_standard)).
  static const iso16TuningFrequency = Frequency(440.0);
  static const double _minimum = 0.0;
  static const double _maximum = 22050.0;

  /// Creates a new [Frequency] from a given value.
  const Frequency(double value) : super(value, _minimum, _maximum);

  Frequency.fromPitchAttributes(NoteName noteName, Octave octave,
      {Frequency tuningFrequency = iso16TuningFrequency}) {
    var octaveDivision = 12;
    var semitoneHz = pow(2, 1 / octaveDivision);
    // var semitoneStepsCount = UnorderedPitchInterval.between(pitch1, pitch2);
    const referencePitchClass = PitchClass.aNatural;
    const referenceOctave = Octave(4);
    var referencePitch = Pitch(referencePitchClass, referenceOctave);
    var givenPitch = PitchClass.fromPitchAttributes(noteName, octave);
    var semitoneStepsCount =
        UnorderedPitchInterval.between(pitch1, referencePitch);
    var frequency = tuningFrequency * pow(semitoneHz, semitoneStepsCount);
  }

  /// Creates a new [Frequency] from a given [MidiNote].
  factory Frequency.fromMidiNote(MidiNote midiNote,
      {Frequency tuningFrequency}) {
    final tuningPitchNoteNumber = MidiNote.iso16tuningPitch;
    final actualTuningPitch = tuningFrequency ?? Frequency.iso16TuningPitch;
    final frequencyValue = pow(
            2.0,
            (midiNote.toDouble() - tuningPitchNoteNumber.toDouble()) /
                Octave.semitones) *
        actualTuningPitch.toDouble();
    return Frequency(frequencyValue);
  }

  /// Convert this [Frequency] into a [MidiNote].
  MidiNote toMidiNote() => MidiNote.fromFrequency(this);

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
class MidiNote {
  /// The note number corresponding to middle C on a standard piano keyboard.
  static const MidiNote middleC = MidiNote(60, 0);

  /// The ISO 16 standard tuning pitch [MidiNote], perhaps better known as A4
  /// or the A above middle C on a piano keyboard.
  static const iso16tuningPitch = MidiNote(69, 0);

  static const int _minimum = 0;

  static const int _maximum = 127;

  final int number;

  final int cents;

  final int semitoneFraction;

  /// Creates a new [MidiNote] from a given value.
  const MidiNote(this.number, this.cents)
      : assert(cents >= 0),
        assert(cents <= 100),
        assert(number >= 0),
        assert(number <= 127);
  // super(number, _minimum, _maximum);

  /// Creates a [NoteNumber] from a [Frequency], with option to use an
  /// alternative tuning pitch (default is [TuningPitch.A_440] or A above middle
  /// C == 440Hz).
  factory MidiNote.fromFrequency(Frequency frequency, {Frequency tuningPitch}) {
    final actualTuningPitch = tuningPitch ?? Frequency.iso16TuningPitch;
    final tuningPitchNoteNumber = MidiNote.iso16tuningPitch.toInt();
    final tuningRatio = frequency.toDouble() / actualTuningPitch.toDouble();
    final noteValue =
        tuningPitchNoteNumber + Octave.semitones * log(tuningRatio);
    return MidiNote(noteValue.round());
  }

  /// Converts the [MidiNote] into a [Frequency].
  Frequency toFrequency({Frequency tuningPitch}) =>
      Frequency.fromNoteNumber(this,
          tuningPitch: tuningPitch ?? Frequency.iso16TuningPitch);

  // /// Returns the [Interval] between this [NoteNumber] and another.
  // Interval interval(NoteNumber number) => Interval(value % number.value);
}

class Pitch {
  // TODO: don't make MidiNote part of the innate data for Pitch, make it
  // something that can be derived from pitch, e.g. via pitch.toMidiNote()
  // final MidiNote noteNumber;
  final Frequency frequency;
  final PitchClass pitchClass;
  final Octave octave;
  // TODO: add cents to indicate detuning of note relative to MIDI note number
  // using 12 tone equal temperment as the basis
  // should this actually be part of the MIDI note number representation?
  final int cents;

  // TODO: only pass in frequency to init Pitch and the rest can be derived
  // see: https://newt.phys.unsw.edu.au/jw/notes.html

  Pitch(this.pitchClass, this.octave)
      : frequency = Frequency.fromPitchAttributes(pitchClass, octave),
        cents = 0;

  Pitch.fromFrequency(this.frequency,
      {Frequency tuningFrequency = Frequency.iso16TuningPitch})
      : cents =
            _centsFromFrequency(frequency, tuningFrequency: tuningFrequency),
        octave = Octave.fromFrequency(frequency),
        pitchClass = PitchClass.fromFrequency(frequency);

  Pitch.fromMidiNoteNumber(MidiNote midiNoteNumber);

  /// See: https://newt.phys.unsw.edu.au/jw/notes.html
  // TODO: move this logic into MIDI note number since the MIDI spec accounts
  // for representing an equal tempered tuning center pitch and it's offset
  // in cents
  // Also, rename it to MidiNote since it's not just the number
  static int _centsFromFrequency(Frequency frequency,
      {Frequency tuningFrequency}) {
    const octaveCents = 1200;
    const octaveFrequencyRatio = 2;
    var tuningFrequencyRatio =
        frequency.toDouble() / tuningFrequency.toDouble();
    var octaveDistance = log(tuningFrequencyRatio) / log(octaveFrequencyRatio);
    var centsDistance = octaveCents * octaveDistance;
    var semitoneCentsOffset = centsDistance.round() % 100;

    return semitoneCentsOffset > 25
        ? 50 - semitoneCentsOffset
        : semitoneCentsOffset;
  }

  // double _octaveFromFrequency({Frequency tuningFrequency}) =>
  //     // log(frequency.toDouble() / tuningFrequency.toDouble());
  //     Octave.fromFrequency(frequency);

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

  int toInt() => noteNumber.toInt();

  double toDouble() => frequency.toDouble();

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

// TODO: make this an interface or base class
// with ordered and unordered implementing/inheriting it
class PitchClassSet {
  Set<int> pitchClasses;

  get values {
    //
  }

  get normalOrder {
    //
  }

  get primeOrder {
    //
  }

  transpose(int steps) {
    //
  }

  invert() {}

  retrograde() {
    //
  }

  complement() {}

  rotate(int steps) {
    //
  }

  PitchClassSet operator *(int factor) {
    // this.values.map((pitchClass) => pitchClass * factor);
    // TODO: quotient must be % 12 to set the value between 1 and 12
  }
}

/// Combination of note name and accidental (independent of octave).
class PitchClass extends Equatable implements Comparable<PitchClass> {
  static const bSharp = PitchClass(0);

  static const cNatural = PitchClass(0);

  static const cSharp = PitchClass(1);

  static const dFlat = PitchClass(1);

  static const dNatural = PitchClass(2);

  static const dSharp = PitchClass(3);

  static const eFlat = PitchClass(3);

  static const eNatural = PitchClass(4);

  static const fFlat = PitchClass(4);

  static const eSharp = PitchClass(5);

  static const fNatural = PitchClass(5);

  static const fSharp = PitchClass(6);

  static const gFlat = PitchClass(6);

  static const gNatural = PitchClass(7);

  static const gSharp = PitchClass(8);

  static const aFlat = PitchClass(8);

  static const aNatural = PitchClass(9);

  static const aSharp = PitchClass(10);

  static const bFlat = PitchClass(10);

  static const bNatural = PitchClass(11);

  static const cFlat = PitchClass(11);

  final int setNumber;

  // TODO: use a map to lookup the set number from the pitch attributes
  PitchClass.fromPitchAttributes(NoteName noteName, Accidental accidental);

  const PitchClass(this.setNumber) : assert(setNumber >= 0 && setNumber <= 11);

  PitchClass.fromFrequency(Frequency frequency);

  @override
  List<Object> get props => [setNumber];

  @override
  bool get stringify => true;

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

  // List<Set<Interval>> get notes => List.unmodifiable([
  //       {cNatural, bSharp, dDoubleFlat},
  //       {cSharp, dFlat, bDoubleSharp, dDoubleFlat},
  //       {bSharp, cNatural, dDoubleFlat},
  //       {bSharp, cNatural, dDoubleFlat},
  //       {bSharp, cNatural, dDoubleFlat},
  //       {bSharp, cNatural, dDoubleFlat},
  //       {bSharp, cNatural, dDoubleFlat},
  //     ]);

  static List<PitchClass> get values => [
        bSharp,
        cNatural,
        dDoubleFlat,
        bDoubleSharp,
        cSharp,
        dFlat,
        cDoubleSharp,
        dNatural,
        eDoubleFlat,
        dSharp,
        eFlat,
        fDoubleFlat,
        dDoubleSharp,
        eNatural,
        fFlat,
        eSharp,
        fNatural,
        gDoubleFlat,
        eDoubleSharp,
        fSharp,
        gFlat,
        fDoubleSharp,
        gNatural,
        aDoubleFlat,
        gSharp,
        aFlat,
        gDoubleSharp,
        aNatural,
        bDoubleFlat,
        aSharp,
        bFlat,
        cDoubleFlat,
        aDoubleSharp,
        bNatural,
        cFlat,
      ];

  static PitchClass valueOf(String name) {
    // TODO: implement me
  }

  // List<PitchClass> get spellings {
  //   return values.where((pitchClass) => pitchClass == this);
  // }

  static PitchClass fromSpelling(PitchSpelling spelling) {
    final spellingToPitchClass = {
      PitchSpelling.cDoubleFlat: cDoubleFlat,
      PitchSpelling.cFlat: cFlat,
      PitchSpelling.cNatural: cNatural,
      PitchSpelling.cSharp: cSharp,
      PitchSpelling.cDoubleSharp: cDoubleSharp,
      PitchSpelling.dDoubleFlat: dDoubleFlat,
      PitchSpelling.dFlat: dFlat,
      PitchSpelling.dNatural: dNatural,
      PitchSpelling.dSharp: dSharp,
      PitchSpelling.dDoubleSharp: dDoubleSharp,
      PitchSpelling.eDoubleFlat: eDoubleFlat,
      PitchSpelling.eFlat: eFlat,
      PitchSpelling.eNatural: eNatural,
      PitchSpelling.eSharp: eSharp,
      PitchSpelling.eDoubleSharp: eDoubleSharp,
      PitchSpelling.fDoubleFlat: fDoubleFlat,
      PitchSpelling.fFlat: fFlat,
      PitchSpelling.fNatural: fNatural,
      PitchSpelling.fSharp: fSharp,
      PitchSpelling.fDoubleSharp: fDoubleSharp,
      PitchSpelling.gDoubleFlat: gDoubleFlat,
      PitchSpelling.gFlat: gFlat,
      PitchSpelling.gNatural: gNatural,
      PitchSpelling.gSharp: gSharp,
      PitchSpelling.gDoubleSharp: gDoubleSharp,
      PitchSpelling.aDoubleFlat: aDoubleFlat,
      PitchSpelling.aFlat: aFlat,
      PitchSpelling.aNatural: aNatural,
      PitchSpelling.aSharp: aSharp,
      PitchSpelling.aDoubleSharp: aDoubleSharp,
      PitchSpelling.bDoubleFlat: bDoubleFlat,
      PitchSpelling.bFlat: bFlat,
      PitchSpelling.bNatural: bNatural,
      PitchSpelling.bSharp: bSharp,
      PitchSpelling.bDoubleSharp: bDoubleSharp,
    };

    return spellingToPitchClass[spelling];
  }

  List<PitchSpelling> toSpellings() => PitchSpelling.fromPitchClass(this);

  // TODO: is this accurate enough when bb or * are involved?
  // should probably kill this in favor of alternateSpellings
  // and use a pitch spelling algorithm instead.
  // PitchClass enharmonicEquivalent() {
  //   final enharmonicNotes = {
  //     aFlat: gSharp,
  //     // aNatural is itself
  //     aSharp: bFlat,
  //     bFlat: aSharp,
  //     bNatural: cFlat,
  //     bSharp: cNatural,
  //     cFlat: bNatural,
  //     cNatural: bSharp,
  //     cSharp: dFlat,
  //     dFlat: cSharp,
  //     // dNatural is itself
  //     dSharp: eFlat,
  //     eFlat: dSharp,
  //     eNatural: fFlat,
  //     eSharp: fNatural,
  //     fFlat: eNatural,
  //     fNatural: eSharp,
  //     fSharp: gFlat,
  //     // gNatural is itself
  //     gSharp: aFlat,
  //   };
  //   return enharmonicNotes[this] ?? this;
  // }

  PitchClass operator +(Interval interval) {
    var currentIndex = values.indexOf(this);
    var additionalSemitones = interval.toSemitones();
    var totalNotesCount = 12;
    var newNoteIndex = (currentIndex + additionalSemitones) % totalNotesCount;
    // G# + M7 = F*

    return values.elementAt(newNoteIndex);
  }

  PitchClass operator -(Interval interval) {
    var currentIndex = values.indexOf(this);
    var additionalSemitones = interval.toSemitones();
    var totalNotesCount = 12;
    var newNoteIndex =
        (currentIndex - additionalSemitones).abs() % totalNotesCount;

    return values.elementAt(newNoteIndex);
  }

  int compareTo(PitchClass other) {
    if (setNumber > other.setNumber) return 1;
    if (setNumber < other.setNumber) return -1;
    return 0;
  }
}
