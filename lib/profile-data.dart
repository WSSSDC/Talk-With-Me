import 'package:shared_preferences/shared_preferences.dart';

class ProfileData {
  static List<Function> listeners = [];

  static addListener(Function update) {
    listeners.add(update);
  }

  static notifyListeners() {
    listeners.forEach((e) => e());
  }

  static String get first => _first;
  static String get last => _last;

  static set first(String v) {
    _first = v;
    notifyListeners();
    _saveData();
  }

  static set last(String v) {
    _last = v;
    notifyListeners();
    _saveData();
  }

  static _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first', _first);
    await prefs.setString('last', _last);
  }

  static getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _first = prefs.getString('first') ?? '';
    _last = prefs.getString('last') ?? '';
  }

  static String _first = '';
  static String _last = '';
  static String get initials {
    if(_first.isNotEmpty && _last.isNotEmpty) return _first[0] + _last[0];
    return '';
  }
}