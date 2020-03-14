import 'package:flutter/material.dart';
import 'package:tactical_board/blocs/field/field_bloc.dart';
import 'package:tactical_board/widgets/field/state/field_screen_state.dart';

class CreateSchemeModeState extends FieldScreenState {
  CreateSchemeModeState(FieldBloc fieldBloc, BuildContext context)
      : super(fieldBloc) {
    this._context = context;
  }

  BuildContext _context;
  List<Widget> _bottomActions, _topActions;

  @override
  List<Widget> get topActions {
    if (_topActions == null)
      _topActions = [
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.save),
          tooltip: "Save scheme",
          onPressed: () {
            fieldBloc.saveCurrentScheme();
          },
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.delete_forever),
          tooltip: "Delete current scheme",
          onPressed: () {
            showDialog(
                context: _context, builder: (context) => _abortDialog(context));
          },
        ),
      ];
    return _topActions;
  }

  @override
  List<Widget> get bottomActions {
    if (_bottomActions == null) {
      _bottomActions = [
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.camera),
          tooltip: "Take snapshot",
          onPressed: () {
            fieldBloc.takeSnapshot();
          },
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.play_circle_filled),
          tooltip: "Play snapshot",
          onPressed: () {
            fieldBloc.playSnapshots();
          },
        )
      ];
    }
    return _bottomActions;
  }

  @override
  String get title => "Create new scheme";

  _abortDialog(BuildContext context) => AlertDialog(
          title: Text("Abort scheme creation"),
          content: Text("You're deleting the current scheme, are you sure?"),
          actions: <Widget>[
            FlatButton(
                child: Text("DELETE"), onPressed: () => Navigator.pop(context)),
            FlatButton(
                child: Text("OK"),
                onPressed: () {
                  fieldBloc.abortSchemeCreation();
                  Navigator.pop(context);
                })
          ]);
}
