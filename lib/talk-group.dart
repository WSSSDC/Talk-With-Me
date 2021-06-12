import 'package:flutter/material.dart';

class TalkGroup extends StatefulWidget {
  const TalkGroup({ Key key }) : super(key: key);

  @override
  _TalkGroupState createState() => _TalkGroupState();
}

class _TalkGroupState extends State<TalkGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
              child: Text(
                'Relationships',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
        Container(height: 5.0),
        Container(
          height: 140,
          child: ListView(
            children: [
              Container(width: 15),
              TalkCard(),
              TalkCard(),
              TalkCard(),
              TalkCard()
            ],
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }
}

class TalkCard extends StatelessWidget {
  const TalkCard({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        
        child: Center(
          child: Text('Test'),
        ),
      ),
    );
  }
}