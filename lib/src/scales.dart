import 'package:meta/meta.dart';
import 'interval.dart';
import 'pitch.dart';

abstract class PitchClassSet {
  final Set<int> value;
  // Set<int> get value;

  PitchClassSet(this.value)
      : assert(value.every((n) => n >= 0 && n <= 11)),
        assert(value.length < 12);
}

class MajorScalePitchClassSet extends PitchClassSet {
  // final value = {0, 2, 4, 5, 7, 9, 11};
  MajorScalePitchClassSet() : super({0, 2, 4, 5, 7, 9, 11, 15});
  // MajorScalePitchClassSet() : value = {0, 2, 4, 5, 7, 9, 11};
}

abstract class ScaleAttributes {
  PitchClass get tonic;

  /// The count of steps in this [Scale].
  int get stepsCount;

  /// A [List] of [Interval]s between each step in this [Scale], relative to the
  /// previous scale step.
  List<Interval> get stepwiseIntervals;

  /// A [List] of [Interval]s between the tonic and each step in this [Scale].
  List<Interval> get tonicIntervals;
  // Set<int> get tonicIntervals; {0, 2, 4, 5, 7, 9, 11}
  // Set<int> get pitchClassSet;
  // MajorScalePitchClassSet();

  /// A [List] of the notes or, more specifically, the [PitchClass]es in this
  /// [Scale].
  List<PitchClass> get notes;

  static List<PitchClass> _notes(List<Interval> tonicIntervals) =>
      tonicIntervals.map((interval) => tonic + interval);

  static List<Interval> tonicIntervalsFromStepwise(
          List<Interval> stepwiseIntervals) =>
      stepwiseIntervals
          // get all intervals except the one between subtonic and tonic
          .sublist(0, stepwiseIntervals.length - 1)
          // create a new array where each element is the cumulative sum of
          // intervals between scale steps
          .fold(
              [],
              (intervals, interval) => [
                    ...intervals,
                    if (intervals.isEmpty)
                      interval
                    else
                      intervals.last + interval,
                  ]);

  static parentScaleTonicOf(Mode mode) =>
      mode.tonic - _tonicIntervals[mode.number - 1];
}

abstract class Scale implements ScaleAttributes {
  final PitchClass tonic;

  const Scale(this.tonic);

  /// Creates a new [Scale] starting from the given [PitchClass].
  ///
  /// ```
  /// MajorScale.startingOn(PitchClass.fNatural);
  /// MelodicMinorScale.startingOn(PitchClass.eFlat)
  /// ```
  const factory Scale.chromatic(PitchClass tonic) = ChromaticScale;
  const factory Scale.diminished(PitchClass tonic) = OctatonicScale;
  const factory Scale.harmonicMinor(PitchClass tonic) = HarmonicMinorScale;
  const factory Scale.major(PitchClass tonic) = MajorScale;
  const factory Scale.melodicMinor(PitchClass tonic) = MelodicMinorScale;
  const factory Scale.octatonic(PitchClass tonic) = OctatonicScale;

  // Scale.ofMode(int scaleDegree, {@required PitchClass withTonic})
  //     : super(withTonic - Scale.intervalOf(scaleDegree));

  /// An ordered [List] of the [PitchClass]es in this [Scale], starting on the
  /// tonic degree.
  List<PitchClass> get notes =>
      tonicIntervals.map((interval) => tonic + interval);

  /// Returns the [PitchClass] in this [Scale] at the given [scaleDegree].
  ///
  /// ```
  /// var scale = MajorScale.startingOn(PitchClass.cNatural);
  /// assert(scale[0] == PitchClass.cNatural);
  /// assert(scale[1] == PitchClass.dNatural);
  /// assert(scale[7] == PitchClass.bNatural);
  /// ```
  PitchClass operator [](int scaleDegree) {
    // TODO: look up the pitch class using a 1-indexed value
    final noteNumber = scaleDegree - 1;
    return notes[noteNumber];
  }

  int scaleDegreeOf(PitchClass pitchClass) => notes.indexOf(pitchClass) + 1;

  /// Transpose this [Scale] by the given number of [semitones].
  Scale transpose(Interval interval) {
    var newStartingPitch = notes[0] + interval;
  }

  /// Inverts this [Scale] around its starting [PitchClass].
  Scale invert() {
    var newIntervals =
        intervals.map((interval) => 12 - interval.toSemitones()).toList();
    // TODO: figure out how to get pitch classes (need starting note)
    Scale._(intervals: newIntervals.sort());
    // var interval = Interval.fromPitchClasses(startingPitch, scaleDegree);
    // interval.invert();
    // major scale semitones = 0 2 4 5 7 9 11
    // inverted semitones = 12 10 8 7 5 3 1 => 0 1 3 5 7 8 10 (2nd mode of Db)
  }

