import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CoffeeList(),
    );
  }
}

class CoffeeList extends StatefulWidget {
  const CoffeeList({super.key});

  @override
  State<CoffeeList> createState() => _CoffeeListState();
}

class _CoffeeListState extends State<CoffeeList> {
  List? _coffees;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var dio = Dio(BaseOptions(responseType: ResponseType.plain));
              var response =
                  await dio.get('https://api.sampleapis.com/coffee/hot');

              setState(() {
                _coffees = jsonDecode(response.data.toString());
              });

              print(_coffees);
            },
            child: Text('Get Coffee'),
          ),
          Expanded(
            child: _coffees == null
                ? SizedBox.shrink()
                : ListView.builder(
                    itemCount: _coffees!.length,
                    itemBuilder: (context, index) {
                      var coffee = _coffees![index];

                      return ListTile(
                        title: Text(coffee['title']),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(coffee['title']),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Image.network(
                                          coffee['image'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.error,
                                                color: Colors.red);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                        'Description: ${coffee['description']}'),
                                    SizedBox(height: 10),
                                    Text(
                                      'Ingredients:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: coffee['ingredients']
                                          .map<Widget>((ingredient) =>
                                              Text('- $ingredient'))
                                          .toList(),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
