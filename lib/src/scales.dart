import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:built_collection/built_collection.dart';
import 'interval.dart';
import 'pitch.dart';

enum ScaleType {
  harmonicMinor,
  major,
  melodicMinor,
  octatonic,
}

abstract class ScaleAttributes {
  /// The count of steps in this [Scale].
  int get stepsCount;

  /// A [List] of [Interval]s between each step in this [Scale], relative to the
  /// previous scale step.
  List<Interval> get stepwiseIntervals;

  /// A [List] of [Interval]s between the tonic and each step in this [Scale].
  List<Interval> get tonicIntervals;

  /// A [List] of the notes or, more specifically, the [PitchClass]es in this
  /// [Scale].
  List<PitchClass> get notes;

  static _tonicIntervalsFromStepwise(List<Interval> stepwiseIntervals) =>
      stepwiseIntervals
        // get all intervals except the one between subtonic and tonic
        .sublist(0, stepwiseIntervals.length - 1)
        // create a new array where each element is the cumulative sum of
        // intervals between scale steps
        .fold([], (intervals, interval) => [
          ...intervals,
          if (intervals.isEmpty) interval
          else intervals.last + interval,
        ]);
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
}

class ChromaticScale extends Scale {
  final intervals = UnmodifiableListView<Interval>([
    Interval.minor2nd,
    Interval.major2nd,
    Interval.minor3rd,
    Interval.major3rd,
    Interval.perfect4th,
    Interval.tritone,
    Interval.perfect5th,
    Interval.minor6th,
    Interval.major6th,
    Interval.minor7th,
    Interval.major7th,
  ]);

  int get stepsCount => 12;
}

mixin MajorScaleAttributes implements ScaleAttributes {
  final int stepsCount = _stepwiseIntervals.length;

  final List<Interval> stepwiseIntervals = _stepwiseIntervals;

  final List<Interval> tonicIntervals = _tonicIntervals;

  static Interval intervalOf(int scaleDegree) =>
      _tonicIntervals[scaleDegree - 1];

  // intervals between each note
  // W-W-H-W-W-W-H
  static final List<Interval> _stepwiseIntervals = List.unmodifiable([
    Interval.major2nd,
    Interval.major2nd,
    Interval.minor2nd,
    Interval.major2nd,
    Interval.major2nd,
    Interval.major2nd,
    Interval.minor2nd,
  ]);

  static final List<Interval> _tonicIntervals =
      ScaleAttributes._tonicIntervalsFromStepwise(_stepwiseIntervals);
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
  MajorScale.ofMode(int scaleDegree, {@required PitchClass withTonic})
      : super(withTonic - MajorScaleAttributes.intervalOf(scaleDegree));
}

mixin HarmonicMinorScaleAttributes implements ScaleAttributes {
  final int stepsCount = _stepwiseIntervals.length;

  final List<Interval> stepwiseIntervals = _stepwiseIntervals;

  final List<Interval> tonicIntervals = _tonicIntervals;

  static Interval intervalOf(int scaleDegree) =>
      _tonicIntervals[scaleDegree - 1];

  static final List<Interval> _stepwiseIntervals = List.unmodifiable([
    Interval.major2nd,
    Interval.minor2nd,
    Interval.major2nd,
    Interval.major2nd,
    Interval.minor2nd,
    Interval.minor3rd,
    Interval.minor2nd,
  ]);

  static final List<Interval> _tonicIntervals =
      ScaleAttributes._tonicIntervalsFromStepwise(_stepwiseIntervals);
}

class HarmonicMinorScale extends Scale {
  final _intervals = BuiltSet<Interval>([
    Interval.major2nd, // 1
    Interval.major2nd, // 2
    Interval.minor2nd, // 3
    Interval.major2nd, // 4
    Interval.major2nd, // 5
    Interval.major2nd, // 6
    Interval.minor2nd, // 7
  ]);

  final int stepsCount = 7;

  const HarmonicMinorScale(PitchClass tonic) : super(tonic);
}

class MelodicMinorScale extends Scale {
  static const _intervals = <Interval>{
    Interval.major2nd, // 1
    Interval.major2nd, // 2
    Interval.minor2nd, // 3
    Interval.major2nd, // 4
    Interval.major2nd, // 5
    Interval.major2nd, // 6
    Interval.minor2nd, // 7
  };

  final int stepsCount = 7;

  const MelodicMinorScale(PitchClass tonic) : super(tonic);

