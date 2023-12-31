import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          backgroundColor: Colors.blue[300],
          title: const Text('Products'),
          centerTitle: true,
        ),
        body: ItemList());
  }
}

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final String apiUrl =
      'http://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline';

  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            _showDetails(context, index);
          },
          child: ListTile(
              leading: Image.network(data[index]['image_link']),
              title: Text(data[index]['name'])),
        );
      },
    );
  }

  void _showDetails(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                data[index]['image_link'],
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    padding: const EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(data[index]['name'], softWrap: true)),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    data[index]['description'],
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ]),
              Column(
                children: [
                  Text('yo'),
                  const SizedBox(width: 10),
                  Text('yo'),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
