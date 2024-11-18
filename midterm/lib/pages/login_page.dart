import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:midterm/pages/home.dart';
import 'package:midterm/widget/widget_support.dart';
import 'bottomnav.dart';
import 'package:midterm/widget/widget_support.dart';
import 'signup.dart';
import 'forgotpass.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  String userId = '';

  // Future<void> _signInWithEmailAndPassword() async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );

  //     // Add user data to Firestore
  //     await _firestore.collection('users').doc(userCredential.user?.uid).set({
  //       'email': _emailController.text.trim(),
  //       'password': _passwordController.text.trim(), // Not recommended for security reasons
  //     });

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => BottomNav()),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       _errorMessage = e.message ?? "Sign In fail";
  //     });
  //   }
  // }

  UserLogin() {
  FirebaseFirestore.instance.collection("users").get().then((snapshot) {
    snapshot.docs.forEach((result) {
      if (result.data()['email'] != _emailController.text.trim()) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.red[300],
        //     content: Text(
        //       "Your email is not correct",
        //       style: TextStyle(fontSize: 18.0),
        //     ),
        //   ),
        // );
      } else if (result.data()['password'] !=
          _passwordController.text.trim()) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.red[300],
        //     content: Text(
        //       "Your password is not correct",
        //       style: TextStyle(fontSize: 18.0),
        //     ),
        //   ),
        // );
      } else {
        // Extract user_id from the current document
        String userId = result.id;
        String name = result.data()['name'];
        String phone = result.data()['phone'];
        // Navigate to the Home page, passing the email and userId
        Route route = MaterialPageRoute(
          builder: (context) => BottomNav(
            name: name,
            userId: userId, 
            phone: phone, 
            email: _emailController.text.trim(),
            // Pass the userId
          ),
        );
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
        title: const Text("Sign In"),
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
                  hintText: 'Email', 
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
                  UserLogin();
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

                SizedBox(height: 30,),
                GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text(
                        "Don't have an account? Sign up",
                        style: AppWidget.SemiBoldTextFeildStyle(),
                      )),
                SizedBox(height: 10,),
                GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ForgotPass()));
                      },
                      child: Text(
                        "Forgot your pass?",
                        style: AppWidget.SemiBoldTextFeildStyle(),
                      ))
            ],
          ),
        )
      ),
    );
  }
}
