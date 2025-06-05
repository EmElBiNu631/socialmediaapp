import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _isLoggedIn = "isLoggedIn";
  static const String _email = "email";
  static const String _password = "password";
  static const String _role = "role";
  static const String _id = "id";

  Future<bool> signupUser({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_email, email);
      await prefs.setString(_password, password);
      await prefs.setString(_role, role);
      await prefs.setBool(_isLoggedIn, true);
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final ref = FirebaseDatabase.instance.ref().child("users");

    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;

      for (var entry in data.entries) {
        Map user = entry.value;
        if (user['email'] == email && user['password'] == password) {
          // Save session locally
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', user['role']); // Save role if needed
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // removes all keys
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      "email": prefs.getString(_email),
      "role": prefs.getString(_role),
      "isLoggedIn": prefs.getBool(_isLoggedIn) ?? false,
    };
  }


  Future<void> updateId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_id, "$id");
  }

  Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idStr = prefs.getString(_id) ?? "0";
    return int.tryParse(idStr);
  }
}
