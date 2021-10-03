import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:products_test_app/models/product.dart';
import 'package:products_test_app/models/user.dart';
import 'package:products_test_app/screens/products_page.dart';
import 'package:products_test_app/utilits/constants.dart';
import 'package:unique_identifier/unique_identifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Flutter Demo Product List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _identifier = 'Unknown';
  late Future<Products> _products;
  // late Products products;
  late bool productsListIsReady;

  //this method take the IMEI of the device
  Future<void> initUniqueIdentifierState() async {
    String identifier;
    try {
      identifier = (await UniqueIdentifier.serial)!;
      //Initializing user with IMEI code of device
      initUser(identifier);
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier;
    });
  }

  Future<Products> initProducts() async {
    var url =
        Uri.parse('https://products-flutter-rest-api.herokuapp.com/products');

    var uriResponse = await http.get(url);
    // print(uriResponse.body);
    var test_products = jsonDecode(uriResponse.body);
    var products = productsFromJson(uriResponse.body);
    print(uriResponse.statusCode);
    return products;
  }

  @override
  void initState() {
    // TODO: implement initState
    initUniqueIdentifierState();
    _products = initProducts();
    // print(_products);
    super.initState();
  }

  //to init user using an ID to checking status (new or old)
  //at the database
  Future<void> initUser(String id) async {
    var url = Uri.parse(mURL + '/user');
    try {
      var uriResponseGet = await http.get(url);
      print(uriResponseGet.body);
      var uriResponsePost = await http.post(url,
          body: userToJson(User(id: id)),
          headers: {"Content-Type": "application/json"});
      print(uriResponsePost.body);
      print(uriResponsePost.statusCode);
    } catch (e) {
      print(e.toString());
    }
  }

  //check the user in database

  // Future<void> checkUser(String id) async {}

  void _getImeiNumber() {}

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white70,
      body: (_identifier == 'Unknown')
          ? const Center(
              child: Text(
                'Problem to fetch identifier',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            )
          : FutureBuilder(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ProductsPage(
                      screenSize: MediaQuery.of(context).size,
                      userId: _identifier,
                      products: snapshot.data);
                } else if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                        child: Text(
                      'Please try again error in server connection',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    )),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
    );
  }
}
