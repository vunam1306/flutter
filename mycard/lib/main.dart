import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage('images/download.jpeg'),
            ),
            const Text('Vu Phuong Nam',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold ,
                color: Colors.white, fontFamily: 'Pacifico',),
            ),
            SizedBox(
              height: 20.0,
              child: Divider(
                color: Colors.indigo.shade700,
              ),
            ),
            const Card(
              margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),

              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child:Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('+84 867077565',key: Key('phoneNumber'),),
                  ],
                ),
              ),
            ),
            const Card(
              margin: EdgeInsets.symmetric(vertical: 2.0,horizontal: 50.0),

              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('vunam13069@gmail.com'),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('See other details'),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SecondScreen()));
              },),

          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      backgroundColor: Colors.teal,
      body:Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('go back'),
        ),
      ),
    );
  }
}