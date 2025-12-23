class AuthService {
  static final List<Map<String, String>> _users = [];

  static String? currentUser;
  static String? currentRole;

  static void init() {
    if (_users.any((u) => u['username'] == 'admin')) return;

    _users.add({
      'fullName': 'Administrator',
      'email': 'admin@gmail.com',
      'phone': '0000000000',
      'username': 'admin',
      'password': 'admin123',
      'role': 'admin',
    });
  }

  static bool register({
    required String fullName,
    required String email,
    required String phone,
    required String username,
    required String password,
  }) {
    init();

    if (_users.any((u) => u['username'] == username)) {
      return false;
    }

    _users.add({
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'username': username,
      'password': password,
      'role': 'user',
    });

    return true;
  }
  static bool login(String username, String password) {
    init();

    try {
      final user = _users.firstWhere(
            (u) => u['username'] == username && u['password'] == password,
      );

      currentUser = user['username'];
      currentRole = user['role'];
      return true;
    } catch (e) {
      return false;
    }
  }

  static void logout() {
    currentUser = null;
    currentRole = null;
  }


  static bool changePassword(String oldPass, String newPass) {
    if (currentUser == null) return false;

    final index =
    _users.indexWhere((u) => u['username'] == currentUser);

    if (index == -1) return false;
    if (_users[index]['password'] != oldPass) return false;

    _users[index]['password'] = newPass;
    return true;
  }


  static bool get isAdmin => currentRole == 'admin';

  static List<Map<String, String>> get allUsers => _users;
}
