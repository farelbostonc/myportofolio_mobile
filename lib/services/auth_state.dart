import 'package:flutter/foundation.dart';

import 'api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._api);
  final ApiClient _api;
  String? _token;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> login(String username, String password) async {
    _token = await _api.obtainToken(username, password);
    notifyListeners();
  }

  void clear() {
    _token = null;
    notifyListeners();
  }

  Future<void> logout() async {
    final token = _token;
    if (token == null) return;
    try {
      await _api.logout(token: token);
    } finally {
      clear();
    }
  }
}
