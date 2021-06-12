import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TalkPage extends StatefulWidget {
  const TalkPage({ Key key }) : super(key: key);

  @override
  _TalkPageState createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {

  @override
  void initState() {
    setupSST();
    super.initState();
  }

  void setupSST() async {
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize( onStatus: statusListener, onError: errorListener );
    if ( available ) {
        speech.listen( onResult: resultListener );
    }
    else {
        print("The user has denied the use of speech recognition.");
    }
  }

  statusListener(status) {

  }

  errorListener(error) {

  }

  resultListener(SpeechRecognitionResult result) {
    print(result.finalResult ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}