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
            Container(height: 25),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: TextField(
                autofillHints: [AutofillHints.givenName],
                decoration: InputDecoration(
                  hintText: ProfileData.first.isNotEmpty ? ProfileData.first : 'First'
                ),
                onChanged: (v) {
                  ProfileData.first = v;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: TextField(
                autofillHints: [AutofillHints.givenName],
                decoration: InputDecoration(
                  hintText: ProfileData.last.isNotEmpty ? ProfileData.last : 'Last'
                ),
                onChanged: (v) {
                  ProfileData.last = v;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}