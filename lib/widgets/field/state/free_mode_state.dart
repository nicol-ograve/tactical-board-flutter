import 'package:flutter/material.dart';
import 'package:tactical_board/blocs/field/field_bloc.dart';
import 'package:tactical_board/widgets/field/state/field_screen_state.dart';

class FreeModeState extends FieldScreenState {
  List<Widget> _bottomActions = [IconButton(icon: Icon(null), onPressed: null)];
  List<Widget> _topActions;

  FreeModeState(FieldBloc fieldBloc) : super(fieldBloc);

  @override
  String get title => "Tactical board";

  @override
  List<Widget> get bottomActions => _bottomActions;
  @override
  List<Widget> get topActions {
    if (_topActions == null)
      _topActions = [
        IconButton(
          padding: EdgeInsets.all(16.0),
          icon: new Tab(
              icon: new Image.asset(
            "assets/images/tactics.png",
            color: Colors.white,
          )),
          onPressed: () {
            fieldBloc.createNewScheme();
            // fieldBloc.takeSnapshot();
          },
        )
      ];
    return _topActions;
  }
}
