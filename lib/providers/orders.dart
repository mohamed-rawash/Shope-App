import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem{
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  String authToken;
  String userId;

  getData(String token, String uId, List<OrderItem> orders){
    authToken = token;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders{
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {

    final String url = "https://shop-4c6d0-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";

    try{
      final res = await http.get(url);
      final extractData = json.decode(res.body) as Map<String, dynamic>;
      if(extractData == null){
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map((item) =>
                CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
            ),).toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }catch(e){
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final String url = "https://shop-4c6d0-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    try{
      final timeStamp = DateTime.now();
      final res = await http.post(url, body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProduct.map((cartItem) => {
          'id': cartItem.id,
          'title': cartItem.title,
          'quantity': cartItem.quantity,
          'price': cartItem.price,
        }).toList(),
      }));
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            dateTime: timeStamp,
            products: cartProduct,
        ),
      );
      notifyListeners();
    }catch(e){
      throw e;
    }
  }
}