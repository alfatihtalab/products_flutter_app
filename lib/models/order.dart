// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.userId,
    required this.productId,
    required this.productCount,
  });

  String userId;
  String productId;
  int productCount;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        userId: json["user_id"],
        productId: json["product_id"],
        productCount: json["product_count"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "product_id": productId,
        "product_count": productCount,
      };
}

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
