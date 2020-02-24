import 'package:flutter/material.dart';
import 'package:tactical_board/blocs/blocs_provider.dart';
import 'package:tactical_board/blocs/field_bloc.dart';
import 'package:tactical_board/widgets/field/field.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//creating Key for field Widget
  final GlobalKey _fieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fieldBloc = FieldBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox fieldBox = _fieldKey.currentContext?.findRenderObject();
      if (fieldBox == null) {
        debugPrint('null');
      } else {
        debugPrint('ok');
        //fieldBloc.fieldSize = fieldBox.size;
      }
    });
    return SafeArea(
        key: _fieldKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: BlocProvider<FieldBloc>(
                bloc: fieldBloc, child: buildField(fieldBloc))));
  }

  Widget buildField(FieldBloc bloc) {
    return StreamBuilder(
        stream: bloc.players,
        builder: (context, snapshot) {
          return Field(
              players: snapshot.data);
        });
  }
}
