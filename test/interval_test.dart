import 'package:test/test.dart';
import 'package:prelude/src/interval.dart';
import 'package:prelude/src/pitch.dart';

void main() {
  group('UnorderedPitchClassInterval', () {
    test(
        '.between() returns the interval between'
        ' the two given pitch classes', () {
      expect(
          UnorderedPitchClassInterval.between(
              PitchClass.cNatural, PitchClass.cNatural),
          UnorderedPitchClassInterval(0));
      expect(
          UnorderedPitchClassInterval.between(
              PitchClass.cNatural, PitchClass.cSharp),
          UnorderedPitchClassInterval(1));
      expect(
          UnorderedPitchClassInterval.between(
              PitchClass.cNatural, PitchClass.dFlat),
          UnorderedPitchClassInterval(1));
      expect(
          UnorderedPitchClassInterval.between(
              PitchClass.cNatural, PitchClass.cNatural),
          UnorderedPitchClassInterval(0));
    });
  });

  group('Interval', () {
    test('.between() returns the interval between two pitch classes', () {
      const cFlat = PitchClass.cFlat;
      const cNatural = PitchClass.cNatural;
      const cSharp = PitchClass.cSharp;
      const cDoubleSharp = PitchClass.cDoubleSharp;

      const dDoubleFlat = PitchClass.dDoubleFlat;
      const dFlat = PitchClass.dFlat;
      const dNatural = PitchClass.dNatural;
      const dSharp = PitchClass.dSharp;
      const dDoubleSharp = PitchClass.dDoubleSharp;

      const eDoubleFlat = PitchClass.eDoubleFlat;
      const eFlat = PitchClass.eFlat;
      const eNatural = PitchClass.eNatural;
      const eSharp = PitchClass.eSharp;

      const fDoubleFlat = PitchClass.fDoubleFlat;
      const fFlat = PitchClass.fFlat;
      const fNatural = PitchClass.fNatural;
      const fSharp = PitchClass.fSharp;
      const fDoubleSharp = PitchClass.fDoubleSharp;

      const gDoubleFlat = PitchClass.gDoubleFlat;
      const gFlat = PitchClass.gFlat;
      const gNatural = PitchClass.gNatural;
      const gSharp = PitchClass.gSharp;
      const gDoubleSharp = PitchClass.gDoubleSharp;

      const aDoubleFlat = PitchClass.aDoubleFlat;
      const aFlat = PitchClass.aFlat;
      const aNatural = PitchClass.aNatural;
      const aSharp = PitchClass.aSharp;
      const aDoubleSharp = PitchClass.aDoubleSharp;

      const bDoubleFlat = PitchClass.bDoubleFlat;
      const bFlat = PitchClass.bFlat;
      const bNatural = PitchClass.bNatural;
      const bSharp = PitchClass.bSharp;
      const bDoubleSharp = PitchClass.bDoubleSharp;

      expect(Interval.between(cNatural, cFlat), Interval.diminishedUnison);
      expect(Interval.between(cNatural, cNatural), Interval.unison);
      expect(Interval.between(cNatural, cSharp), Interval.augmentedUnison);
      expect(Interval.between(cNatural, cDoubleSharp),
          Interval.doublyAugmentedUnison);

      expect(Interval.between(cNatural, dDoubleFlat), Interval.diminished2nd);
      expect(Interval.between(cNatural, dFlat), Interval.minor2nd);
      expect(Interval.between(cNatural, dNatural), Interval.major2nd);
      expect(Interval.between(cNatural, dSharp), Interval.augmented2nd);
      expect(Interval.between(cNatural, dDoubleSharp),
          Interval.doublyAugmented2nd);

      expect(Interval.between(cNatural, eDoubleFlat), Interval.diminished3rd);
      expect(Interval.between(cNatural, eFlat), Interval.minor3rd);
      expect(Interval.between(cNatural, eNatural), Interval.major3rd);
      expect(Interval.between(cNatural, eSharp), Interval.augmented3rd);

      expect(Interval.between(cNatural, fDoubleFlat),
          Interval.doublyDiminished4th);
      expect(Interval.between(cNatural, fFlat), Interval.diminished4th);
      expect(Interval.between(cNatural, fNatural), Interval.perfect4th);
      expect(Interval.between(cNatural, fSharp), Interval.augmented4th);
      expect(Interval.between(cNatural, fDoubleSharp),
          Interval.doublyAugmented4th);

      expect(Interval.between(cNatural, gDoubleFlat),
          Interval.doublyDiminished5th);
      expect(Interval.between(cNatural, gFlat), Interval.diminished5th);
      expect(Interval.between(cNatural, gNatural), Interval.perfect5th);
      expect(Interval.between(cNatural, gSharp), Interval.augmented5th);
      expect(Interval.between(cNatural, gDoubleSharp),
          Interval.doublyAugmented5th);

      expect(Interval.between(cNatural, aDoubleFlat), Interval.diminished6th);
      expect(Interval.between(cNatural, aFlat), Interval.minor6th);
      expect(Interval.between(cNatural, aNatural), Interval.major6th);
      expect(Interval.between(cNatural, aSharp), Interval.augmented6th);
      expect(Interval.between(cNatural, aDoubleSharp),
          Interval.doublyAugmented6th);

      expect(Interval.between(cNatural, bDoubleFlat), Interval.diminished7th);
      expect(Interval.between(cNatural, bFlat), Interval.minor7th);
      expect(Interval.between(cNatural, bNatural), Interval.major7th);
      expect(Interval.between(cNatural, bSharp), Interval.augmented7th);
      expect(Interval.between(cNatural, bDoubleSharp),
          Interval.doublyAugmented7th);
    });
  });
}
