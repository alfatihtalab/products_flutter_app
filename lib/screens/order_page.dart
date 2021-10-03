import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:products_test_app/models/order.dart';
import 'package:products_test_app/utilits/constants.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var _identifier;
  var totalCounts = 0;
  var totalPrice;
  var _orders;
  var orderList;
  late Orders o;

  // this is fake orders
  // var orderList = [
  //   Order(
  //       userId: '1',
  //       productId: '25455af',
  //       productCount: 5,
  //       productPrice: 150,
  //       id: 1),
  //   Order(
  //       userId: '1',
  //       productId: '25455af',
  //       productCount: 5,
  //       productPrice: 150,
  //       id: 1),
  //   Order(
  //       userId: '1',
  //       productId: '25455af',
  //       productCount: 5,
  //       productPrice: 150,
  //       id: 1),
  //   Order(
  //       userId: '1',
  //       productId: '25455af',
  //       productCount: 5,
  //       productPrice: 150,
  //       id: 1),
  // ];

  @override
  void initState() {
    // TODO: implement
    _identifier = widget.userId;
    _orders = getOrders();
    // o = _orders;
    // print(o);
    // orderList = List.of(o.orders);

    super.initState();
  }

  //getOrders method to fetching an orders belongs to user ID from the database
  Future<Orders> getOrders() async {
    _identifier = widget.userId;
    var url = Uri.parse(mURL + '/orders/$_identifier');
    // try {
    var uriResponse = await http.get(url);

    //to fetch orders from an database
    //TODO implementing read operation from the json
    //TODO >> cont>> body and parse it into List of Orders
    //orderList = ordersFromJson(uriResponse.body);
    print(uriResponse.body);
    var orders = Orders.fromJson(jsonDecode(uriResponse.body));
    print(orders);
    return orders;
    print(uriResponse.statusCode);
    // } catch (e) {
    //   print(e.toString());
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: _orders,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                orderList = snapshot.data.orders;
                return ListView.builder(
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(orderList[index].productId +
                              '\n' +
                              orderList[index].productCount.toString()),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error_outline),
                        Text('Error! can\'t fetching data please try again'),
                      ],
                    ),
                    MaterialButton(
                        onPressed: () {}, child: Icon(Icons.refresh_outlined))
                  ],
                ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
