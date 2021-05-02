import 'package:test/test.dart';
import 'package:prelude/src/_tree.dart';

void main() {
  group('EmptyNode', () {
    test('implements the List interface', () {
      expect(EmptyNode(), isA<List>());
    });

    test('can be initialized without a value', () {
      expect(EmptyNode(), isNot(throwsException));
    });

    test('allows adding elements of a specified type', () {
      var parent = EmptyNode<String>();
      var child = Node('A');

      parent.add(child);

      expect(parent, contains(child));
    });

    test('with dynamic type allows adding child nodes with any type', () {
      var parent = EmptyNode();
      var child1 = Node(12);
      var child2 = Node('X');

      parent.add(child1);
      parent.add(child2);

      expect(parent, containsAll([child1, child2]));
    });
  });

  group('Node', () {
    test('implements the List interface', () {
      expect(Node('A'), isA<List>());
    });

    test('cannot be initialized with a null value', () {
      expect(() => Node(null), throwsA(TypeMatcher<AssertionError>()));
    });

    test('does not allow adding empty nodes as children', () {
      var node = Node('Test');
      var empty = EmptyNode<String>();

      expect(() => node.add(empty), throwsArgumentError);
      expect(() => node.addAll([empty]), throwsArgumentError);
      expect(() => node.addAll([node, empty]), throwsArgumentError);
    });
  });
}