  static notesFromIntervals(PitchClass tonic, List<Interval> intervals) =>
      // intervals.map((interval) => tonic + interval);
      // how to tell which notes are correct spelling for this scale?
      // do we need a concept of key signature as part of scale attrs?
      // can it be based on the accidental of the tonic?
      // e.g. scale on F# should only have # notes, not flats
      intervals.fold([], (previous, interval) {
        var note = tonic + interval;
        // major scale semitones = 0 2 4 5 7 9 11
        // M2, M3, P4, P5, M6, M7

        // tonic: F#
        // note: D#
        // do nothing

        // tonic: Bb
        // note: D#
        // D# => Eb

        // tonic: F
        // note: A#
        // A# => Bb

        // tonic: G
        // note: F#
        // do nothing

        // G# major: G# A# B# C# D# E# F*
        // Ab major: Ab Bb C Db Eb F G

        // all natural note major keys except F use sharps

        // melodic minor
        // C: C D Eb F G A B (key of C minor)
        // M2 m3 P4 P5 M6 M7
        // G#: G# A# B
        if (tonic.accidental != Accidental.sharp &&
            note.accidental == Accidental.sharp) {
          //
        }

        return [
          ...previous,
        ];
      });
}

mixin ChromaticScaleAttributes implements ScaleAttributes {
  final int stepsCount = _stepwiseIntervals.length;

  final List<Interval> stepwiseIntervals = _stepwiseIntervals;

  final List<Interval> tonicIntervals = _tonicIntervals;

  static final List<Interval> _stepwiseIntervals = List.unmodifiable([
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
    Interval.minor2nd, // half
  ]);

  static final List<Interval> _tonicIntervals =
      ScaleAttributes.tonicIntervalsFromStepwise(_stepwiseIntervals);

  static Interval intervalOf(int scaleDegree) =>
      _tonicIntervals[scaleDegree - 1];
}

class ChromaticScale extends Scale with ChromaticScaleAttributes {
  ChromaticScale(PitchClass tonic) : super(tonic);
}

mixin MajorScaleAttributes implements ScaleAttributes {
  final int stepsCount = _stepwiseIntervals.length;

  final List<Interval> stepwiseIntervals = _stepwiseIntervals;

  final List<Interval> tonicIntervals = _tonicIntervals;

  static final List<Interval> _stepwiseIntervals = List.unmodifiable([
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.minor2nd, // half
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.minor2nd, // half
  ]);

  static final List<Interval> _tonicIntervals =
      ScaleAttributes.tonicIntervalsFromStepwise(_stepwiseIntervals);

  // static Interval intervalOf(int scaleDegree) =>
  //     _tonicIntervals[scaleDegree - 1];

  static parentScaleTonicOf(Mode mode, List<Interval> tonicIntervals) =>
      mode.tonic - tonicIntervals[mode.number - 1];
}

class MajorScale extends Scale with MajorScaleAttributes {
  MajorScale(PitchClass tonic) : super(tonic);

  /// Creates a [MajorScale] that is the parent of the [Mode] starting on
  /// [scaleDegree] and has a modal tonic of [withTonic].
  ///
  /// For example, to get the parent scale of the D-sharp Lydian mode (the A
  /// major scale):
  ///
  /// ```
  /// var scale = MajorScale.ofMode(4, withTonic: PitchClass.dSharp);
  /// assert(scale == MajorScale(PitchClass.aNatural));
  /// ```
  // MajorScale.ofMode(int scaleDegree, {@required PitchClass withTonic})
  // : super(mode.tonic - MajorScaleAttributes.intervalOf(mode.number));
  MajorScale.ofMode(Mode mode)
      : super(MajorScaleAttributes.parentScaleTonicOf(
            mode, MajorScaleAttributes._stepwiseIntervals));
}

mixin HarmonicMinorScaleAttributes implements ScaleAttributes {
  final int stepsCount = _stepwiseIntervals.length;

  final List<Interval> stepwiseIntervals = _stepwiseIntervals;

  final List<Interval> tonicIntervals = _tonicIntervals;

  static Interval intervalOf(int scaleDegree) =>
      _tonicIntervals[scaleDegree - 1];

  static final List<Interval> _stepwiseIntervals = List.unmodifiable([
    Interval.major2nd, // whole
    Interval.minor2nd, // half
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.minor2nd, // half
    Interval.minor3rd, // aug. 2nd
    Interval.minor2nd, // half
  ]);

  static final List<Interval> _tonicIntervals =
      ScaleAttributes.tonicIntervalsFromStepwise(_stepwiseIntervals);
}

class HarmonicMinorScale extends Scale with HarmonicMinorScaleAttributes {
  HarmonicMinorScale(PitchClass tonic) : super(tonic);

