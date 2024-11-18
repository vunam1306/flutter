import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:midterm/pages/details.dart';
import 'package:midterm/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String name;
  final String userId;
  final String phone;
  Home({required this.name, required this.userId, required this.phone}); // Constructor updated

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    // Initialize name and userId from the widget
    name = widget.name;
    userId = widget.userId;
    phone = widget.phone;
  }

  String selectedType = 'iPhone';
  String name = '';
  String userId = '';
  String phone = '';
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 10, left: 20.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello, $name",
                  style: AppWidget.boldTextFeildStyle(),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              "Tech Zone",
              style: AppWidget.HeadLineTextFeildStyle(),
            ),
            Text(
              "Smart Choices for Smart Devices",
              style: AppWidget.LightTextFeildStyle(),
            ),
            const SizedBox(height: 20.0),
            showItem(),
            const SizedBox(height: 30.0),
            Expanded(
             child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .where('Type', isEqualTo: selectedType)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data!.docs[index];
                      var imageUrl = product['Image'];
                      var productName = product['Name'];
                      var productPrice = product['Price'];
                      var productDescription = product['Description'];

                      return GestureDetector(
                        onTap: () {
                          // Handle onTap event, e.g., navigate to details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(
                                imageUrl: imageUrl,
                                productName: productName,
                                productPrice: productPrice,
                                productDescription: productDescription,
                                userId: userId,
                                name: name,
                                phone: phone // Pass userId to details page
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: Material(
                            color: Colors.white,
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Image.network(
                                    imageUrl,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    productName,
                                    style: AppWidget.SmallTextFeildStyle(),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    '\$${productPrice.toStringAsFixed(2)}',
                                    style: AppWidget.SmallTextFeildStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget showItem() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () {
          setState(() {
            selectedType = 'iPhone'; // Update selected type to 'iPhone'
          });
        },
        child: buildFilterIcon("images/iphoneicon.webp", "iPhone"),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedType = 'Laptop'; // Update selected type to 'Laptop'
          });
        },
        child: buildFilterIcon("images/laptopicon.webp", "Laptop"),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedType = 'Air Pod'; // Update selected type to 'Air Pod'
          });
        },
        child: buildFilterIcon("images/airpodicon.webp", "Air Pod"),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            selectedType = 'Watch'; // Update selected type to 'Watch'
          });
        },
        child: buildFilterIcon("images/watchicon.webp", "Watch"),
      ),
    ],
  );
}

Widget buildFilterIcon(String imagePath, String type) {
  bool isSelected = selectedType == type; // Check if the current type is selected

  return Material(
    elevation: 5.0,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white, // Background color changes on selection
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(
        imagePath,
        height: 45,
        width: 45,
        fit: BoxFit.cover,
        color: isSelected ? Colors.white : Colors.black, // Icon color changes on selection
      ),
    ),
  );
}
}