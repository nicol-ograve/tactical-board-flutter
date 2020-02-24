import 'package:flutter/material.dart';

class FieldConfig {
  FieldConfig(
      {this.margins,
      this.strokeWidth,
      this.cornerWidth,
      this.pointsSize,
      this.middleCircleSize,
      this.playersSize,
      penaltyAreaHeight})
      : penaltyAreaSize = Size(penaltyAreaHeight * 3, penaltyAreaHeight),
        penaltyY = penaltyAreaHeight / 1.5,
        keeperAreaHeight = penaltyAreaHeight / 3,
        keeperAreaWidth = penaltyAreaHeight * 1.11;

  final double margins;

  final double strokeWidth;
  final double cornerWidth;
  final double pointsSize; // Diameter for middle field and penalty disks

  final double middleCircleSize;

  final Size penaltyAreaSize;

  final double penaltyY;

  final double keeperAreaHeight;
  final double keeperAreaWidth;

  final double playersSize;
}

FieldConfig getDefaultFieldConfig() {
  return FieldConfig(
      margins: 4.0,
      strokeWidth: 2,
      cornerWidth: 20.0,
      penaltyAreaHeight: 70.0,
      middleCircleSize: 50.0,
      pointsSize: 4,
      playersSize: 40);
}

FieldConfig getFieldConfig(Size fieldSize) {
  return FieldConfig(
      margins: 4.0,
      strokeWidth: 2,
      cornerWidth: fieldSize.width / 14,
      penaltyAreaHeight: fieldSize.height / 6.36,
      middleCircleSize: fieldSize.width / 7.5,
      pointsSize: 4,
      playersSize: 80);
}
