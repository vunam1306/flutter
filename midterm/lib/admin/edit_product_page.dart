import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditProductPage extends StatefulWidget {
  final DocumentSnapshot? product;

  const EditProductPage({Key? key, this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  String? _selectedType;

  final List<String> _productTypes = ['iPhone', 'Laptop', 'Air Pod', 'Watch'];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['Name'];
      _selectedType = widget.product!['Type'];
      _descriptionController.text = widget.product!['Description'];
      _priceController.text = widget.product!['Price'].toString();
      _imageUrl = widget.product!['Image'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      await _uploadImage();
      final productData = {
        'Name': _nameController.text,
        'Type': _selectedType,
        'Description': _descriptionController.text,
        'Price': double.parse(_priceController.text),
        'Image': _imageUrl,
      };

      if (widget.product == null) {
        // Add new product
        await FirebaseFirestore.instance.collection('products').add(productData);
      } else {
        // Update existing product
        await FirebaseFirestore.instance.collection('products').doc(widget.product!.id).update(productData);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: _productTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _imageFile != null
                  ? Image.file(_imageFile!)
                  : _imageUrl != null
                      ? Image.network(_imageUrl!)
                      : const Text('No image selected'),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(widget.product == null ? 'Add Product' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
