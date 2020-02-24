import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tactical_board/blocs/blocs_provider.dart';
import 'package:tactical_board/model/field_config.dart';
import 'package:tactical_board/model/formation.dart';
import 'package:tactical_board/model/player.dart';
import 'package:tactical_board/utils/color_utils.dart';

class FieldTeam {
  FieldTeam({this.id, this.playersColor, this.keeperColor});

  final int id;
  final Color playersColor;
  final Color keeperColor;
}

class FieldSnapshot {
  List<Player> homePlayers;
  List<Player> awayPlayers;
  Offset ballPosition;
}

class FieldBloc extends BlocBase {
  FieldBloc() {
    _config.add(getDefaultFieldConfig());
  }

  int _nextId = 1;

  final _homeTeam = FieldTeam(
      id: 1,
      playersColor: colorFromHex("#1F9A81"),
      keeperColor: Colors.grey[400]);
  final _awayTeam = FieldTeam(
      id: 2, playersColor: Colors.red, keeperColor: Colors.yellow[300]);

  final _controller = StreamController<List<Player>>();
  Stream<List<Player>> get players => _controller.stream;

  final _config = StreamController<FieldConfig>();
  Stream<FieldConfig> get config => _config.stream;

  Size _fieldSize;
  Rect _fieldRect;

  updateFieldSize(Size size, Rect fieldRect) {
    if (_isFieldSizeChanged(size)) {
      _fieldSize = size;
      _fieldRect = fieldRect;

      debugPrint(fieldRect.toString());

      var newConfig = getFieldConfig(size);
      _config.add(newConfig);

      clearField();

      List<Player> players = List();
      players.addAll(applyFormation(_homeTeam, Formation([2, 3, 1])));
      players.addAll(applyFormation(_awayTeam, Formation([2, 3, 1])));
      _controller.add(players);
    }
  }

  bool _isFieldSizeChanged(newSize) =>
      _fieldSize == null ||
      newSize.width != _fieldSize.width ||
      newSize.height != _fieldSize.height;

  void clearField() {
    _controller.add([]);
  }

  List<Player> applyFormation(FieldTeam team, Formation formation) {
    double lineHeight = _fieldSize.height / (formation.lines.length + 1);
    List<Player> newPlayers = List();
    newPlayers.add(_createKeeper(team, lineHeight));
    formation.lines.asMap().forEach((index, value) => {
          newPlayers.addAll(_createPlayersLine(
              team, value, lineHeight / 2 * (index + 1) + lineHeight / 2))
        });
    return newPlayers;
  }

  Player _createKeeper(FieldTeam team, double lineHeight) => Player(
      id: _nextId++,
      teamId: team.id,
      color: team.keeperColor,
      position:
          Offset(_fieldSize.width / 2, initialYForTeam(lineHeight / 2, team)));

  List<Player> _createPlayersLine(FieldTeam team, int count, double lineCenterY) {
    final cellWidth = _fieldSize.width / count;
    return List.generate(
        count,
        (index) => Player(
            id: _nextId++,
            teamId: team.id,
            color: team.playersColor,
            position: Offset(cellWidth / 2 + index * cellWidth,
                initialYForTeam(lineCenterY, team))));
  }

  double initialYForTeam(double y, FieldTeam team) =>
      team.id == _homeTeam.id ? y : _fieldRect.bottomCenter.dy - y;

  void playerMoved(Player player, Offset newPosition) {
    player.position = newPosition;
  }

  @override
  void dispose() {
    _config.close();
    _controller.close();
  }
}
