import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'messages-view.dart';
import 'messages.dart';
import 'status-handler.dart';
import 'visualizer.dart';
import 'visualizer-input.dart';
import 'package:async/async.dart';
import 'openai.dart';


class TalkPage extends StatefulWidget {
  const TalkPage({ Key key }) : super(key: key);

  @override
  _TalkPageState createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  SpeechToText speech;
  String userInput = '';
  bool speechAvailable = true;
  RestartableTimer timer;

  @override
  void initState() {
    CurrentStatus.addListener(update);
    MicInput.setup();
    initSTT();
    super.initState();
  }

  update() {
    if(mounted) setState(() {});
    if (CurrentStatus.status == TalkStatus.user_talking) startSTT();
  }

  void initSTT() async {
    speech = SpeechToText();
    speechAvailable = await speech.initialize( onStatus: (s) => print(s), onError: (e) => print(e));
    update();
  }
  
  void startSTT() {
    if (speechAvailable) {
      CurrentStatus.status = TalkStatus.user_talking;
      speech.listen(onResult: resultListener);
    }
    else {
        print("The user has denied the use of speech recognition.");
    }  
  }

  resultListener(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    userInput = userInput.length < result.recognizedWords.length ? result.recognizedWords : userInput;
    if(timer == null) {
      timer = RestartableTimer(Duration(milliseconds: 400), () {
        speech.cancel();
        CurrentStatus.status = TalkStatus.fetching_response;
        Messages.addMessage(Message(true, userInput));
        OpenAIHandler.complete(userInput);
        userInput = '';
      });
    }
    timer.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MessagesView(),
          Visualizer(),
          Container(height: 10)
        ],
      ),
    );
  }
}