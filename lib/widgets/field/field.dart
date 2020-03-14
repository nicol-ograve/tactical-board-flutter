import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tactical_board/blocs/field/field_bloc.dart';
import 'package:tactical_board/commons/field/position_converter.dart';
import 'package:tactical_board/model/field_config.dart';
import 'package:tactical_board/model/field_entity.dart';
import 'package:tactical_board/model/player.dart';
import 'package:tactical_board/widgets/field/field_items/ball_item.dart';
import 'package:tactical_board/widgets/field/field_items/player_item.dart';
import 'package:tactical_board/widgets/field/field_painter.dart';

class Field extends StatelessWidget {
  Field(
      {Key key,
      this.fieldEntities,
      this.bloc,
      this.config,
      this.ballPosition,
      this.child});

  final Widget child;
  final List<FieldEntity> fieldEntities;
  final Offset ballPosition;
  final FieldConfig config;
  final FieldBloc bloc;

  final GlobalKey _key = GlobalKey();

  final converter = PositionConverter();

  @override
  Widget build(BuildContext context) {
    final fieldEntities = this.fieldEntities != null ? this.fieldEntities : [];

    return DragTarget<String>(
        key: _key,
        onAccept: (_) {},
        onWillAccept: (_) {
          return true;
        },
        onLeave: (_) => {},
        builder: (context, candidateData, rejectedData) {
          return Stack(children: <Widget>[
            CustomPaint(
                painter: FieldPainter(config, bloc.updateFieldSize),
                child: Container()),
            ...fieldEntities.map((entity) {
              double size = entitySize(entity);
              Offset entityFieldPosition =
                  converter.modelToField(entity.position, size);
              return Positioned(
                  left: entityFieldPosition.dx,
                  top: entityFieldPosition.dy,
                  child: getFieldEntityWidget(entity,
                      (FieldEntity entity, Offset newPosition) {
                    bloc.entityMoved(
                        entity, converter.fieldToModel(newPosition, size));
                  }));
            })
          ]);
        });
  }

  double entitySize(FieldEntity entity) {
    switch (entity.type) {
      case FieldEntityType.Ball:
        return config.ballSize;
      default:
        return config.playersSize;
    }
  }

  Widget getFieldEntityWidget(
      FieldEntity entity, Function(FieldEntity, Offset) onEntityMoved) {
    if (entity.type == FieldEntityType.Player) {
      Player player = entity as Player;
      return PlayerItem(
          size: config?.playersSize,
          color: player.color,
          shirtNumber: player.shirtNumber,
          onDrag: (Offset absoluteOffset) {
            onEntityMoved(player, _getRelativeDragOffset(absoluteOffset));
          });
    } else {
      return BallItem(
          size: config?.ballSize,
          onDrag: (Offset absoluteOffset) {
            onEntityMoved(entity, _getRelativeDragOffset(absoluteOffset));
          });
    }
  }

  Offset _getFieldPosition() {
    final RenderBox box = _key.currentContext.findRenderObject();
    return box.localToGlobal(Offset.zero);
  }

  /* 
    The offset passed as parameter to the onDrag function is related absolutely to the screen's top left corner.
    This method correct the offset by returning a new one relative to the widget's top left corner.
  */
  Offset _getRelativeDragOffset(Offset absoluteOffset) {
    Offset fieldPosition = _getFieldPosition();
    return Offset(absoluteOffset.dx - fieldPosition.dx,
        absoluteOffset.dy - fieldPosition.dy);
  }
}
