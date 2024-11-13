import 'package:flutter/material.dart';
import 'package:midterm/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_page.dart';
class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();

}
class _AdminLoginState extends State<AdminLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  AdminLogin() {
    FirebaseFirestore.instance.collection("admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['username'] != _emailController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Your id is not correct",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (result.data()['password'] !=
            _passwordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Your password is not correct",
                style: TextStyle(fontSize: 18.0),
              )));
        } else {
          Route route = MaterialPageRoute(builder: (context) => AdminHomePage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Admin Sign In"),
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
              TextFormField(
                validator: (value){
                if(value==null|| value.isEmpty){
                  return 'Please Enter Email';
                }
                  return null;
                },
                controller: _emailController,
                decoration:  InputDecoration(
                  hintText: 'Admin Email', 
                  hintStyle: AppWidget.LightTextFeildStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (value){
                if(value==null|| value.isEmpty){
                  return 'Please Enter Password';
                }
                  return null;
                },
                controller: _passwordController,
                decoration:  InputDecoration(
                  hintText: 'Password',
                  hintStyle: AppWidget.LightTextFeildStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  AdminLogin();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.black,
                ),
                child: const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 18)),
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
            ],
          ),
        )
      ),
    );
  }
}