  static Scale ofMode(PitchClass tonic, int modeNumber) {}
}

class PentatonicScale extends Scale {
  final int stepsCount = 5;

  const PentatonicScale(PitchClass tonic) : super(tonic);
}

class HexatonicScale extends Scale {
  final int stepsCount = 6;

  const HexatonicScale(PitchClass tonic) : super(tonic);
}

class OctatonicScale extends Scale {
  final int stepsCount = 8;

  const OctatonicScale(PitchClass tonic) : super(tonic);
}

class Mode {
  /// The [PitchClass] of the modal tonic for this [Mode]. This is the pitch
  /// class on which the scale mode begins.
  final PitchClass tonic;

  /// The [ModeAttributes] belonging to this [Mode].
  final ModeAttributes attributes;

  final Scale parentScale;

  String get name => attributes.modeName ?? 'unnamed';

  int get modeNumber => attributes.modeNumber;

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
  // factory Mode({PitchClass tonic, int scaleDegree}) = _Mode<T>;
  // factory Mode.phrygian(PitchClass tonic) = _Mode.phrygian<MajorScale>;
  // factory ScaleMode.of({@required PitchClass tonic, @required int number}) {
  //   switch (T.runtimeType) {
  //     case MajorScale: return MajorScaleMode.of(tonic, number);
  //     default:
  //   }
  // }
  // factory Mode.create({PitchClass modalTonic, int modeNumber}) =>
  //     Mode._(modalTonic: modalTonic, modeNumber: modeNumber);

  Mode({@required this.tonic, @required this.attributes, Function builder})
      : parentScale = _createParentScale(tonic, attributes, builder);

  List<PitchClass> get notes => [
        // from modal tonic to end of parent scale
        ...parentScale.notes.sublist(attributes.modeNumber),
        // from start of parent scale to modal tonic (exclusive)
        ...parentScale.notes.sublist(0, attributes.modeNumber),
      ];

  static Scale _createParentScale(PitchClass tonic, ModeAttributes attributes,
      [Function builder]) {
    switch (attributes.parentScaleType) {
      case MajorScale:
        return MajorScale.ofMode(attributes.modeNumber, tonic);
      case MelodicMinorScale:
        return MelodicMinorScale.ofMode(attributes.modeNumber, tonic);
      default:
        builder(tonic, attributes.modeNumber);
    }
  }
}

// Enables comparisons like:
// ModeType.dorian.parentScale == MajorScale
// TODO: create a parent class and have subclasses to contain descriptors
// that match up with each of the scale types?
abstract class ModeAttributes {
  // static const ModeAttributes melodicMinor = const ModeAttributes._(MelodicMinorScale, 'melodicMinor', 1);
  // static const ModeAttributes jazzMinor = const ModeAttributes._(MelodicMinorScale, 'melodicMinor', 1);
  // static const ModeAttributes ionianFlat3 = const ModeAttributes._(MelodicMinorScale, 'melodicMinor', 1);

  /// The name of the [Mode] that has these [ModeAttributes].
  final String modeName;

  /// The scale degree on which the [Mode] with these [ModeAttributes] starts,
  /// relative to the root note of its parent [Scale]. Starts counting from 1
  /// (not 0).
  final int modeNumber;

  /// The type of [Scale] from which this [Mode] is derived.
  final Type parentScaleType;

  const ModeAttributes({
    this.modeName,
    @required this.modeNumber,
    @required this.parentScaleType,
  });
}

class MajorScaleModeAttributes extends ModeAttributes {
  static const ModeAttributes ionian = MajorScaleModeAttributes._('ionian', 1);
  static const ModeAttributes dorian = MajorScaleModeAttributes._('dorian', 2);
  static const ModeAttributes phrygian =
      MajorScaleModeAttributes._('phrygian', 3);
  static const ModeAttributes lydian = MajorScaleModeAttributes._('lydian', 4);
  static const ModeAttributes mixolydian =
      MajorScaleModeAttributes._('mixolydian', 5);
  static const ModeAttributes aeolian =
      MajorScaleModeAttributes._('aeolian', 6);
  static const ModeAttributes locrian =
      MajorScaleModeAttributes._('locrian', 7);

  const MajorScaleModeAttributes._(String modeName, int modeNumber)
      : super(
            modeName: modeName,
            modeNumber: modeNumber,
            parentScaleType: MajorScale);
}

class MelodicMinorScaleMode {}

class HarmonicMinorScaleMode {}
