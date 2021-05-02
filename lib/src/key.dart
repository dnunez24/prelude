import 'pitch.dart';

// TODO: Is this necesary or should Scales/Modes represent keys because they're
// so closely linked together (but the scale construct is more flexible).
// On second thought, maybe this is necessary for understanding which enharmonic
// notes must be used for a given scale.
// e.g. we wouldn't use Cb in the key of C but we would in the key of Gb.
// how do we map the association between scales and keys?
abstract class Key {
  // final List<PitchClass> pitchClasses;
  // MajorScale.fromStartingPitchClass(PitchClass.cNatural)
  static const Set<PitchClass> cMajor = {
    PitchClass.cNatural,
    PitchClass.dNatural,
    PitchClass.eNatural,
    PitchClass.fNatural,
    PitchClass.gNatural,
    PitchClass.aNatural,
    PitchClass.bNatural,
  };

  static const Set<PitchClass> cMinor = {
    PitchClass.cNatural,
    PitchClass.dNatural,
    PitchClass.eFlat,
    PitchClass.fNatural,
    PitchClass.gNatural,
    PitchClass.aFlat,
    PitchClass.bFlat,
  };

  List<PitchClass> _notes;

  factory Key(String name) => Key._();

  // TODO: not sure why I thought this was necessary. Makes sense for scales,
  // not sure about keys.
  // PitchClass operator [](int index) => _notes.elementAt(index);

  // valueOf('gFlat') => PitchClass('gFlat')
}

///
/// ```
/// var key = MajorKey.of(PitchClass.dSharp);
/// assert(key.notes == []); // returns notes for Eb major scale (enharmonic)
/// ```
class MajorKey {
  // allowedTonicPitches => [G, D, A, E, B, F#, C#, ]
  MajorKey.of(PichtClass tonic) {
    // TODO: calculate the PitchClasses that belong in this key based on the
    // tonic and set them to the notes of this key (with proper enharmonic
    // values).
  }
}

class MinorKey {
  // for each scale degree
  // count the number of semitones away from the starting pitch class to get the pitch class of the next note
  // get the interval for that number of semitones
  // get the pitch class that is that many
  // is key sharp or flat? if sharp, enharmonically spell any flat pitch classes
  // if flat enharmonicaly spell any sharp pitch classes
}

// CMajorKey()
class CMajorKey {
  static final List<PitchClass> _notes = List.unmodifiable([
    PitchClass.cNatural,
    PitchClass.dNatural,
    PitchClass.eNatural,
    PitchClass.fNatural,
    PitchClass.gNatural,
    PitchClass.aNatural,
    PitchClass.bNatural,
  ]);
}

class DFlatMajorKey {
  // static const relativeMinor = 'Bb minor'
}

class DMinorKey {}

/// ```
/// var gSharpKeySignature = KeySignature([
///   KeySignature.sharp,
///   KeySignature.sharp,
///   KeySignature.sharp,
///   KeySignature.sharp,
///   KeySignature.sharp,
///   KeySignature.sharp,
///   KeySignature.doubleSharp,
/// ]);
/// ```
class KeySignature {
  static const eFlatMajor = KeySignature([
    //
  ]);
  final List<Accidental> accidentals;

  const KeySignature(this.accidentals);
}
