import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:products_test_app/models/order.dart';
import 'package:products_test_app/models/product.dart';
import 'package:unique_identifier/unique_identifier.dart';

import 'order_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage(
      {Key? key,
      required this.screenSize,
      required this.userId,
      required this.products})
      : super(key: key);

  final Size screenSize;
  final String userId;
  final Object? products;

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  var screenSize;
  var maxHeight;
  var maxWidth;
  var userId;
  var products;
  var productsList;
  var _identifier;

  @override
  void initState() {
    // TODO: implement initState
    initUniqueIdentifierState();
    screenSize = widget.screenSize;
    userId = widget.userId;
    maxHeight = screenSize.height;
    maxWidth = screenSize.width;
    // initProduct();
    products = widget.products as Products;
    print(products.products);
    productsList = List.of(products.products);
    super.initState();
  }

  Future<void> addOrder(String userId, String productId, int count) async {
    var url =
        Uri.parse('https://products-flutter-rest-api.herokuapp.com/order');
    try {
      //the product count, id and the productPrice is fake
      //in api request python doesn't parse it
      var uriResponse = await http.post(url,
          body: orderToJson(Order(
            userId: userId,
            productId: productId,
            productCount: 1,
            id: 1,
            productPrice: 105.0,
          )),
          headers: {"Content-Type": "application/json"});

      print(uriResponse.body);
      print(uriResponse.statusCode);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> initUniqueIdentifierState() async {
    String identifier;
    try {
      identifier = (await UniqueIdentifier.serial)!;
      //Initializing user with IMEI code of device
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
    // var test_products = jsonDecode(uriResponse.body);
    var products = productsFromJson(uriResponse.body);
    print(uriResponse.statusCode);
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(productsList[index].name),
                    subtitle: Text(
                        'price: ${productsList[index].price.toString()} \$'),
                    leading: GestureDetector(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (_) => ImageDialog(
                                    src: productsList[index].url,
                                    productName: productsList[index].name,
                                    price: productsList[index].price,
                                  ));
                        },
                        child: Image.network(productsList[index].url)),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        var productId = productsList[index].id.toString();
                        await addOrder(_identifier, productId, 1);
                        Fluttertoast.showToast(msg: 'product has been added');
                      },
                      child: const Icon(Icons.add),
                    ),
                  ));
                },
                itemCount: productsList.length,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OrderPage(userId: _identifier);
                }));
              },
              child: const Text('Go to orders'),
              style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all(const EdgeInsets.all(20.0)),
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 20.0))),
            ),
          )
        ],
      ),
      margin: const EdgeInsets.only(bottom: 5.0),
    );
  }

  Future<void> _pullRefresh() async {
    products = await initProducts();
    setState(() {
      // print(products.products);
      productsList = List.of(products.products);
    });
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog(
      {Key? key,
      required this.src,
      required this.price,
      required this.productName})
      : super(key: key);

  final String src;
  final double price;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(src), fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  productName,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Price: $price \$',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
      elevation: 10.2,
    );
  }
}
