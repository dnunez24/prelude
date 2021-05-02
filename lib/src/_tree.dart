import 'package:collection/collection.dart';

class Node<T> {
  final T value;
  final Set<Node<T>> children;

  Node(this.value, [Set<Node<T>> children])
      : children = children ?? {},
        assert(value != null);

  void addAll(Iterable<Node<T>> nodes) => children.addAll(nodes);

  bool get isLeaf => hasChildren;

  bool get hasChildren => children.isEmpty;

//   String toString() {
//     var formattedChildren = children.fold('', (previous, node) => '$previous\n  -- $node');
//     return 'Node($value)$formattedChildren';
//   }
}

class Tree<T> extends Node<T> {
  Tree([Set<Node<T>> children]) : super(null, children);

  void insert(Iterable<T> iterable, {bool Function(T) reject}) {
    var filtered = reject != null ? iterable.skipWhile(reject) : iterable;
    var nodes = _iterableToNodes(filtered);
    _addNodes(this, nodes);
  }

  // TODO: implement search? (breadth first vs depth first?)

  void _addNodes(Node<T> parent, Iterable<Node<T>> nodes) {
    if (parent.isLeaf) {
      return parent.addAll(nodes);
    }

    for (var child in parent.children) {
      _addNodes(child, nodes);
    }
  }

  Iterable<Node<T>> _iterableToNodes(Iterable<T> iterable) =>
      iterable.map((T child) => Node(child, {}));
}

// abstract class NodeBase<T> extends DelegatingList<NodeBase<T>> {
//   final T value;
//   final List<NodeBase<T>> _children;

//   NodeBase(value, children) : this._(value, []);

//   NodeBase._(this.value, this._children) : super(_children);

//   @override
//   void add(NodeBase<T> value) {
//     if (value is EmptyNode) {
//       throw ArgumentError.value(value, 'value', 'cannot be an empty node');
//     }
//     super.add(value);
//   }

//   @override
//   void addAll(Iterable<NodeBase<T>> iterable) {
//     if (iterable.any((element) => element is EmptyNode)) {
//       throw ArgumentError.value(
//           iterable, 'iterable', 'cannot contain any empty nodes');
//     }
//     super.addAll(iterable);
//   }

//   // String toString() => 'Node($value)\n\t${children}';
// }
