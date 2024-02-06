import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_test/user.dart';

import 'beer.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> getLatestNews() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => 'Latest News',
    );
  }
  Future<List<Beer>> getAllBeers() async {
    var response = await http.get(Uri.https('api.punkapi.com', 'v2/beers'));
    if(response.statusCode == 200) {
      var beers = beerFromJson(response.body);
      return beers;
    } else {
      throw Exception('Failed to load beer');
    }
  }
  // Future<List<User>> getAllUsers() async {
  //   var response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
  //   if(response.statusCode == 200) {
  //     var users = (jsonDecode(response.body) as List).map((user) => User.fromJson(user)).toList();
  //     return users;
  //   } else {
  //     throw Exception('Failed to load user');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: getAllBeers(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length,
                // itemCount: 2,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    title: Text(
                      data[index].name!,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    subtitle: const Text('this is subtitle'),
                    leading: Image.network(data[index].imageUrl),

                    // leading: CircleAvatar(
                    //   child: Text(
                    //     data[index].name!.substring(0, 1),
                    //     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    // ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              );
            } else if(snapshot.connectionState == ConnectionState.waiting) {
                return Text(snapshot.data.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
