import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import '_extensions.dart';
import '_matrix.dart';
import 'pitch.dart';

class PitchSpelling extends Equatable {
  static const cDoubleFlat = PitchSpelling._(NoteName.C, Accidental.doubleFlat);

  static const cFlat = PitchSpelling._(NoteName.C, Accidental.flat);

  static const cNatural = PitchSpelling._(NoteName.C, Accidental.natural);

  static const cSharp = PitchSpelling._(NoteName.C, Accidental.sharp);

  static const cDoubleSharp =
      PitchSpelling._(NoteName.C, Accidental.doubleSharp);

  static const dDoubleFlat = PitchSpelling._(NoteName.D, Accidental.doubleFlat);

  static const dFlat = PitchSpelling._(NoteName.D, Accidental.flat);

  static const dNatural = PitchSpelling._(NoteName.D, Accidental.natural);

  static const dSharp = PitchSpelling._(NoteName.D, Accidental.sharp);

  static const dDoubleSharp =
      PitchSpelling._(NoteName.D, Accidental.doubleSharp);

  static const eDoubleFlat = PitchSpelling._(NoteName.E, Accidental.doubleFlat);

  static const eFlat = PitchSpelling._(NoteName.E, Accidental.flat);

  static const eNatural = PitchSpelling._(NoteName.E, Accidental.natural);

  static const eSharp = PitchSpelling._(NoteName.E, Accidental.sharp);

  static const eDoubleSharp =
      PitchSpelling._(NoteName.E, Accidental.doubleSharp);

  static const fDoubleFlat = PitchSpelling._(NoteName.F, Accidental.doubleFlat);

  static const fFlat = PitchSpelling._(NoteName.F, Accidental.flat);

  static const fNatural = PitchSpelling._(NoteName.F, Accidental.natural);

  static const fSharp = PitchSpelling._(NoteName.F, Accidental.sharp);

  static const fDoubleSharp =
      PitchSpelling._(NoteName.F, Accidental.doubleSharp);

  static const gDoubleFlat = PitchSpelling._(NoteName.G, Accidental.doubleFlat);

  static const gFlat = PitchSpelling._(NoteName.G, Accidental.flat);

  static const gNatural = PitchSpelling._(NoteName.G, Accidental.natural);

  static const gSharp = PitchSpelling._(NoteName.G, Accidental.sharp);

  static const gDoubleSharp =
      PitchSpelling._(NoteName.G, Accidental.doubleSharp);

  static const aDoubleFlat = PitchSpelling._(NoteName.A, Accidental.doubleFlat);

  static const aFlat = PitchSpelling._(NoteName.A, Accidental.flat);

  static const aNatural = PitchSpelling._(NoteName.A, Accidental.natural);

  static const aSharp = PitchSpelling._(NoteName.A, Accidental.sharp);

  static const aDoubleSharp =
      PitchSpelling._(NoteName.A, Accidental.doubleSharp);

  static const bDoubleFlat = PitchSpelling._(NoteName.B, Accidental.doubleFlat);

  static const bFlat = PitchSpelling._(NoteName.B, Accidental.flat);

  static const bNatural = PitchSpelling._(NoteName.B, Accidental.natural);

  static const bSharp = PitchSpelling._(NoteName.B, Accidental.sharp);

  static const bDoubleSharp =
      PitchSpelling._(NoteName.B, Accidental.doubleSharp);

  final NoteName noteName;

  final Accidental accidental;

  const PitchSpelling._(this.noteName, this.accidental);

  PitchClass toPitchClass() => PitchClass.fromSpelling(this);

  /// Returns all common [PitchSpelling]s for the given [PitchClass]. There is
  /// always more than one spelling for a [PitchClass].
  static List<PitchSpelling> fromPitchClass(PitchClass pitchClass) {
    var pitchClassToSpellings = [
      [bSharp, cNatural, dDoubleFlat],
      [bDoubleSharp, cSharp, dFlat],
      [dSharp, eFlat, fDoubleFlat],
      [dDoubleSharp, eNatural, fFlat],
      [eSharp, fNatural, gDoubleFlat],
      [eDoubleSharp, fSharp, gFlat],
      [fDoubleSharp, gNatural, aDoubleFlat],
      [gSharp, aFlat],
      [gDoubleSharp, aNatural, bDoubleFlat],
      [aSharp, bFlat, cDoubleFlat],
      [aDoubleSharp, bNatural, cFlat],
    ];

    return pitchClassToSpellings[pitchClass.setNumber];
  }

  @override
  List<Object> get props => [noteName, accidental];

  @override
  bool get stringify => true;
}

