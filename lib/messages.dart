import "dart:math";

class Messages {
  static List<Function> listeners = [];

  static addListener(Function update) {
    listeners.add(update);
  }

  static notifyListeners() {
    listeners.forEach((e) => e());
  }

  static var welcomeStrings = [
    'Hello!',
    // 'Bonjour!',
    // 'Howdy!',
    'Welcome!',
    'Hey There!'
  ];

  static List<Message> get messages => _messages;
  static set messages(List<Message> newlist) {
    _messages = newlist;
    notifyListeners();
  }

  static addMessage(Message msg) {
    _messages.insert(0, msg);
    notifyListeners();
  }

  static List<Message> _messages = [
    //Message(false, welcomeStrings[new Random().nextInt(welcomeStrings.length - 1)])
  ];
}

class Message {
  bool fromUser;
  String message;

  Message(bool _fromUser, String _message) {
    this.fromUser = _fromUser;
    this.message = _message;
  }
}
