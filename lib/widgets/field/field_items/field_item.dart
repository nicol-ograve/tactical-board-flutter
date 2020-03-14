import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class FieldItem extends StatelessWidget {
  FieldItem({Key key, this.size, this.onDrag});
  final void Function(Offset) onDrag;

  final double size;

  @override
  Widget build(BuildContext context) {
    var child = Container(
        height: size,
        width: size,
        decoration: renderNormalItem(),
        child: content());
    return Draggable<String>(
      child: child,
      childWhenDragging: Container(
          height: size,
          width: size,
          decoration: renderDraggedItem()),
      feedback: Container(
        height: size,
        width: size,
        child: content(isDragged: true),
        decoration: renderNormalItem()),
      onDragStarted: () {
      },
      onDragCompleted: () {},
      onDragEnd: (DraggableDetails details) {
        if (details.wasAccepted && this.onDrag != null)
          this.onDrag(details.offset);
      },
      onDraggableCanceled: (velocity, offset) {},
    );
  }

  Decoration renderNormalItem();
  Decoration renderDraggedItem();
  Widget content({bool isDragged = false}) {
    return null;
  }
}
