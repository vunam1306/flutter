import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:midterm/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Details extends StatefulWidget {
  final String imageUrl, productName, productDescription;
  final double productPrice;
  final String userId;
  final String name;
  final String phone;

  Details({
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
    required this.productDescription, 
    required this.userId, required this.name, required this.phone,
  });

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

   @override
  void initState() {
    super.initState();
    // Initialize name and userId from the widget
    userId = widget.userId;
  }

  double quantity = 0;
  double total = 0.0;
  String name = '';
  String phone = '';
  String userId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
              ),
            ),
            Image.network(
              widget.imageUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 15.0),
            Text(
              widget.productName,
              style: AppWidget.SemiBoldTextFeildStyle(),
            ),
            const SizedBox(height: 10.0),            
            Text(
              widget.productDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppWidget.SmallTextFeildStyle(),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      quantity--;
                      total = widget.productPrice * quantity;
                    }
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Text(
                  quantity.toInt().toString(),
                  style: AppWidget.SemiBoldTextFeildStyle(),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    quantity++;
                    total = widget.productPrice * quantity;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30.0),
            Row(
              children: [
                Text(
                  "Free Delivery",
                  style: AppWidget.SemiBoldTextFeildStyle(),
                ),
                const SizedBox(width: 25.0),
                const Icon(
                  Icons.delivery_dining_sharp,
                  color: Colors.black,
                ),
                const SizedBox(width: 5.0),
                Text(
                  "1-2 day",
                  style: AppWidget.SemiBoldTextFeildStyle(),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.SemiBoldTextFeildStyle(),
                      ),
                      Text(
                        "\$" + total.toStringAsFixed(2),
                        style: AppWidget.HeadLineTextFeildStyle(),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance.collection('cart').add({
                        "id": userId,
                        "Name": widget.productName,
                        "Quantity": quantity.toInt(),
                        "Total": total.toInt(),
                        "Image": widget.imageUrl,
                        "Price": widget.productPrice,
                      });
                      // Code to add product to Firestore (update with your method)
                      // await DatabaseMethods().addProductToCart(productToAdd, userId!);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.orangeAccent,
                        content: Text(
                          "Product Added to Cart",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Add to cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 30.0),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}