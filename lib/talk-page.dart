import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'visualizer.dart';
import 'visualizer-input.dart';
import 'package:async/async.dart';


class TalkPage extends StatefulWidget {
  const TalkPage({ Key key }) : super(key: key);

  @override
  _TalkPageState createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  SpeechToText speech;
  bool speechAvailable = false;

  @override
  void initState() {
    MicInput.setup();
    setupSST();
    super.initState();
  }

  RestartableTimer timer;
  
  void setupSST() async {
    speech = SpeechToText();
    speechAvailable = await speech.initialize( onStatus: (s) => print(s), onError: (e) => print(e));
    if ( speechAvailable ) {
        speech.listen( onResult: resultListener );
    }
    else {
        print("The user has denied the use of speech recognition.");
    }  
  }

  resultListener(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    if(timer == null) {
      timer = RestartableTimer(Duration(milliseconds: 900), () {
        speech.stop();
        //MicInput.micStream.stop();
      });
    }
    timer.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Visualizer()
        ],
      ),
    );
  }
}