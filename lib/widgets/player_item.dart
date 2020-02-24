import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayerItem extends StatelessWidget {
  PlayerItem({Key key, this.size, this.color, this.onDrag});
  final void Function(Offset) onDrag;

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    var child = Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: this.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1)));
    return Draggable<String>(
      child: child,
      childWhenDragging: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              color: this.color.withAlpha(128), shape: BoxShape.circle)),
      feedback: child,
      onDragStarted: () {},
      onDragCompleted: () { },
      onDragEnd: (DraggableDetails details) {
        if (details.wasAccepted && this.onDrag != null) 
        this.onDrag(details.offset);
      },
      onDraggableCanceled: (velocity, offset) {},
    );
  }
}
