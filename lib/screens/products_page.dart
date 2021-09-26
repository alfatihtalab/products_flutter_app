import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:products_test_app/models/order.dart';
import 'package:products_test_app/models/product.dart';
import 'package:unique_identifier/unique_identifier.dart';

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
      var uriResponse = await http.post(url,
          body: orderToJson(
              Order(userId: userId, productId: productId, productCount: count)),
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(productsList[index].name),
          subtitle: Text('price: ${productsList[index].price.toString()} \$'),
          leading: Image.network(productsList[index].url),
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
    );
  }
}
