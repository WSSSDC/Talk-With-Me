import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
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

  @override
  void initState() {
    CurrentStatus.addListener(update);
    MicInput.setup();
    setupSST();
    super.initState();
  }

  update() {
    if(mounted) setState(() {});
  }

  RestartableTimer timer;
  
  void setupSST() async {
    speech = SpeechToText();
    bool speechAvailable = await speech.initialize( onStatus: (s) {}, onError: (e) => print(e));
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
      timer = RestartableTimer(Duration(milliseconds: 500), () {
        speech.cancel();
        CurrentStatus.status = TalkStatus.fetching_response;
        print(userInput);
        OpenAIHandler.complete(userInput);
      });
    }
    timer.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Container()),
          Visualizer(),
          Container(height: 10)
        ],
      ),
    );
  }
}