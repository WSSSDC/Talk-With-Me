import 'package:flutter/material.dart';
import 'status-handler.dart';
import 'categories.dart';
import 'talk-page.dart';

class TalkGroup extends StatefulWidget {
  const TalkGroup(this.category, { Key key }) : super(key: key);
  final Category category;

  @override
  _TalkGroupState createState() => _TalkGroupState(category);
}

class _TalkGroupState extends State<TalkGroup> {
  _TalkGroupState(this.category);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
        Container(height: 5.0),
        Container(
          height: 140,
          child: ListView(
            children: <Widget>[
              Container(width: 15),
            ] + category.items.map((e) => TalkCard(e)).toList(),
            scrollDirection: Axis.horizontal,
          ),
        ),
        Container(height: 15),
      ],
    );
  }
}

class TalkCard extends StatelessWidget {
  const TalkCard(this.talkitem, { Key key }) : super(key: key);
  final TalkingItem talkitem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SessionHandler.startSession(talkitem);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => TalkPage()));
      },
      child: Container(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 10),
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Center(
              child: Text(
                talkitem.name,
                style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}