import 'package:equatable/equatable.dart';

// TODO: should these be part of a UI library instead? We should really only
// be focused on absolute duration in clock time for the purpose of
// representing musical sound (as opposed to written notation).
enum NoteValue {
  oneHundredTwentyEighthNote,
  sixtyFourthNote,
  thirtySecondNote,
  sixteenthNote,
  quarterNote,
  halfNote,
  wholeNote,
  doubleWholeNote,
  quadrupleWholeNote,
  octupleWholeNote,
}

class Duration {
  final NoteValue length;
  final int dotCount;

  // samples?
  // sampleRate

  // TODO: is dotCount too heavily tied to a notational concept
  // that should be handled with a UI library? Can this be accounted for
  // with a multiplicative factor or another approach? If so, how does one
  // get from that to the number of dots (esp. if that factor isn't
  // constrained to allowed multiples that match with the dotted notation, like
  // 1.5x or 2x)?
  // 1 + (2^n - 1) / 2^n where n = number of dots
  const Duration(this.length, {this.dotCount = 0});

  // isDotted?
}

void main() {
  Duration(NoteValue.halfNote, dotCount: 1);
}

class Tempo extends Equatable {
  // TODO: add some constants for common tempos
  // https://en.wikipedia.org/wiki/Tempo
  // static const larghissimo = Tempo(24);
  // static const grave = Tempo(35);
  // static const largo = Tempo(50);
  // static const adagio = Tempo(70);
  // static const andante = Tempo(80);

  final int beatsPerMinuteCount;

  const Tempo(this.beatsPerMinuteCount);

  @override
  List<Object> get props => [beatsPerMinuteCount];

  @override
  bool get stringify => true;
}

// class MetronomeMark {

// }