/// A matrix of all possible pitch spellings for semitones in the equal
/// temperment tuning system octave.
class PitchSpellingMatrix extends Matrix<PitchSpelling> {
  static const List<List<PitchSpelling>> _values = [
    [
      PitchSpelling.cDoubleFlat,
      PitchSpelling.dDoubleFlat,
      PitchSpelling.eDoubleFlat,
      PitchSpelling.fDoubleFlat,
      PitchSpelling.gDoubleFlat,
      PitchSpelling.aDoubleFlat,
      PitchSpelling.bDoubleFlat
    ],
    [
      PitchSpelling.cFlat,
      PitchSpelling.dFlat,
      PitchSpelling.eFlat,
      PitchSpelling.fFlat,
      PitchSpelling.gFlat,
      PitchSpelling.aFlat,
      PitchSpelling.bFlat
    ],
    [
      PitchSpelling.cNatural,
      PitchSpelling.dNatural,
      PitchSpelling.eNatural,
      PitchSpelling.fNatural,
      PitchSpelling.gNatural,
      PitchSpelling.aNatural,
      PitchSpelling.bNatural
    ],
    [
      PitchSpelling.cSharp,
      PitchSpelling.dSharp,
      PitchSpelling.eSharp,
      PitchSpelling.fSharp,
      PitchSpelling.gSharp,
      PitchSpelling.aSharp,
      PitchSpelling.bSharp
    ],
    [
      PitchSpelling.cDoubleSharp,
      PitchSpelling.dDoubleSharp,
      PitchSpelling.eDoubleSharp,
      PitchSpelling.fDoubleSharp,
      PitchSpelling.gDoubleSharp,
      PitchSpelling.aDoubleSharp,
      PitchSpelling.bDoubleSharp
    ],
  ];

  /// Creates a new [PitchSpellingMatrix].
  PitchSpellingMatrix() : super(_values);

  List<MatrixIndex> indexesOfPitchClass(PitchClass pitchClass) =>
      [for (var spelling in pitchClass.toSpellings()) indexOf(spelling)];
}

// class EqualTempermentPitchSpeller {
//   spell() {
//     //
//   }
// }

typedef PitchSpeller = List<PitchClass> Function(Set<int> pitchClassSet);

List<PitchClass> spellIntervalPitches(Set<PitchClass> notes) {}

List<PitchClass> spellChordPitches(Set<PitchClass> notes) {}

List<PitchClass> spellScalePitches(Set<PitchClass> notes) {
  var firstNote = notes.first;
  var sortedNotes = notes.toList()..sort();
  var firstNoteIndex = sortedNotes.indexOf(firstNote);
  var rotatedNotes = sortedNotes.rotateToStart(firstNoteIndex);

  // TODO: include exception for the Blues scale (bail immediately with
  // a more predictable spelling).

  var possibilities = {};
  var paths = {};

  // var root = EmptyNode<PitchClass>();

  // var tree = {
  //   PitchClass.gDoubleSharp: {
  //     PitchClass.aDoubleSharp: {},
  //     PitchClass.bNatural: {},
  //     PitchClass.cFlat: {},
  //   },
  //   PitchClass.aNatural: {
  //     PitchClass.aDoubleSharp: {},
  //     PitchClass.bNatural: {},
  //     PitchClass.cFlat: {},
  //   },
  //   PitchClass.bDoubleFlat: {
  //     PitchClass.aDoubleSharp: {},
  //     PitchClass.bNatural: {},
  //     PitchClass.cFlat: {},
  //   },
  // };

  // {{0, 5, 6}, {0, 1, 6}}
  // {0, 1}
  // {0, 6}
  // {5, 1}
  // {5, 6}
  // {6, 0}
  // {6, 1}
  // var uniqueColumns = {for (var x in a_i) for (var y in a_j) if (x != y) {x, y}};
  // n = number of pitch classes in a sequence

  // TODO: compute the paths in the matrix into a Set<Set<PitchClass>>
  // Set<Set<PitchClass>> winners = paths.fold({}, (prev, path) => {
  //   ...prev,
  //   if (path.length >= (prev.isNotEmpty ? prev.last.length : 0)) path,
  // });

  for (var i = 0, j = 1; i < rotatedNotes.length; j = i + 1, i++) {
    // PitchClassMatrix.elementAt(i, )
    PitchSpellingMatrix.columnsOf(rotatedNotes[i]);
    PitchSpellingMatrix.columnsOf(rotatedNotes[j]);
  }

  for (var note in rotatedNotes) {
    var matchingColumns = [
      for (var row in PitchClass.matrix)
        if (row.contains(note)) 1 else 0
      // row.indexOf(note)
    ];

    // var sum = matches.sum();
  }

  for (var i = 0; i < 12; i++) {
    var j = i + 1;
  }

  // TODO: use rotatedNotes.fold to access previous map?
  for (var i = 0; i < rotatedNotes.length; i++) {
    var note = rotatedNotes[i];
    var respelledNotes = note.alternateSpellings.map((pitch) => Node(pitch));

    // 1st iter: add nodes to root
    if (i == 0) root.addAll(respelledNotes);
    root.elementAt(i);
  }

  for (var note in rotatedNotes) {
    var spellingNodes = note.alternateSpellings.map((pitch) => Node(pitch));
    // 1st iter: add nodes to root
    root.addAll(spellingNodes);

    // 2nd iter: add nodes to each child of root

    // 3rd iter: add nodes to each child of the child of root

    // etc.
  }

  for (var i = 0; i < notes.length; i++) {
    for (var j = i + 1; j <= notes.length; j++) {
      // PitchClass.matrix
    }
  }

  for (var row in PitchClass.matrix) {
    for (var pitchClass in row) {
      //
    }
  }
}
