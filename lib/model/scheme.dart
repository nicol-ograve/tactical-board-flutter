import 'package:flutter/material.dart';
import 'package:tactical_board/model/field_entity.dart';

class SchemeSnapshot {
  SchemeSnapshot({@required this.itemsPositions});
  final List<Offset> itemsPositions;

  Map<String, dynamic> toMap() {
    return {
      'positions': itemsPositions.map((e) => {'dx': e.dx, 'dy': e.dy})
    };
  }

  static SchemeSnapshot fromMap(Map<String, dynamic> items) {
    return SchemeSnapshot(itemsPositions: _offsetsFromMap(items['positions']));
  }

  static List<Offset> _offsetsFromMap(List<dynamic> items) {
    return items.map((e) {
      return Offset(e['dx'], e['dy']);
    }).toList();
  }
}

class Scheme {
  Scheme({@required this.friendlyName, @required this.items, snapshots})
      : this.snapshots = snapshots != null ? snapshots : List<SchemeSnapshot>();

  int id;
  String friendlyName;
  List<FieldEntity> items;
  List<SchemeSnapshot> snapshots;

  void saveSnapshot() {
    snapshots.add(SchemeSnapshot(
        itemsPositions: this.items.map((item) => item.position).toList()));
  }

  Map<String, dynamic> toMap() {
    return {
      'friendlyName': friendlyName,
      'items': items.map((e) => e.toMap()),
      'snapshots': snapshots.map((e) => e.toMap())
    };
  }

  static Scheme fromMap(Map<String, dynamic> map) {
    return Scheme(
        friendlyName: map['friendlyName'],
        items: FieldEntity.fromMap(map['items']),
        snapshots: _snapshotsFromMap(map['snapshots']));
  }

  static List<SchemeSnapshot> _snapshotsFromMap(List<dynamic> items) {
    return items.map((map) {
      return SchemeSnapshot.fromMap(map);
    }).toList();
  }
}
