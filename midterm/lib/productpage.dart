import 'package:flutter/material.dart';


class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cyber'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/cyber_logo.png', // Replace with your logo asset
              height: 30,
            ),
            const SizedBox(width: 10),
            Text(widget.title),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {}, // Add your action here
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {}, // Add your filter logic here
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filters'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: 'By rating', // Default value
                    icon: const Icon(Icons.arrow_drop_down),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String? newValue) {
                      // Update the dropdown value
                      setState(() {});
                    },
                    items: <String>['By rating', 'By price']
                        .map<DropdownMenuItem<String>>((String value) {
                       return DropdownMenuItem<String>(
                         value: value,
                         child: Text(value),
                       );
                     }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0, 
                mainAxisSpacing: 20.0,
              ),
              itemCount: 10, // Replace with your data length
              itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: Text('Item $index'), // Replace with your item data
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}