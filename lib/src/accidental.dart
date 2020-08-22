import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

part 'accidental.g.dart';

/// An accidental symbol used in the Western musical notation system.
class Accidental extends EnumClass {
  /// The double flat (𝄫) [Accidental].
  static const Accidental doubleFlat = _$doubleFlat;
  /// The flat (♭) [Accidental].
  static const Accidental flat = _$flat;
  /// The natural (♮) [Accidental].
  static const Accidental natural = _$natural;
  /// The sharp (♯) [Accidental].
  static const Accidental sharp = _$sharp;
  /// The double sharp (𝄪) [Accidental].
  static const Accidental doubleSharp = _$doubleSharp;

  const Accidental._(String name) : super(name);

  /// Returns a [BuiltSet] of all accidentals.
  static BuiltSet<Accidental> get values => _$aValues;

  /// Returns the [Accidental] that corresponds to [name].
  static Accidental valueOf(String name) => _$aValueOf(name);

  /// Returns the accidental symbol as a [String].
  String get symbol {
    final symbolMap = <Accidental, String>{
      doubleFlat: '𝄫',
      flat: '♭',
      natural: '♮',
      sharp: '♯',
      doubleSharp: '𝄪',
    };
    return symbolMap[this];
  }
}
