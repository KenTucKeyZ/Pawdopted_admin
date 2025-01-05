// order_provider.dart
import 'package:adoptsmart_admin_en/models/orders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> orders = [];

  final ordersDb = FirebaseFirestore.instance.collection("ordersAdvanced");

  Stream<List<OrderModel>> fetchOrdersStream() {
    try {
      return ordersDb.snapshots().map((snapshot) {
        orders.clear();
        for (var element in snapshot.docs) {
          orders.insert(0, OrderModel.fromFirestore(element));
        }
        return orders;
      });
    } catch (e) {
      rethrow;
    }
  }

  List<OrderModel> searchQuery({
    required String searchText,
    required List<OrderModel> passedList,
  }) {
    List<OrderModel> searchList = passedList
        .where(
          (element) => element.productTitle.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return searchList;
  }
}
