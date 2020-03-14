import 'package:flutter/rendering.dart';
import 'package:tactical_board/model/field_entity.dart';

class Player extends FieldEntity {
  Player(
      {this.id, this.teamId, position, this.color, this.shirtNumber, this.name})
      : super(position: position, type: FieldEntityType.Player);

  int id;
  int teamId;
  int shirtNumber;
  String name;
  Color color;

  @override
  Map<String, dynamic> toMap() {
    final result = super.toMap();

    result['id'] = id;
    result['teamId'] = teamId;
    result['shirtNumber'] = shirtNumber;
    result['name'] = name;
    result['color'] = color.value;

    return result;
  }

  static Player fromMap(Map<String, dynamic> map) {
    return Player(
        id: map['id'],
        teamId: map['teamId'],
        shirtNumber: map['shirtNumber'],
        position: Offset(map['positionX'], map['positionY']),
        name: map['name'],
        color: Color(map['color']));
  }
}
