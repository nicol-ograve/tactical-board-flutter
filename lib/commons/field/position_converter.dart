import 'package:flutter/material.dart';

class PositionConverter {
  double _playerHalfSize;

  PositionConverter(double playerSize) : _playerHalfSize = playerSize / 2;

  Offset fieldToModel(Offset position) =>
      Offset(position.dx + _playerHalfSize, position.dy + _playerHalfSize);

  Offset modelToField(Offset position) =>
      Offset(position.dx - _playerHalfSize, position.dy - _playerHalfSize);
}
