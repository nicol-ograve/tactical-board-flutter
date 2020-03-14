import 'package:flutter/material.dart';
import 'package:tactical_board/model/player.dart';

enum FieldEntityType { Player, Ball }

class FieldEntity {
  FieldEntity({@required this.position, @required this.type});
  Offset position;
  FieldEntityType type;

  Map<String, dynamic> toMap() {
    return {
      'type': type.index,
      'positionX': position.dx,
      'positionY': position.dy
    };
  }

  static List<FieldEntity> fromMap(List<dynamic> items) {
    return items.map((map) {
      final typeIndex = map['type'] as int;
      if (typeIndex == FieldEntityType.Player.index) {
        return Player.fromMap(map);
      } else {
        return FieldEntity(
            position: Offset(map['positionX'], map['positionY']),
            type: FieldEntityType.values[typeIndex]);
      }
    }).toList();
  }
}
