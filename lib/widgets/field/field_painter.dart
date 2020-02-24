import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tactical_board/model/field_config.dart';

class FieldPainter extends CustomPainter {
  FieldPainter(this.config, this.onFieldSize);

  FieldConfig config;
  final Paint painter = new Paint();

  final Function(Size fieldTotalSize, Rect fieldRect) onFieldSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (config == null) config = getDefaultFieldConfig();

    painter.color = Colors.green[900];
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), painter);

    painter.color = Colors.white;
    painter.style = PaintingStyle.stroke;
    painter.strokeWidth = config.strokeWidth;

    // FIELD
    final Rect field = Rect.fromLTRB(config.margins, config.margins,
        size.width - config.margins, size.height - config.margins);

    // After having calculated field real area, emit the updated values
    onFieldSize(size, field);

    drawBorders(canvas, field);
    drawMidline(canvas, field);
    drawCorners(canvas, field);
    drawPenaltyArea(canvas, field);
  }

  void drawBorders(Canvas canvas, Rect field) {
    Path path = new Path();
    path.addRect(field);
    canvas.drawPath(path, painter);
  }

  void drawMidline(Canvas canvas, Rect field) {
    canvas.drawLine(field.centerLeft, field.centerRight, painter);
    canvas.drawCircle(field.center, config.middleCircleSize, painter);
    painter.style = PaintingStyle.fill;
    canvas.drawCircle(field.center, config.pointsSize, painter);
  }

  void drawCorners(Canvas canvas, Rect field) {
    painter.style = PaintingStyle.stroke;
    canvas.drawArc(
        Rect.fromCenter(
            center: field.topLeft,
            width: config.cornerWidth,
            height: config.cornerWidth),
        pi / 2,
        -pi / 2,
        false,
        painter);
    canvas.drawArc(
        Rect.fromCenter(
            center: field.topRight,
            width: config.cornerWidth,
            height: config.cornerWidth),
        pi,
        -pi / 2,
        false,
        painter);
    canvas.drawArc(
        Rect.fromCenter(
            center: field.bottomLeft,
            width: config.cornerWidth,
            height: config.cornerWidth),
        0,
        -pi / 2,
        false,
        painter);
    canvas.drawArc(
        Rect.fromCenter(
            center: field.bottomRight,
            width: config.cornerWidth,
            height: config.cornerWidth),
        -pi / 2,
        -pi / 2,
        false,
        painter);
  }

  void drawPenaltyArea(Canvas canvas, Rect field) {
    drawAreas(canvas, field, config.penaltyAreaSize.width,
        config.penaltyAreaSize.height);
    drawAreas(canvas, field, config.keeperAreaWidth,
        config.keeperAreaHeight); // Keeper area
    drawPenalties(canvas, field);
  }

  void drawAreas(Canvas canvas, Rect field, double width, double height) {
    final halfWidth = width / 2;
    Path path = new Path();
    path.moveTo(field.center.dx - halfWidth, field.top);
    path.lineTo(field.center.dx - halfWidth, field.top + height);
    path.lineTo(field.center.dx + halfWidth, field.top + height);
    path.lineTo(field.center.dx + halfWidth, field.top);
    canvas.drawPath(path, painter);

    path = new Path();
    path.moveTo(field.center.dx - halfWidth, field.bottom);
    path.lineTo(field.center.dx - halfWidth, field.bottom - height);
    path.lineTo(field.center.dx + halfWidth, field.bottom - height);
    path.lineTo(field.center.dx + halfWidth, field.bottom);
    canvas.drawPath(path, painter);
  }

  void drawPenalties(Canvas canvas, Rect field) {
    // Penalty circles
    painter.style = PaintingStyle.fill;

    final topPenalty = new Offset(field.center.dx, field.top + config.penaltyY);
    final bottomPenalty =
        new Offset(field.center.dx, field.bottom - config.penaltyY);
    canvas.drawCircle(topPenalty, config.pointsSize, painter);
    canvas.drawCircle(bottomPenalty, config.pointsSize, painter);

    painter.style = PaintingStyle.stroke;

    // Penalty arcs
    final angle = findPenaltyCircleAngle();
    final topArcRect = Rect.fromLTRB(
        topPenalty.dx - config.middleCircleSize,
        topPenalty.dy - config.middleCircleSize,
        topPenalty.dx + config.middleCircleSize,
        topPenalty.dy + config.middleCircleSize);
    canvas.drawArc(topArcRect, angle, pi - angle * 2, false, painter);

    final bottomArcRect = Rect.fromLTRB(
        bottomPenalty.dx - config.middleCircleSize,
        bottomPenalty.dy - config.middleCircleSize,
        bottomPenalty.dx + config.middleCircleSize,
        bottomPenalty.dy + config.middleCircleSize);
    canvas.drawArc(bottomArcRect, pi + angle, pi - angle * 2, false, painter);
  }

  double findPenaltyCircleAngle() {
    final height = config.penaltyAreaSize.height - config.penaltyY;
    return asin(height / config.middleCircleSize);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
