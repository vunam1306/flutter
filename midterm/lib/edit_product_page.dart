import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductPage extends StatefulWidget {
  final DocumentSnapshot? product;

  EditProductPage({this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    if (widget.product != null) {
      _nameController.text = widget.product!['Name'];
      _typeController.text = widget.product!['Type'];
      _priceController.text = widget.product!['Price'].toString();
    }
    super.initState();
  }

  void _saveProduct() {
    if (widget.product == null) {
      _firestore.collection('products').add({
        'Name': _nameController.text,
        'Type': _typeController.text,
        'Price': double.parse(_priceController.text),
      });
    } else {
      _firestore.collection('products').doc(widget.product!.id).update({
        'Name': _nameController.text,
        'Type': _typeController.text,
        'Price': double.parse(_priceController.text),
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text(widget.product == null ? 'Add Product' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
