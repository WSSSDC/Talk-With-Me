import 'package:flutter/material.dart';
import 'profile-data.dart';

class Profile extends StatefulWidget {
  const Profile({ Key key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // TextEditingController _first = TextEditingController();
  // TextEditingController _last = TextEditingController();

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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 10),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: Text(
                    ProfileData.initials, 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 30.0, 0, 0),
              child: Row(
                children: [
                  Text('Name', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 0, 15.0, 0),
              child: TextField(
                autofillHints: [AutofillHints.givenName],
                decoration: InputDecoration(
                  hintText: ProfileData.first.isNotEmpty ? ProfileData.first : 'First'
                ),
                style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 20),
                onChanged: (v) {
                  ProfileData.first = v;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 0, 15.0, 0),
              child: TextField(
                autofillHints: [AutofillHints.givenName],
                decoration: InputDecoration(
                  hintText: ProfileData.last.isNotEmpty ? ProfileData.last : 'Last'
                ),
                style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 20),
                onChanged: (v) {
                  ProfileData.last = v;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 30.0, 0, 0),
              child: Row(
                children: [
                  Text('Voice', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  childAspectRatio: 0.84,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: ProfileData.voices.map((e) => Voice(e)).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Voice extends StatelessWidget {
  const Voice(this.voice, { Key key }) : super(key: key);
  final Map voice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProfileData.voice = ProfileData.voices.indexOf(voice);
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: ProfileData.voices.indexOf(voice) == ProfileData.voice ? 1 : 0.5,
        child: Container(
          height: 200,
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/animojis/' + voice['name'] + '.png'),
                  Text(voice['name']),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}