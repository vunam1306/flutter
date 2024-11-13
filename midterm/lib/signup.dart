import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:midterm/login_page.dart';
import 'package:midterm/widget/widget_support.dart';
import 'pages/bottomnav.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _errorMessage = '';

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match";
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Add user data to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(), // Not recommended for security reasons
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), 
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Sign Up failed";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Image
              Image.asset(
                'images/techzonelogo.png', // Ensure the path matches your asset
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: AppWidget.LightTextFeildStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: AppWidget.LightTextFeildStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: AppWidget.LightTextFeildStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.black,
                ),
                child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Sign In",
                  style: AppWidget.SemiBoldTextFeildStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
