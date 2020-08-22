@Tags(['unit'])

import 'package:test/test.dart';
import 'package:prelude/prelude.dart' show Accidental;

void main() {
  group('Accidental', () {
    test('instances with the same name are indentical', () {
      expect(Accidental.doubleFlat, same(Accidental.doubleFlat));
      expect(Accidental.flat, same(Accidental.flat));
      expect(Accidental.natural, same(Accidental.natural));
      expect(Accidental.sharp, same(Accidental.sharp));
      expect(Accidental.doubleSharp, same(Accidental.doubleSharp));
    });

    test('.name returns the text name of the accidental', () {
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

    test('.values returns a list of all the constants', () {
      const values = [
        Accidental.doubleFlat,
        Accidental.flat,
        Accidental.natural,
        Accidental.sharp,
        Accidental.doubleSharp,
      ];

      expect(Accidental.values, values);
    });

    test('.toString() returns the name of the constant', () {
      expect(Accidental.doubleFlat.toString(), 'doubleFlat');
      expect(Accidental.flat.toString(), 'flat');
      expect(Accidental.natural.toString(), 'natural');
      expect(Accidental.sharp.toString(), 'sharp');
      expect(Accidental.doubleSharp.toString(), 'doubleSharp');
    });

    test('.valueOf() returns the constant matching the string name', () {
      expect(Accidental.valueOf('doubleFlat'), Accidental.doubleFlat);
      expect(Accidental.valueOf('flat'), Accidental.flat);
      expect(Accidental.valueOf('natural'), Accidental.natural);
      expect(Accidental.valueOf('sharp'), Accidental.sharp);
      expect(Accidental.valueOf('doubleSharp'), Accidental.doubleSharp);
    });
  });
}
