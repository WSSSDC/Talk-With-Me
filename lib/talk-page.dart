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
  SpeechToText speech = SpeechToText();
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
    if(mounted) { 
      if (SessionHandler.status == TalkStatus.user_talking) startSTT();
      if (SessionHandler.status == TalkStatus.not_running) endSession();
      setState(() {});
    }
  }

  void initSTT() async {
    SessionHandler.status = TalkStatus.user_talking;
    if(!speechAvailable)
    speechAvailable = await speech.initialize(onStatus: (s) {}, onError: (e) => print(e));
    update();
  }
  
  void startSTT() async {
    if (speechAvailable && !speech.isListening) 
    speech.listen(onResult: resultListener);
  }

  resultListener(SpeechRecognitionResult result) {
    userInput = userInput.length < result.recognizedWords.length ? result.recognizedWords : userInput;
    if(timer == null) {
      timer = RestartableTimer(Duration(milliseconds: 750), () {
        if(userInput.toUpperCase().replaceAll(' ', '') != "CLOSE") {
          SessionHandler.status = TalkStatus.fetching_response;
          speech.cancel();
          Messages.addMessage(Message(true, userInput));
          OpenAIHandler.complete(userInput);
          userInput = '';
        } else {
          SessionHandler.status = TalkStatus.not_running;
        }
      });
    }
    timer.reset();
  }

  endSession() {
    speech.cancel();
    userInput = '';
    Messages.messages = [];
    if(OpenAIHandler.flutterTts != null)
    OpenAIHandler.flutterTts.stop();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SessionHandler.status = TalkStatus.not_running;
        return true;
      },
      child: Scaffold(
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
                        onTap: () => SessionHandler.status = TalkStatus.not_running,
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
      ),
    );
  }
}