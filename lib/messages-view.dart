import 'package:flutter/material.dart';
import 'messages.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({ Key key }) : super(key: key);

  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    Messages.addListener(update);
    super.initState();
  }

  update() {
    if(mounted) setState(() {});
    _scrollController.animateTo(0.0, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView(
              reverse: true,
              shrinkWrap: true,
              controller: _scrollController,
              children: Messages.messages.map((e) => MessageText(e.fromUser, e.message)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageText extends StatelessWidget {
  const MessageText(this.fromUser, this.message, { Key key }) : super(key: key);
  final bool fromUser;
  final String message;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
        mainAxisAlignment: fromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            width: width * 0.5,
            alignment: fromUser ? Alignment.centerRight : null,
            child: Text(
              message,
              style: TextStyle(
                fontSize: 30,
                color: fromUser ? Colors.black45 : Colors.black
              ),
            ),
          )
        ],
    );
  }
}