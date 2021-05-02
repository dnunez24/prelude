import 'package:test/test.dart';
import 'package:prelude/src/pitch.dart';
import 'package:prelude/src/pitch_spelling.dart';

@Tags(['unit'])
void main() {
  group('Accidental', () {
    test('instances with the same name are indentical', () {
      expect(Accidental.doubleFlat, same(Accidental.doubleFlat));
      expect(Accidental.flat, same(Accidental.flat));
      expect(Accidental.natural, same(Accidental.natural));
      expect(Accidental.sharp, same(Accidental.sharp));
      expect(Accidental.doubleSharp, same(Accidental.doubleSharp));
    });

    test('.name returns the accidental name as text', () {
      expect(Accidental.doubleFlat.name, 'doubleFlat');
      expect(Accidental.flat.name, 'flat');
      expect(Accidental.natural.name, 'natural');
      expect(Accidental.sharp.name, 'sharp');
      expect(Accidental.doubleSharp.name, 'doubleSharp');
    });

    test('.symbol returns the accidental symbol as text', () {
      expect(Accidental.doubleFlat.symbol, '𝄫');
      expect(Accidental.flat.symbol, '♭');
      expect(Accidental.natural.symbol, '♮');
      expect(Accidental.sharp.symbol, '♯');
      expect(Accidental.doubleSharp.symbol, '𝄪');
    });

    test('.values returns a set of all the available accidentals', () {
      final values = {
        Accidental.doubleFlat,
        Accidental.flat,
        Accidental.natural,
        Accidental.sharp,
        Accidental.doubleSharp,
      };

      expect(Accidental.values, values);
    });

    test('.toString() returns a string representation of the accidental', () {
      expect(Accidental.doubleFlat.toString(), 'Accidental(doubleFlat)');
      expect(Accidental.flat.toString(), 'Accidental(flat)');
      expect(Accidental.natural.toString(), 'Accidental(natural)');
      expect(Accidental.sharp.toString(), 'Accidental(sharp)');
      expect(Accidental.doubleSharp.toString(), 'Accidental(doubleSharp)');
    });

    test('.valueOf() returns the accidental matching the string name', () {
      expect(Accidental.valueOf('doubleFlat'), Accidental.doubleFlat);
      expect(Accidental.valueOf('flat'), Accidental.flat);
      expect(Accidental.valueOf('natural'), Accidental.natural);
      expect(Accidental.valueOf('sharp'), Accidental.sharp);
      expect(Accidental.valueOf('doubleSharp'), Accidental.doubleSharp);
    });

    test('.valueOf() throws an error if no matching value exists', () {
      expect(() => Accidental.valueOf('unknown'), throwsArgumentError);
    });
  });

  group('Frequency', () {
    test(
        '+ operator returns a new Frequency'
        ' whose value is the sum of both', () {
      expect(const Frequency(100.0) + const Frequency(100.0),
          const Frequency(200.0));
      expect(Frequency(100.0) + Frequency(0.0), Frequency(100.0));
      expect(Frequency(0.0) + Frequency(0.0), Frequency(0.0));
      expect(() => Frequency(10000.0) + Frequency(30000.0),
          throwsA(isA<AssertionError>()));
      expect(() => Frequency(10000.0) + Frequency(-20000.0),
          throwsA(isA<AssertionError>()));
    });

    test(
        '- operator returns a new Frequency'
        ' whose value is the difference of both', () {
      expect(Frequency(200.0) - Frequency(100.0), Frequency(100.0));
      expect(Frequency(100.0) - Frequency(0.0), Frequency(100.0));
      expect(Frequency(100.0) - Frequency(100.0), Frequency(0.0));
      expect(Frequency(0.0) - Frequency(0.0), Frequency(0.0));
      expect(() => Frequency(100.0) - Frequency(200.0), throwsRangeError);
    });

    test(
        '* operator returns a new Frequency whose value is'
        ' the product of this Frequency and the given number', () {
      expect(Frequency(100.0) * Frequency(15.0), Frequency(1500.0));
      expect(Frequency(100.0) * Frequency(0.0), Frequency(0.0));
      expect(Frequency(0.0) * Frequency(10.0), Frequency(0.0));
      expect(() => Frequency(100.0) * Frequency(-1.0),
          throwsA(isA<AssertionError>()));
    });

    test(
        '- operator returns a new Frequency whose value is'
        ' the quotient of this Frequency and the given number', () {
      expect(Frequency(100.0) / Frequency(1.0), Frequency(100.0));
      expect(Frequency(1000.0) / Frequency(50.0), Frequency(20.0));
      expect(Frequency(0.0) / Frequency(10.0), Frequency(0.0));
      expect(() => Frequency(100.0) / Frequency(0.0), throwsRangeError);
      expect(() => Frequency(100.0) / Frequency(-1.0),
          throwsA(isA<AssertionError>()));
    });

    test(
        '.fromNoteNumber creates a new Frequency'
        ' from the given note number', () {
      expect(Frequency.fromMidiNote(MidiNote(69)), Frequency(440.0));
      // expect(Frequency.fromMidiNote(MidiNote(60)), Frequency());
      // TODO: test difference when providing custom tuning freq
    });
  });

  group('NoteName', () {});

  group('Octave', () {
    test('instances with the same number are identical', () {
      expect(const Octave(3), same(const Octave(3)));
    });
  });

  group('Pitch', () {
    test('default constructor initializes pitch properties', () {
      const pitchClass = PitchClass.cNatural;
      const octave = Octave(4);
      var pitch = Pitch(pitchClass, octave);

      expect(pitch.pitchClass, pitchClass);
      expect(pitch.octave, octave);
      expect(
          pitch.frequency, Frequency.fromPitchAttributes(pitchClass, octave));
      expect(pitch.cents, 0);
    });

    test('.fromFrequency() creates a pitch from the given Frequency', () {
      var freq = Frequency(440.0);
      var pitch = Pitch.fromFrequency(freq);

      expect(pitch.pitchClass, PitchClass.aNatural);
    });

    test('.noteName', () {});

    test('.accidental', () {});

    test('.cents', () {});

    test('.toMidiNote()', () {
      // returns MIDI Note (with note number and tuning)
    });

    test('.toPitchClass() returns the PitchClass of this Pitch', () {
      var notes = [
        {'name': NoteName.C, 'accidental': Accidental.doubleFlat},
        {'name': NoteName.C, 'accidental': Accidental.flat},
        {'name': NoteName.C, 'accidental': Accidental.natural},
        {'name': NoteName.C, 'accidental': Accidental.sharp},
        {'name': NoteName.C, 'accidental': Accidental.doubleSharp},
        {'name': NoteName.D, 'accidental': Accidental.doubleFlat},
        {'name': NoteName.D, 'accidental': Accidental.flat},
        {'name': NoteName.D, 'accidental': Accidental.natural},
        {'name': NoteName.D, 'accidental': Accidental.sharp},
        {'name': NoteName.D, 'accidental': Accidental.doubleSharp},
        {'name': NoteName.E, 'accidental': Accidental.doubleFlat},
        {'name': NoteName.E, 'accidental': Accidental.flat},
        {'name': NoteName.E, 'accidental': Accidental.natural},
        {'name': NoteName.E, 'accidental': Accidental.sharp},
        {'name': NoteName.E, 'accidental': Accidental.doubleSharp},
        {'name': NoteName.F, 'accidental': Accidental.doubleFlat},
        {'name': NoteName.F, 'accidental': Accidental.flat},
        {'name': NoteName.F, 'accidental': Accidental.natural},
        {'name': NoteName.F, 'accidental': Accidental.sharp},
        {'name': NoteName.F, 'accidental': Accidental.doubleSharp},
        {'name': NoteName.G, 'accidental': Accidental.doubleFlat},
        {'name': NoteName.G, 'accidental': Accidental.flat},
        {'name': NoteName.G, 'accidental': Accidental.natural},
        {'name': NoteName.G, 'accidental': Accidental.sharp},
        {'name': NoteName.G, 'accidental': Accidental.doubleSharp},
        {'name': NoteName.A, 'accidental': Accidental.doubleFlat},
        {'name': NoteName.A, 'accidental': Accidental.flat},
        {'name': NoteName.A, 'accidental': Accidental.natural},
        {'name': NoteName.A, 'accidental': Accidental.sharp},
        {'name': NoteName.A, 'accidental': Accidental.doubleSharp},
        {'name': NoteName.B, 'accidental': Accidental.doubleFlat},
        {'name': NoteName.B, 'accidental': Accidental.flat},
        {'name': NoteName.B, 'accidental': Accidental.natural},
        {'name': NoteName.B, 'accidental': Accidental.sharp},
        {'name': NoteName.B, 'accidental': Accidental.doubleSharp},
      ];

      for (var note in notes) {
        expect(Pitch(note['name'], note['accidental']).toPitchClass(),
            PitchClass(note['name'], note['accidental']));
      }
    });
  });

  group('PitchClass', () {
    test('.fromNote()', () {
      expect(PitchClass(NoteName.C, Accidental.natural).toInt(), 0);
    });
  });
}
