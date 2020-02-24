import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tactical_board/blocs/blocs_provider.dart';
import 'package:tactical_board/blocs/field_bloc.dart';
import 'package:tactical_board/commons/field/position_converter.dart';
import 'package:tactical_board/model/field_config.dart';
import 'package:tactical_board/model/player.dart';
import 'package:tactical_board/widgets/field/field_painter.dart';
import 'package:tactical_board/widgets/player_item.dart';

class Field extends StatelessWidget {
  Field({Key key, this.players, this.child, this.playerSize});

  final Widget child;
  final List<Player> players;
  final double playerSize;

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    FieldBloc fieldBloc = BlocProvider.of<FieldBloc>(context);
    return StreamBuilder(
        stream: fieldBloc.config,
        builder: (context, snapshot) =>
            buildDragTarget(snapshot.data, fieldBloc));
  }

  Widget buildDragTarget(FieldConfig config, FieldBloc fieldBloc) {
    final converter =
        PositionConverter(config != null ? config.playersSize : 0);
    final players = this.players != null ? this.players : [];
    return DragTarget<String>(
        key: _key,
        onAccept: (_) {
          print("Accepted");
        },
        onWillAccept: (_){
          print("AKD");
          return true;
        } ,
        onLeave: (_) => {},
        builder: (context, List<String> candidateData, rejectedData) {
          return Stack(children: <Widget>[
            CustomPaint(
                painter: FieldPainter(config, fieldBloc.updateFieldSize),
                child: Container()),
            ...players.map((player) {
              Offset playerFieldPosition =
                  converter.modelToField(player.position);
              return Positioned(
                  left: playerFieldPosition.dx,
                  top: playerFieldPosition.dy,
                  child: PlayerItem(
                      size: config?.playersSize,
                      color: player.color,
                      onDrag: (Offset absoluteOffset) {
                        fieldBloc.playerMoved(
                            player,
                            converter.fieldToModel(
                                _getRelativeDragOffset(absoluteOffset)));
                      }));
            })
          ]);
        });
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
