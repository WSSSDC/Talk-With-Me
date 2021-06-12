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
    if(_scrollController.positions.isNotEmpty)
    _scrollController.animateTo(0.0, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.transparent, Colors.white, Colors.white, Colors.white],
            ).createShader(bounds);
        },
        //blendMode: BlendMode.dstATop,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            reverse: true,
            controller: _scrollController,
            children: Messages.messages.map((e) => MessageText(e.fromUser, e.message)).toList(),
          ),
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
            width: width * 0.6,
            alignment: fromUser ? Alignment.centerRight : null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 3.0, 0, 3.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 30,
                  color: fromUser ? Colors.black45 : Colors.black
                ),
                textAlign: fromUser ? TextAlign.right : TextAlign.left,
              ),
            ),
          )
        ],
    );
  }
}