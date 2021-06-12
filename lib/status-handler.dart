class CurrentStatus {
  static List<Function> listeners = [];

  static addListener(Function update) {
    listeners.add(update);
  }

  static notifyListeners() {
    listeners.forEach((e) => e());
  }

  static get status => _status;
  static set status (TalkStatus new_status) {
    _status = new_status;
    notifyListeners();
  }

  static TalkStatus _status = TalkStatus.user_talking;
  
}

enum TalkStatus {
  user_talking,
  fetching_response,
  ai_talking
}