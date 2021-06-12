import 'package:flutter_config/flutter_config.dart';
import 'package:gpt_3_dart/gpt_3_dart.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'messages.dart';
import 'profile-data.dart';
import 'status-handler.dart';

class OpenAIHandler {
  static OpenAI openAI = new OpenAI(apiKey: FlutterConfig.get('OPENAI_API_KEY'));
  static String defaultPrompt = 
  ProfileData.voiceName + ": Hi " + ProfileData.first + "! I'm your therapist, " + ProfileData.voiceName + ". It's so nice to meet you! What would you like to talk about?\n" + (ProfileData.first.isEmpty ? 'User' : ProfileData.first) + ":";
  static String currentText = '';
  static String aiResponse = '';
  static FlutterTts flutterTts;
  static List<String> endcodes = ["\n", ProfileData.voiceName + ":", (ProfileData.first.isEmpty ? 'User' : ProfileData.first) + ":", "."];

  static complete(String response) async {
    currentText += response + "\n" + ProfileData.voiceName + ":";
    String generated = await openAI.complete(currentText, 40);
    aiResponse = generated;
    endcodes.forEach((e) => removeAt(e));

    if(aiResponse.substring(0,1) == ' ') aiResponse = aiResponse.replaceFirst(' ', '');
    currentText += aiResponse + '\n' + (ProfileData.first.isEmpty ? 'User' : ProfileData.first) + ':';
    Messages.addMessage(Message(false, aiResponse));
    _playResponse();
  }

  static _playResponse() async {
    flutterTts = FlutterTts();
    List<dynamic> voices = await flutterTts.getVoices;
    print(voices.where((e) => e['locale'].contains('en-')).map((e) => e['locale']));
    await flutterTts.setVoice(ProfileData.voices[ProfileData.voice]);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(aiResponse);
    if(aiResponse.toUpperCase().contains('BYE')) {
      SessionHandler.status = TalkStatus.not_running;
    } else {
      SessionHandler.status = TalkStatus.user_talking;
    }
  }

  static removeAt(String match) {
    int i = aiResponse.indexOf(match);
    if (i > 0) {
      aiResponse = aiResponse.substring(0, i);
    }
  }
}

