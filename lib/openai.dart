import 'package:flutter_config/flutter_config.dart';
import 'package:gpt_3_dart/gpt_3_dart.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'messages.dart';
import 'profile-data.dart';
import 'status-handler.dart';
import 'dart:math';

class OpenAIHandler {
  static OpenAI openAI = new OpenAI(apiKey: FlutterConfig.get('OPENAI_API_KEY'));
  static String defaultPrompt = 
  "Sam: Hi " + ProfileData.first + "! I'm your therapist, Sam. What would you like to talk about?\nUser: ";
  static String currentText = '';
  static String aiResponse = '';
  static FlutterTts flutterTts;

  static complete(String response) async {
    currentText += response + "\Sam:";
    String generated = await openAI.complete(currentText, 40);
    int end = min(min(generated.indexOf('\n'), generated.indexOf('Sam:')), generated.indexOf('User:'));
    aiResponse = generated.substring(0, end == -1 ? generated.length : end);
    if(aiResponse.substring(0,1) == ' ') aiResponse = aiResponse.replaceFirst(' ', '');
    currentText += aiResponse + '\n' + 'User:';
    Messages.addMessage(Message(false, aiResponse));
    _playResponse();
  }

  static _playResponse() async {
    flutterTts = FlutterTts();
    //await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(aiResponse);
    SessionHandler.status = TalkStatus.user_talking;
  }
}