  /// Creates a [HarmonicMinorScale] that is the parent of the [Mode] starting on
  /// [scaleDegree] and has a modal tonic of [withTonic].
  ///
  /// For example, to get the parent scale of the D-sharp Lydian mode (the A
  /// major scale):
  ///
  /// ```
  /// var scale = HarmonicMinorScale.ofMode(4, withTonic: PitchClass.dSharp);
  /// assert(scale == HarmonicMinorScale(PitchClass.aNatural));
  /// ```
  // HarmonicMinorScale.ofMode(int scaleDegree, {@required PitchClass withTonic})
  HarmonicMinorScale.ofMode(Mode mode)
      : super(
            mode.tonic - HarmonicMinorScaleAttributes.intervalOf(mode.number));
}

mixin MelodicMinorScaleAttributes implements ScaleAttributes {}

class MelodicMinorScale extends Scale with MelodicMinorScaleAttributes {
  static const _intervals = <Interval>{
    Interval.major2nd, // whole
    Interval.minor2nd, // half
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.minor2nd, // half
  };

  final int stepsCount = 7;

  const MelodicMinorScale(PitchClass tonic) : super(tonic);

  // MelodicMinorScale.ofMode(int scaleDegree, {@required PitchClass withTonic})
  MelodicMinorScale.ofMode(Mode mode)
      : super(mode.tonic - MelodicMinorScaleAttributes.intervalOf(mode.number));
}

mixin MajorPentatonicScaleAttributes implements ScaleAttributes {
  final int stepsCount = _stepwiseIntervals.length;

  final List<Interval> stepwiseIntervals = _stepwiseIntervals;

  final List<Interval> tonicIntervals = _tonicIntervals;

  static Interval intervalOf(int scaleDegree) =>
      _tonicIntervals[scaleDegree - 1];

  static final List<Interval> _stepwiseIntervals = List.unmodifiable([
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.minor3rd, // minor 3rd
    Interval.major2nd, // whole
    Interval.minor3rd, // minor 3rd
  ]);

  static final List<Interval> _tonicIntervals =
      ScaleAttributes.tonicIntervalsFromStepwise(_stepwiseIntervals);
}

// TODO: Egyptian/suspended? (mode 2 of the major)
// TODO: blues minor (mode 3 of the major)
// TODO: blues major (mode 4 of the major)
// TODO: minor pentatonic scale (mode 5 of the major)
// TODO: Japanese scale? (scale tones 1, 2, 4, 5, 6 of phrygian mode)
class MajorPentatonicScale extends Scale with MajorPentatonicScaleAttributes {
  MajorPentatonicScale(PitchClass tonic) : super(tonic);
}

// TODO: hexatonic major scale
// TODO: hexatonic minor scale
// TODO: whole tone scale
// TODO: blues scale
// TODO: augmented scale
// TODO: tritone scale
class HexatonicScale extends Scale {
  final int stepsCount = 6;

  const HexatonicScale(PitchClass tonic) : super(tonic);
}

mixin WholeToneScaleAttributes implements ScaleAttributes {
  final int stepsCount = _stepwiseIntervals.length;

  final List<Interval> stepwiseIntervals = _stepwiseIntervals;

  final List<Interval> tonicIntervals = _tonicIntervals;

  static Interval intervalOf(int scaleDegree) =>
      _tonicIntervals[scaleDegree - 1];

  static final List<Interval> _stepwiseIntervals = List.unmodifiable([
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.major2nd, // whole
    Interval.major2nd, // whole
  ]);

  static final List<Interval> _tonicIntervals =
      ScaleAttributes.tonicIntervalsFromStepwise(_stepwiseIntervals);
}

class WholeToneScale extends HexatonicScale {}

class OctatonicScale extends Scale {
  final int stepsCount = 8;

  const OctatonicScale(PitchClass tonic) : super(tonic);
}

///
/// ```
/// var ePhrygian = Mode(tonic: PitchClass.eNatural,
///     attributes: MajorScaleModeAttributes.phrygian);
/// assert(ePhrygian.name == 'phrygian');
/// assert(ePhrygian.tonic == PitchClass.eNatural);
/// assert(ePhrygian.parentScale == MajorScale(PitchClass.cNatural));
/// assert(ePhrygian.modeNumber == 3);
///
/// var lydianDominant = Mode(tonic: PitchClass.cNatural,
///     attributes: MelodicMinorScaleModeAttributes.lydianDominant);
/// assert(lydianDominant.name == 'lydianDominant');
/// assert(lydianDominant.tonic == PitchClass.gNatural);
/// assert(lydianDominant.modeNumber == 4);
/// ```
abstract class Mode implements ModeAttributes {
  final String name;

  final int number;

  final PitchClass tonic;

  const Mode(
      {@required this.tonic, @required this.name, @required this.number});

