import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'profile.dart';
import 'categories.dart';
import 'talk-group.dart';
import 'profile-data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await ProfileData.getData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print(FlutterConfig.get('OPENAI_API_KEY'));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //brightness: Brightness.dark,
        fontFamily: 'Gotham',
        primarySwatch: Colors.grey,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w400,
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
  void initState() {
    ProfileData.addListener(update);
    super.initState();
  }

  update() {
    if(mounted) setState(() => ProfileData.initials);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.7,
                    child: Text(
                        'What would you like to talk about?',
                        style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Profile()));
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Text(
                          ProfileData.initials, 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(height: 20),
          ] + Categories.groups.map((e) => TalkGroup(e)).toList(),
        ),
      ),
    );
  }
}
