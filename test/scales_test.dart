import 'package:test/test.dart';
import 'package:prelude/src/scales.dart';
import 'package:prelude/src/pitch.dart';

void main() {
  group('Scale', () {
    test('.major creates a major scale with the given tonic', () {
      final tonic = PitchClass.cNatural;
      final scale = Scale.major(tonic);
      expect(scale, isA<MajorScale>());
      expect(scale.tonic, tonic);
    });

    test('.melodicMinor creates a melodic minor scale with the given tonic',
        () {
      final tonic = PitchClass.cNatural;
      final scale = Scale.melodicMinor(tonic);
      expect(scale, isA<MajorScale>());
      expect(scale.tonic, tonic);
    });

    test('.harmonicMinor creates a harmonic minor scale with the given tonic',
        () {
      final tonic = PitchClass.cNatural;
      final scale = Scale.harmonicMinor(tonic);
      expect(scale, isA<MajorScale>());
      expect(scale.tonic, tonic);
    });

    test('[] allows 1-indexed access to scale notes', () {
      final scale = MajorScale(PitchClass.cNatural);
      expect(scale[1], PitchClass.cNatural);
      expect(scale[2], PitchClass.dNatural);
      expect(scale[3], PitchClass.eNatural);
      expect(scale[4], PitchClass.fNatural);
      expect(scale[5], PitchClass.gNatural);
      expect(scale[6], PitchClass.aNatural);
      expect(scale[7], PitchClass.bNatural);
    });
  });

  group('MajorScale', () {
    test('is a subclass of Scale', () {
      expect(MajorScale(PitchClass.aNatural), isA<Scale>());
    });
  });

  group('MelodicMinorScale', () {
    test('is a subclass of Scale', () {
      expect(MelodicMinorScale(PitchClass.aNatural), isA<Scale>());
    });
  });

  group('HarmonicMinorScale', () {
    test('is a subclass of Scale', () {
      expect(HarmonicMinorScale(PitchClass.aNatural), isA<Scale>());
    });
  });

  group('OctatonicScale', () {
    test('is a subclass of Scale', () {
      expect(OctatonicScale(PitchClass.aNatural), isA<Scale>());
    });
  });
}
