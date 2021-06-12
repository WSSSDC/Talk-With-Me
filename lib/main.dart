import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'talk-group.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print(FlutterConfig.get('OPENAI_API_KEY'));
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gotham',
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gotham'
          ),
          subtitle1: TextStyle(
            fontSize: 22,
            color: Colors.black54,
            fontWeight: FontWeight.w400
          ),
          subtitle2: TextStyle(
            fontSize: 18,
            color: Colors.black45,
            fontWeight: FontWeight.w400
          )
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                'What would you like to talk about?',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Container(height: 20),
            TalkGroup(),
            TalkGroup(),
            TalkGroup(),
          ],
        ),
      ),
    );
  }
}
