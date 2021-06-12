class CurrentStatus {
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
  
}

enum TalkStatus {
  user_talking,
  fetching_response,
  ai_talking
}