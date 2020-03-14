import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tactical_board/widgets/field/field_items/field_item.dart';

class PlayerItem extends FieldItem {
  PlayerItem({Key key, this.size, this.color, this.onDrag, this.shirtNumber})
      : textSize = size * 0.8;
  final void Function(Offset) onDrag;

  final Color color;
  final double size;
  final double textSize;
  final int shirtNumber;

  renderDraggedItem() {
    return BoxDecoration(
        color: this.color.withAlpha(128), shape: BoxShape.circle);
  }

  renderNormalItem() {
    return BoxDecoration(
        color: this.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1));
  }

  @override
  Widget content({bool isDragged = false}) => Center(
          child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            shirtNumber.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDragged ? textSize : textSize - 5,
              decoration: TextDecoration.none,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.white,
            ),
          ),
          // Solid text as fill.
          Text(
            shirtNumber.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: isDragged ? textSize : textSize - 5,
              color: Colors.black,
            ),
          ),
        ],
      ));
}
