import 'package:test/test.dart';
import 'package:prelude/src/pitch.dart';

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
    test('+ operator returns a new Frequency'
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

    test('- operator returns a new Frequency'
        ' whose value is the difference of both', () {
      expect(Frequency(200.0) - Frequency(100.0), Frequency(100.0));
      expect(Frequency(100.0) - Frequency(0.0), Frequency(100.0));
      expect(Frequency(100.0) - Frequency(100.0), Frequency(0.0));
      expect(Frequency(0.0) - Frequency(0.0), Frequency(0.0));
      expect(() => Frequency(100.0) - Frequency(200.0), throwsRangeError);
    });

    test('* operator returns a new Frequency whose value is'
        ' the product of this Frequency and the given number', () {
      expect(Frequency(100.0) * Frequency(15.0), Frequency(1500.0));
      expect(Frequency(100.0) * Frequency(0.0), Frequency(0.0));
      expect(Frequency(0.0) * Frequency(10.0), Frequency(0.0));
      expect(() => Frequency(100.0) * Frequency(-1.0),
          throwsA(isA<AssertionError>()));
    });

    test('- operator returns a new Frequency whose value is'
        ' the quotient of this Frequency and the given number', () {
      expect(Frequency(100.0) / Frequency(1.0), Frequency(100.0));
      expect(Frequency(1000.0) / Frequency(50.0), Frequency(20.0));
      expect(Frequency(0.0) / Frequency(10.0), Frequency(0.0));
      expect(() => Frequency(100.0) / Frequency(0.0), throwsRangeError);
      expect(() => Frequency(100.0) / Frequency(-1.0),
          throwsA(isA<AssertionError>()));
    });

    test('.fromNoteNumber creates a new Frequency'
        ' from the given note number', () {
      expect(Frequency.fromNoteNumber(NoteNumber(69)), Frequency(440.0));
    });
  });

  group('NoteName', () {});

  group('Octave', () {
    test('instances with the same number are identical', () {
      expect(const Octave(3), same(const Octave(3)));
    });
  });

  group('Pitch', () {});

  group('PitchClass', () {});
}