  /// Returns the notes of this [Mode] in scale order.
  List<PitchClass> get notes => parentScale.notes.rotateToStart(number);
}

abstract class ModeAttributes {
  /// The name of the [Mode] that has these [ModeAttributes].
  String get name;

  /// The scale degree on which the [Mode] with these [ModeAttributes] starts,
  /// relative to the root note of its parent [Scale]. Starts counting from 1
  /// (not 0).
  int get number;

  /// The parent [Scale] from which this [Mode] is derived.
  Scale get parentScale;

  /// The [PitchClass] of the modal tonic for this [Mode]. This is the pitch
  /// class on which the scale mode begins.
  PitchClass get tonic;
}

mixin MajorScaleModeAttributes implements ModeAttributes {
  Scale get parentScale => MajorScale.ofMode(this);
}

mixin MelodicMinorScaleModeAttributes implements ModeAttributes {
  Scale get parentScale => MelodicMinorScale.ofMode(this);
}

mixin HarmonicMinorScaleModeAttributes implements ModeAttributes {
  Scale get parentScale => HarmonicMinorScale.ofMode(this);
}

/// A [Mode] derived from the [MajorScale].
///
/// ```
/// var mode = MajorScaleMode.lydian(PitchClass.fNatural);
/// assert(mode.parentScale == MajorScale(PitchClass.cNatural));
/// ```
class MajorScaleMode extends Mode with MajorScaleModeAttributes {
  const MajorScaleMode.ionian(PitchClass tonic)
      : super(tonic: tonic, name: 'ionian', number: 1);

  const MajorScaleMode.dorian(PitchClass tonic)
      : super(tonic: tonic, name: 'dorian', number: 2);

  const MajorScaleMode.phrygian(PitchClass tonic)
      : super(tonic: tonic, name: 'phrygian', number: 3);

  const MajorScaleMode.lydian(PitchClass tonic)
      : super(tonic: tonic, name: 'lydian', number: 4);

  const MajorScaleMode.mixolydian(PitchClass tonic)
      : super(tonic: tonic, name: 'mixolydian', number: 5);

  const MajorScaleMode.aeolian(PitchClass tonic)
      : super(tonic: tonic, name: 'aeolian', number: 6);

  const MajorScaleMode.locrian(PitchClass tonic)
      : super(tonic: tonic, name: 'locrian', number: 7);
}

class MelodicMinorScaleMode extends Mode with MelodicMinorScaleModeAttributes {
  const MelodicMinorScaleMode.melodicMinor(PitchClass tonic)
      : super(tonic: tonic, name: 'melodicMinor', number: 1);

  const MelodicMinorScaleMode.jazzMinor(PitchClass tonic)
      : this.melodicMinor(tonic);

  const MelodicMinorScaleMode.ionianFlat3(PitchClass tonic)
      : this.melodicMinor(tonic);

  const MelodicMinorScaleMode.dorianFlat2(PitchClass tonic)
      : super(tonic: tonic, name: 'dorianFlat2', number: 2);

  const MelodicMinorScaleMode.phrygianSharp6(PitchClass tonic)
      : this.dorianFlat2(tonic);

  const MelodicMinorScaleMode.lydianAugmented(PitchClass tonic)
      : super(tonic: tonic, name: 'lydianAugmented', number: 3);

  const MelodicMinorScaleMode.lydianSharp5(PitchClass tonic)
      : this.lydianAugmented(tonic);

  const MelodicMinorScaleMode.lydianDominant(PitchClass tonic)
      : super(tonic: tonic, name: 'lydianDominant', number: 4);

  const MelodicMinorScaleMode.lydianFlat7(PitchClass tonic)
      : this.lydianDominant(tonic);

  const MelodicMinorScaleMode.melodicMajor(PitchClass tonic)
      : super(tonic: tonic, name: 'melodicMajor', number: 5);

  const MelodicMinorScaleMode.mixolydianFlat6(PitchClass tonic)
      : this.melodicMajor(tonic);

  const MelodicMinorScaleMode.halfDiminished(PitchClass tonic)
      : super(tonic: tonic, name: 'halfDiminished', number: 6);

  /// Alias for the [halfDiminished] constructor of the [MelodicMinorScaleMode].
  const MelodicMinorScaleMode.locrianSharp2(PitchClass tonic)
      : this.halfDiminished(tonic);

  const MelodicMinorScaleMode.altered(PitchClass tonic)
      : super(tonic: tonic, name: 'altered', number: 7);

  const MelodicMinorScaleMode.diminishedWholeTone(PitchClass tonic)
      : this.altered(tonic);

  const MelodicMinorScaleMode.superLocrian(PitchClass tonic)
      : this.altered(tonic);
}

class HarmonicMinorScaleMode extends Mode
    with HarmonicMinorScaleModeAttributes {}
