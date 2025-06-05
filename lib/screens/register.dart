import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  String _selectedRole = 'User';
  String _selectedGender = 'Male';

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        ageCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black87),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool obscure = false, TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: inputType,
        style: TextStyle(color: Colors.black87),
        decoration: _inputDecoration(label),
        validator: (value) {
          if (value == null || value.isEmpty) return '$label is required';
          if (label == "Email") {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            return emailRegex.hasMatch(value) ? null : 'Enter a valid email';
          }
          if (label == "Password" && value.length < 6) return 'Minimum 6 characters';
          if (label == "Confirm Password" && value != passwordCtrl.text) return 'Passwords do not match';
          return null;
        },
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedRole,
          fillColor: MaterialStateProperty.all(Colors.black87),
          onChanged: (val) => setState(() => _selectedRole = val!),
        ),
        Text(value, style: TextStyle(color: Colors.black87)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/travel1.jpeg", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("Sign Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                      SizedBox(height: 20),
                      _buildTextField("Full Name", nameCtrl),
                      _buildTextField("Email", emailCtrl),
                      _buildTextField("Mobile Number", mobileCtrl, inputType: TextInputType.phone),
                      _buildTextField("Password", passwordCtrl, obscure: true),
                      _buildTextField("Confirm Password", confirmPasswordCtrl, obscure: true),

                      Row(
                        children: [
                          Text("Role:", style: TextStyle(color: Colors.black87)),
                          _buildRadio("User"),
                          _buildRadio("Customer"),
                        ],
                      ),
                      SizedBox(height: 10),

                      TextFormField(
                        controller: ageCtrl,
                        readOnly: true,
                        style: TextStyle(color: Colors.black87),
                        decoration: _inputDecoration("Age (Date of Birth)"),
                        onTap: _pickDate,
                        validator: (val) => val == null || val.isEmpty ? 'Please select your birth date' : null,
                      ),

                      SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: _inputDecoration("Gender"),
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Colors.black87),
                        items: ['Male', 'Female', 'Other']
                            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedGender = val!),
                        validator: (val) => val == null || val.isEmpty ? 'Please select gender' : null,
                      ),

                      SizedBox(height: 10),
                      _buildTextField("City / Location", cityCtrl),

                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('email', emailCtrl.text);
                            await prefs.setString('password', passwordCtrl.text);
                            await prefs.setString('role', _selectedRole);
                            await prefs.setString('name', nameCtrl.text);
                            await prefs.setString('mobile', mobileCtrl.text);
                            await prefs.setString('gender', _selectedGender);
                            await prefs.setString('age', ageCtrl.text);
                            await prefs.setString('city', cityCtrl.text);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Registration Successful")),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          }
                        },
                        child: Text("Register", style: TextStyle(color: Colors.white)),
                      ),

                      SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },
                        child: Text("Already have an account? Sign In",
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
