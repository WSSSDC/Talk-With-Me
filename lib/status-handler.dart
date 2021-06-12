import 'package:talk_with_me/messages.dart';
import 'profile-data.dart';

import 'categories.dart';
import 'openai.dart';

class SessionHandler {
  static List<Function> listeners = [];

  static addListener(Function update) {
    listeners.add(update);
  }

  static notifyListeners() {
    listeners.forEach((e) => e());
  }

  static get status => _status;
  static set status (TalkStatus newStatus) {
    if(_status != newStatus) {
      _status = newStatus;
      notifyListeners();
    }
  }

  static TalkStatus _status = TalkStatus.user_talking;

  static startSession(TalkingItem item) {
    OpenAIHandler.currentText = OpenAIHandler.defaultPrompt + item.userPrompt + '\n' + 'Sam: ' + item.aiPrompt + '\n' + (ProfileData.first.isEmpty ? 'User' : ProfileData.first) + ':';
    Messages.addMessage(Message(false, item.aiPrompt));
    _status = TalkStatus.user_talking;
    notifyListeners();
  }
  
}

enum TalkStatus {
  user_talking,
  fetching_response,
  ai_talking,
  not_running
}