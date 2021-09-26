import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  var totalCounts = 0;

  //this is fake orders
  List<Order> orderList = [
    Order(userId: '1', productId: '25455af', productCount: 5),
    Order(userId: '2', productId: 'a885d4', productCount: 2),
    Order(userId: '3', productId: 'ud8145', productCount: 3),
    Order(userId: '4', productId: '55748d', productCount: 5),
    Order(userId: '5', productId: '125548', productCount: 10),
    Order(userId: '1', productId: '698', productCount: 20),
    Order(userId: '7', productId: '93', productCount: 1),
  ];

  @override
  void initState() {
    // TODO: implement
    _identifier = widget.userId;
    getOrders(_identifier);

    //fake totalCouts
    for (var i in orderList) {
      totalCounts = totalCounts + i.productCount;
    }
    super.initState();
  }

  //getOrders method to fetching an orders belongs to user ID from the database
  Future<void> getOrders(String userId) async {
    var url = Uri.parse(
        'https://products-flutter-rest-api.herokuapp.com/orders/$userId');
    try {
      var uriResponse = await http.get(url);

      //to fetch orders from an database
      //TODO implementing read operation from the json body and parse it into List of Orders
      //orderList = ordersFromJson(uriResponse.body);
      print(uriResponse.body);
      print(uriResponse.statusCode);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Order no ${orderList[index].userId}'),
                      subtitle: Text('Product ${orderList[index].productId} \n '
                          'Count: ${orderList[index].productCount} '),
                    ),
                  );
                }),
          ),
          const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Total Count of products: 90 \n '
                  'Total Price: 900.56 \$',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          ElevatedButton(
            onPressed: () {
              Fluttertoast.showToast(msg: 'Submitting orders ');
            },
            child: Text('Submit orders'),
          )
        ],
      ),
    );
  }
}
