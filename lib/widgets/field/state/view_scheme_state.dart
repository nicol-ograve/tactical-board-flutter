
import 'package:flutter/material.dart';
import 'package:tactical_board/blocs/field/field_bloc.dart';
import 'package:tactical_board/widgets/field/state/field_screen_state.dart';

class ViewSchemeModeState extends FieldScreenState {
  ViewSchemeModeState(FieldBloc fieldBloc) : super(fieldBloc);

  @override
  List<Widget> get topActions => throw UnimplementedError();

  @override
  List<Widget> get bottomActions => throw UnimplementedError();

  @override
  String get title => "View scheme";
}
