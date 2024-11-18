import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:midterm/widget/widget_support.dart';
import 'package:midterm/widget/widget_support.dart';

class OrderComplete extends StatefulWidget {
  final String userId;
  final String name;
  final String phone;
  const OrderComplete({super.key, required this.userId, required double totalPrice, required this.name, required this.phone});

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  String userId = '';
  double finalTotal = 0.0;
  double shippingFee = 10.0;
  String name = '';
  String phone = '';
  String address = '470 Trần Đại Nghĩa, Ngũ Hành Sơn, Đà Nẵng'; // Default address

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    name = widget.name;
    phone = widget.phone;

    // Retrieve user address from Firestore or set default
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((doc) {
      if (doc.exists) {
        setState(() {
          address = doc['address'] ?? '470 Trần Đại Nghĩa, Ngũ Hành Sơn, Đà Nẵng';         
        });
      }
    });
  }

  Future<void> placeOrder(List<DocumentSnapshot> cartItems, double totalPrice) async {
    try {
      // Prepare the order details
      Map<String, dynamic> orderData = {
        'userId': userId,
        'name': name,
        'phone': phone,
        'address': address,
        'cartItems': cartItems.map((item) {
          return {
            'name': item['Name'],
            'quantity': item['Quantity'],
            'total': item['Total'],
            'image': item['Image'],
          };
        }).toList(),
        'totalPrice': totalPrice,
        'orderDate': Timestamp.now(),
      };

      // Save the order to the 'orders' collection
      await FirebaseFirestore.instance.collection('orders').add(orderData);

      // Show a success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );

      // Optionally, clear the cart after placing the order
      // This requires deleting cart items in Firestore
      for (var item in cartItems) {
        await item.reference.delete();
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Complete'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('id', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          List<DocumentSnapshot> cartItems = snapshot.data!.docs;

          // Reset total each time the cart data is updated
          finalTotal = 0.0;

          // Calculate finalTotal after updating finalTotal
          for (var item in cartItems) {
            double total = item['Total'].toDouble();
            finalTotal += total;
          }

          double totalPrice = finalTotal + shippingFee;

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    String name = item['Name'];
                    String image = item['Image'];
                    int quantity = item['Quantity'];
                    double total = item['Total'].toDouble();

                    return Card(
                      color: Colors.white,
                      elevation: 10,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // Set corners to be square
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0), // Add padding top and bottom
                        child: ListTile(
                          leading: Image.network(
                            image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: AppWidget.SmallTextFeildStyle()),
                              Text("Quantity: $quantity", style: AppWidget.SmallTextFeildStyle()),
                            ],
                          ),
                          trailing: Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: AppWidget.SmallTextFeildStyle(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shipping Address",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: TextEditingController(text: address),
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Address', hintStyle: AppWidget.SmallBoldTextFeildStyle(),          
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Order Summary",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Shipping Fee:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${shippingFee.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sub Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${finalTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Final Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),                            
                          ),                         
                        ],
                      ),                     
                    ],
                  ),
                ),  
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Payment Method",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),  
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on, // Icon representing money
                        size: 24, // Adjust the size as needed
                        color: Colors.black, // Adjust the color as needed
                      ),
                      const SizedBox(width: 8), // Space between the icon and text
                      Text(
                        "Cash On Delivery",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
         
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Call the placeOrder method
                        placeOrder(cartItems, totalPrice);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                      ),
                      child: Center(
                        child: Text(
                          "Place Order",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
