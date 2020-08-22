// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accidental.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Accidental _$doubleFlat = const Accidental._('doubleFlat');
const Accidental _$flat = const Accidental._('flat');
const Accidental _$natural = const Accidental._('natural');
const Accidental _$sharp = const Accidental._('sharp');
const Accidental _$doubleSharp = const Accidental._('doubleSharp');

Accidental _$aValueOf(String name) {
  switch (name) {
    case 'doubleFlat':
      return _$doubleFlat;
    case 'flat':
      return _$flat;
    case 'natural':
      return _$natural;
    case 'sharp':
      return _$sharp;
    case 'doubleSharp':
      return _$doubleSharp;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<Accidental> _$aValues =
    new BuiltSet<Accidental>(const <Accidental>[
  _$doubleFlat,
  _$flat,
  _$natural,
  _$sharp,
  _$doubleSharp,
]);

Serializer<Accidental> _$accidentalSerializer = new _$AccidentalSerializer();

class _$AccidentalSerializer implements PrimitiveSerializer<Accidental> {
  @override
  final Iterable<Type> types = const <Type>[Accidental];
  @override
  final String wireName = 'Accidental';

  @override
  Object serialize(Serializers serializers, Accidental object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  Accidental deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Accidental.valueOf(serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
