import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:products_test_app/models/order.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var _identifier;
  var orderList;

  @override
  void initState() {
    // TODO: implement
    _identifier = widget.userId;
    getOrders(_identifier);
    super.initState();
  }

  Future<void> getOrders(String userId) async {
    var url = Uri.parse(
        'https://products-flutter-rest-api.herokuapp.com/orders/$userId');
    try {
      var uriResponse = await http.get(url);

      orderList = ordersFromJson(uriResponse.body);
      print(uriResponse.body);
      print(uriResponse.statusCode);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return Card(
        child: ListTile(
          title: Text('Order no ${orderList[index].id}'),
          subtitle: Text('Product ${orderList[index].product_id}'),
        ),
      );
    });
  }
}
