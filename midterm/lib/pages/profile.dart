import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class Profile extends StatefulWidget {
  final String userId;
  final String name;
  final String phone;
  final String email;

  const Profile({
    super.key,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';
  final String defaultProfileImage = 'images/profile.jpg';

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
  }

 Future<void> _changePassword(String email, String userId) async {
  TextEditingController newPasswordController = TextEditingController();
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Change Password"),
        content: TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: InputDecoration(hintText: "Enter new password"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                String newPassword = newPasswordController.text.trim();
                
                if (newPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password cannot be empty")),
                  );
                  return;
                }

                // Update the password using Firebase Auth
                await FirebaseAuth.instance.currentUser
                    ?.updatePassword(newPassword);

                // Update the password in Firestore for the corresponding user document
                await FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: email)
                    .get()
                    .then((querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        querySnapshot.docs.first.reference.update({
                          'password': newPassword,
                        });
                      }
                    });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Password updated successfully")),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update password: $e")),
                );
              }
            },
            child: Text("Confirm"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      );
    },
  );
}


  Future<void> _deleteAccount(String userId, String email) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Delete user document in Firestore
      await FirebaseFirestore.instance
            .collection('users')
            .where("userId", isEqualTo: widget.userId)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
      // Delete user authentication
      await currentUser.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account deleted successfully")),
      );
      // Navigate back to LoginPage
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to delete account: $e")),
    );
  }
}

void _logout() {
  FirebaseAuth.instance.signOut();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Logged out successfully")),
  );
  // Navigate back to LoginPage
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginPage()),
    (Route<dynamic> route) => false,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Failed to load user data",
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          var userDoc = snapshot.data!.docs.first;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile UI...
            Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    // Profile image and Name section
                    // Container(
                    //   padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                    //   height: MediaQuery.of(context).size.height / 4.3,
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     color: Colors.black,
                    //     borderRadius: BorderRadius.vertical(
                    //       bottom: Radius.elliptical(
                    //           MediaQuery.of(context).size.width, 105.0),
                    //     ),
                    //   ),
                    // ),
                    Center(
                      child: Container(
                        // margin: EdgeInsets.only(
                            // top: MediaQuery.of(context).size.height / 6.5),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(60),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset(
                              defaultProfileImage, // Display the default image
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 70.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   name,
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 23.0,
                          //     fontWeight: FontWeight.bold,
                          //     fontFamily: 'Poppins',
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // User Info Section
                userInfoTile("Name", name),
                const SizedBox(height: 20.0),
                userInfoTile("Email", email),
                const SizedBox(height: 20.0),

                actionButton("Change Password", Colors.orange, () => _changePassword(widget.email, widget.userId)),
                const SizedBox(height: 20.0),
                actionButton("Delete Account", Colors.red, _deleteAccount),
                const SizedBox(height: 20.0),
                actionButton("Logout", Colors.blue, _logout),
              ],
            ),
          ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget userInfoTile(String title, String content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.black),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget actionButton(String title, Color color, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  title == "Logout"
                      ? Icons.logout
                      : title == "Delete Account"
                          ? Icons.delete
                          : Icons.lock,
                  color: color,
                ),
                SizedBox(width: 20.0),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
