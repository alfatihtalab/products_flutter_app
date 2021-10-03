// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  Orders({
    required this.orders,
  });

  List<Order> orders;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.id,
    required this.productCount,
    required this.productId,
    required this.productPrice,
    required this.userId,
  });

  int id;
  int productCount;
  String productId;
  double productPrice;
  String userId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        productCount: int.parse(json["product_count"]),
        productId: json["product_id"],
        productPrice: json["product_price"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_count": productCount,
        "product_id": productId,
        "product_price": productPrice,
        "user_id": userId,
      };
}
