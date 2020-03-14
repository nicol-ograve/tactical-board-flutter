import 'package:flutter/material.dart';
import 'package:tactical_board/blocs/field/field_bloc.dart';
import 'package:tactical_board/blocs/field/field_screen_model.dart';
import 'package:tactical_board/widgets/field/state/create_scheme_state.dart';
import 'package:tactical_board/widgets/field/state/free_mode_state.dart';
import 'package:tactical_board/widgets/field/state/view_scheme_state.dart';



abstract class FieldScreenState {
  FieldScreenState(this.fieldBloc);

  FieldBloc fieldBloc;

  List<Widget> get topActions;
  List<Widget> get bottomActions;
  String get title;
}


FieldScreenState getState(FieldEditMode mode, FieldBloc fieldBloc, BuildContext context) {
  if (fieldBloc == null) return null;
  switch (mode) {
    case FieldEditMode.CreateScheme:
      return CreateSchemeModeState(fieldBloc, context);
    case FieldEditMode.ViewScheme:
      return ViewSchemeModeState(fieldBloc);
    case FieldEditMode.Free:
    default:
      return FreeModeState(fieldBloc);
  }
}
