import 'package:flutter/material.dart';
import 'package:tactical_board/blocs/blocs_provider.dart';
import 'package:tactical_board/blocs/field/field_bloc.dart';
import 'package:tactical_board/blocs/field/field_screen_model.dart';
import 'package:tactical_board/widgets/field/field.dart';
import 'package:tactical_board/widgets/field/state/field_screen_state.dart';

class FieldScreen extends StatelessWidget {
  final fieldBloc = FieldBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fieldBloc.state,
        builder: (context, stateStream) {
          final screenModel = stateStream.data as FieldScreenModel;
          final state = getState(screenModel?.mode, fieldBloc, context);
          return Scaffold(
              appBar: AppBar(
                title: Text(state.title),
                backgroundColor: Colors.green[900],
                actions: state.topActions,
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.green[900],
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: state.bottomActions,
                ),
              ),
              body: Stack(children: [
                BlocProvider<FieldBloc>(
                    bloc: fieldBloc, child: buildField(fieldBloc))
              ]));
        });
  }

  Widget buildField(FieldBloc bloc) {
    return StreamBuilder(
        stream: bloc.fieldItems,
        builder: (context, fieldSnapshot) {
          return StreamBuilder(
              stream: bloc.config,
              builder: (context, configSnapshot) => Field(
                  fieldEntities: fieldSnapshot.data?.items,
                  bloc: bloc,
                  config: configSnapshot.data));
        });
  }
}
