import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_product_page.dart';

class HomePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      
      body: StreamBuilder(
  stream: _firestore.collection('products').snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    // Kiểm tra nếu dữ liệu chưa tải xong hoặc gặp lỗi
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(child: Text('No products found'));
    }

    var products = snapshot.data!.docs;
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        var product = products[index];
        return ListTile(
          title: Text(product['Name']),
          subtitle: Text('Type: ${product['Type']}, Price: \$${product['Price']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductPage(product: product),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _firestore.collection('products').doc(product.id).delete();
                },
              ),
            ],
          ),
        );
      },
    );
  },
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProductPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
