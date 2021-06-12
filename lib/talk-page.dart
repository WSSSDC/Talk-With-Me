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
  bool speechAvailable = false;
  RestartableTimer timer;

  @override
  void initState() {
    initSTT();
    SessionHandler.addListener(update);
    MicInput.setup();
    super.initState();
  }

  update() {
    if(mounted) setState(() {});
    if (SessionHandler.status == TalkStatus.user_talking) startSTT();
  }

  void initSTT() async {
    SessionHandler.status = TalkStatus.user_talking;
    speech = SpeechToText();
    //if(!speechAvailable)
    speechAvailable = await speech.initialize(onStatus: (s) => print('status: ' + s), onError: (e) => print(e), finalTimeout: Duration(hours: 1));
    update();
  }
  
  void startSTT() {
    if (speechAvailable && !speech.isListening) {
      speech.listen(onResult: resultListener);
    }
    else {
        print("The user has denied the use of speech recognition.");
    }  
  }

  resultListener(SpeechRecognitionResult result) {
    //print(result.recognizedWords);
    userInput = userInput.length < result.recognizedWords.length ? result.recognizedWords : userInput;
    if(timer == null) {
      timer = RestartableTimer(Duration(milliseconds: 750), () {
        print("CANCEL");
        speech.cancel();
        SessionHandler.status = TalkStatus.fetching_response;
        Messages.addMessage(Message(true, userInput));
        OpenAIHandler.complete(userInput);
        userInput = '';
      });
    }
    timer.reset();
  }

  endSession() {
    print("END SESSION");
    speech.cancel();
    userInput = '';
    Messages.messages = [];
    SessionHandler.status = TalkStatus.not_running;
    if(OpenAIHandler.flutterTts != null)
    OpenAIHandler.flutterTts.stop();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              MessagesView(),
              Visualizer(),
              Container(height: 10)
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5.0, 15.0, 0),
            child: SafeArea(
              child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 70,
                    height: 40,
                    child: GestureDetector(
                      onTap: endSession,
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            'End',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300
                            ),
                          )
                        ),
                        color: Colors.red,
                      ),
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}