import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:midterm/pages/odercomplete.dart';
import 'package:midterm/widget/widget_support.dart';

class Order extends StatefulWidget { 
  final String userId; // User ID passed from the login
  final String name; // User name passed from the login
  final String phone; // User phone passed from the login
  const Order({super.key, required this.userId, required this.name, required this.phone});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String userId = '';
  double finalTotal = 0.0; // Sử dụng double thay vì int

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    name = widget.name;
    phone = widget.phone;
  }

  String phone = '';
  String name = '';
  void updateQuantity(String itemId, int newQuantity, double price) {
    double newTotal = newQuantity * price;
    FirebaseFirestore.instance.collection('cart').doc(itemId).update({
      'Quantity': newQuantity,
      'Total': newTotal,
    }).then((_) {
      setState(() {
        // Cập nhật lại finalTotal sau khi thay đổi quantity
        finalTotal = 0.0;
        FirebaseFirestore.instance
            .collection('cart')
            .where('id', isEqualTo: userId)
            .get()
            .then((querySnapshot) {
          for (var item in querySnapshot.docs) {
            finalTotal += item['Total'].toDouble();
          }
          setState(() {});
        });
      });
    });
  }

  void deleteItem(String itemId) {
    FirebaseFirestore.instance.collection('cart').doc(itemId).delete().then((_) {
      setState(() {
        // Cập nhật lại finalTotal sau khi xóa sản phẩm
        finalTotal = 0.0;
        FirebaseFirestore.instance
            .collection('cart')
            .where('id', isEqualTo: userId)
            .get()
            .then((querySnapshot) {
          for (var item in querySnapshot.docs) {
            finalTotal += item['Total'].toDouble();
          }
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            double total = item['Total'].toDouble(); // Chuyển đổi sang double
            finalTotal += total;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    String id = item.id;
                    String name = item['Name'];
                    String image = item['Image'];
                    int quantity = item['Quantity'];
                    double total = item['Total'].toDouble(); // Chuyển đổi sang double
                    double price = item['Price'].toDouble(); // Chuyển đổi sang double

                    return Card(
                      color: Colors.white,
                      elevation: 10,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
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
                            Text(name, style: AppWidget.SmallBoldTextFeildStyle(),),
                            SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (quantity > 1) {
                                      quantity--;
                                      updateQuantity(id, quantity, price);
                                    }
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
                                const SizedBox(width: 10.0),
                                Text(
                                  quantity.toInt().toString(),
                                  style: AppWidget.SemiBoldTextFeildStyle(),
                                ),
                                const SizedBox(width: 10.0),
                                GestureDetector(
                                  onTap: () {
                                    quantity++;
                                    updateQuantity(id, quantity, price);
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
                          ],
                        ),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "\$${total.toStringAsFixed(2)}",
                              style: AppWidget.SmallTextFeildStyle(),
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(id)
                                    .delete();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Final Total: \$$finalTotal",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle "Order Now" action here
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderComplete(
                                userId: userId,
                                totalPrice: finalTotal,
                                name: name,
                                phone: phone,
                              ),
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Make background transparent to show the container color
                      shadowColor: Colors.transparent, // Remove shadow
                      padding: EdgeInsets.zero, // Remove default padding
                    ),
                    child: Center(
                      child: Text(
                        "Checkout",
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
          );
        },
      ),
    );
  }
}
