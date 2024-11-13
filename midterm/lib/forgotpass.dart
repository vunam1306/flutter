import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:midterm/login_page.dart';
import 'package:midterm/widget/widget_support.dart';


class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  String _message = '';

  Future<void> _sendPasswordResetEmail() async {
    final email = _emailController.text.trim();

    try {
      // Send password reset email
      await _auth.sendPasswordResetEmail(email: email);

      setState(() {
        _message = "Password reset link has been sent to your email.";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message ?? "An error occurred. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _sendPasswordResetEmail,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.black,
                ),
                child: const Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains("error") ? Colors.red : Colors.green,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 15,),
              GestureDetector(
                  onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
              },
                child: Text(
                  "Back to login",
                  style: AppWidget.SemiBoldTextFeildStyle(),
              ))
            ],
            
          ),
        ),
        
      ),
     
    );
  }
}
