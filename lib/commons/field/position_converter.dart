import 'package:flutter/material.dart';

class PositionConverter {

  PositionConverter();

  Offset fieldToModel(Offset position, double size) {
      final halfSize = size / 2;
      return Offset(position.dx + halfSize, position.dy + halfSize);
  }

  Offset modelToField(Offset position, double size) {
      final halfSize = size / 2;
      return Offset(position.dx - halfSize, position.dy - halfSize);
  }
}
