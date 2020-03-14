import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tactical_board/blocs/blocs_provider.dart';
import 'package:tactical_board/blocs/field/field_screen_model.dart';
import 'package:tactical_board/data/scheme_dao.dart';
import 'package:tactical_board/model/field_config.dart';
import 'package:tactical_board/model/field_entity.dart';
import 'package:tactical_board/model/formation.dart';
import 'package:tactical_board/model/player.dart';
import 'package:tactical_board/model/scheme.dart';
import 'package:tactical_board/model/team.dart';
import 'package:tactical_board/utils/color_utils.dart';

class EntitySnapshot {
  EntitySnapshot({this.index, this.position});
  int index;
  Offset position;
}

class FieldBloc extends BlocBase {
  FieldBloc() {
    _config.add(getDefaultFieldConfig());
    _screenStateController.add(_screenState);
  }

  int _nextId = 0;

  final _homeTeam = Team(
      id: 1,
      playersColor: colorFromHex("#1F9A81"),
      keeperColor: Colors.grey[400]);
  final _awayTeam =
      Team(id: 2, playersColor: Colors.red, keeperColor: Colors.yellow[300]);

  Scheme _scheme;
  final _controller = StreamController<Scheme>();
  Stream<Scheme> get fieldItems => _controller.stream;

  final _config = StreamController<FieldConfig>();
  Stream<FieldConfig> get config => _config.stream;

  final _screenState = FieldScreenModel();
  final _screenStateController = StreamController<FieldScreenModel>();
  Stream<FieldScreenModel> get state => _screenStateController.stream;

  Size _fieldSize;
  Rect _fieldRect;

  updateFieldSize(Size size, Rect fieldRect) {
    if (_isFieldSizeChanged(size)) {
      _fieldSize = size;
      _fieldRect = fieldRect;

      var newConfig = getFieldConfig(size);
      _config.add(newConfig);

      clearField();

      final items = List<FieldEntity>()
        ..addAll(applyFormation(_homeTeam, Formation([2, 3, 1])))
        ..addAll(applyFormation(_awayTeam, Formation([2, 3, 1])))
        ..add(FieldEntity(
            position: fieldRect.center, type: FieldEntityType.Ball));
      _scheme = Scheme(items: items, friendlyName: "Schemone");
      _controller.add(_scheme);

      SchemeDao().getAllSortedByName().then((list) {
        if (list.length > 0) {
          _scheme = list[list.length - 1];
          _controller.add(_scheme);
        }
      });
    }
  }

  bool _isFieldSizeChanged(newSize) =>
      _fieldSize == null ||
      newSize.width != _fieldSize.width ||
      newSize.height != _fieldSize.height;

  void clearField() {
    _controller.add(Scheme(friendlyName: "Cleared", items: []));
  }

  List<Player> applyFormation(Team team, Formation formation) {
    double lineHeight = _fieldSize.height / 1.2 / (formation.lines.length + 1);
    List<Player> newPlayers = List();
    var nextShirtNumber = 2;
    newPlayers.add(_createKeeper(team, lineHeight));
    formation.lines.asMap().forEach((index, value) {
      newPlayers.addAll(_createPlayersLine(team, value,
          lineHeight / 2 * (index + 1) + lineHeight / 2, nextShirtNumber));
      nextShirtNumber += value;
    });
    return newPlayers;
  }

  Player _createKeeper(Team team, double lineHeight) => Player(
      id: _nextId++,
      teamId: team.id,
      color: team.keeperColor,
      shirtNumber: 1,
      position:
          Offset(_fieldSize.width / 2, initialYForTeam(lineHeight / 2, team)));

  List<Player> _createPlayersLine(
      Team team, int count, double lineCenterY, int nextShirtNumber) {
    final cellWidth = _fieldSize.width / count;
    return List.generate(
        count,
        (index) => Player(
            id: _nextId++,
            teamId: team.id,
            color: team.playersColor,
            shirtNumber: nextShirtNumber++,
            position: Offset(cellWidth / 2 + index * cellWidth,
                initialYForTeam(lineCenterY, team))));
  }

  double initialYForTeam(double y, Team team) =>
      team.id == _homeTeam.id ? y : _fieldRect.bottomCenter.dy - y;

  void entityMoved(FieldEntity entity, Offset newPosition) {
    entity.position = newPosition;
    _controller.add(_scheme);
  }

  int _animationDuration = 1000;
  int _animationTickInterval = 10;
  Curve _animationCurve = Curves.easeInOut;

  playShutter() async {
    final player = AudioCache(respectSilence: true, prefix: 'sounds/');
    player.play('shutter_click.mp3');
  }

  void takeSnapshot() {
    playShutter();

    _scheme.saveSnapshot();
  }

  void playSnapshots() {
    if (_scheme.snapshots.length < 2) return;

    SchemeSnapshot first = _scheme.snapshots[0];
    for (var i = 0; i < first.itemsPositions.length; i++) {
      _scheme.items[i].position = first.itemsPositions[i];
    }

    playSnapshot(0);
  }

  void playSnapshot(snapIndex) {
    if (snapIndex >= _scheme.snapshots.length - 1) return;

    SchemeSnapshot start = _scheme.snapshots[snapIndex];
    SchemeSnapshot end = _scheme.snapshots[snapIndex + 1];

    int index = -1;

    // Indexes of items which have been moved in the current transition
    final movedItems =
        start.itemsPositions.fold<List<int>>([], (previousValue, startOffset) {
      final endOffset = end.itemsPositions[++index];
      if (startOffset.dx != endOffset.dx || startOffset.dy != endOffset.dy) {
        return [...previousValue, index];
      } else {
        return previousValue;
      }
    });

    int ticksCount = (_animationDuration / _animationTickInterval).floor();
    Timer.periodic(Duration(milliseconds: _animationTickInterval), (Timer t) {
      if (t.tick >= ticksCount) {
        t.cancel();
        playSnapshot(snapIndex + 1);
      } else {
        for (var i = 0; i < movedItems.length; i++) {
          final index = movedItems[i];
          final percent = _animationCurve.transform(t.tick / ticksCount);
          _scheme.items[index].position = Offset.lerp(
              start.itemsPositions[index], end.itemsPositions[index], percent);
        }

        _controller.add(_scheme);
      }
    });
  }

  void createNewScheme() {
    _scheme = Scheme(friendlyName: "", items: _scheme.items);
    _screenState.mode = FieldEditMode.CreateScheme;
    _screenStateController.add(_screenState);
  }

  void abortSchemeCreation() {
    _screenState.mode = FieldEditMode.Free;
    _screenStateController.add(_screenState);
  }

  void saveCurrentScheme() {
    SchemeDao().insert(_scheme);
  }

  @override
  void dispose() {
    _config.close();
    _controller.close();
    _screenStateController.close();
  }
}
