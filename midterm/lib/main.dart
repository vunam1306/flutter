import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//         apiKey: "AIzaSyAJLNY0Xf-YDAbyz6-wW0aMs0Hai0S5ry4",
//         authDomain: "mid-term-ff345.firebaseapp.com",
//         projectId: "mid-term-ff345",
//         storageBucket: "mid-term-ff345.appspot.com",
//         messagingSenderId: "559694106928",
//         appId: "1:559694106928:web:8f342da738718520cc38f5",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }

//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
    apiKey: 'AIzaSyAcW3BYiJi_z5k4qExKvSbLyKIwYoM_GyU',
    appId: '1:559694106928:ios:e13018a87fff0e6acc38f5',
    messagingSenderId: '559694106928',
    projectId: 'mid-term-ff345',
    storageBucket: 'mid-term-ff345.appspot.com',
    )
  );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage()
    );
  }
}
