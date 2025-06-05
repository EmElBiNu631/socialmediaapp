import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmediataskapp/screens/userhome.dart';
import 'customerhomepage.dart';
import 'register.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String role = 'User';

  Future<void> loginUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    String? savedRole = prefs.getString('role');

    if (emailCtrl.text == savedEmail && passwordCtrl.text == savedPassword) {
      if (savedRole == 'Customer') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerHome()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserHome()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid email or password'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(child: Image.asset("assets/images/travel1.jpeg", fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
        Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: Form(
                key: formKey,
                child: Column(children: [
                  Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailCtrl,
                    style: TextStyle(color: Colors.black87),
                    decoration: _inputDecoration("Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Invalid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordCtrl,
                    obscureText: true,
                    style: TextStyle(color: Colors.black87),
                    decoration: _inputDecoration("Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password is required';
                      if (value.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                    Radio(value: 'User', groupValue: role, onChanged: (val) => setState(() => role = val!)),
                    Text("User", style: TextStyle(color: Colors.black87)),
                    Radio(value: 'Customer', groupValue: role, onChanged: (val) => setState(() => role = val!)),
                    Text("Customer", style: TextStyle(color: Colors.black87)),
                  ]),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) loginUser();
                    },
                    child: Text("Login", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Register()));
                    },
                    child: Text("Don't have an account? Sign Up", style: TextStyle(color: Colors.black87)),
                  ),
                ]),
              ),
            ),
          ),
        )
      ]),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.black87),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
  );
}
