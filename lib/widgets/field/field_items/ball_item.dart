import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tactical_board/widgets/field/field_items/field_item.dart';

class BallItem extends FieldItem {
  BallItem({Key key, this.size, this.onDrag});
  final void Function(Offset) onDrag;

  final double size;
  renderDraggedItem() {
    return BoxDecoration(
      image: new DecorationImage(
        image: new ExactAssetImage('assets/images/ball.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  renderNormalItem() {
    return new BoxDecoration(
      image: new DecorationImage(
        image: new ExactAssetImage('assets/images/ball.png'),
        fit: BoxFit.cover,
      ),
    );
  }
}
