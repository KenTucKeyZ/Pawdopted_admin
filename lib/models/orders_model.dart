import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String productId;
  final String productTitle;
  final String imageUrl;
  final String orderDate;
  final double price;
  final double totalPrice;
  final int quantity;
  final String userId;
  final String userName;

  OrderModel({
    required this.orderId,
    required this.productId,
    required this.productTitle,
    required this.imageUrl,
    required this.orderDate,
    required this.price,
    required this.totalPrice,
    required this.quantity,
    required this.userId,
    required this.userName,
  });

  factory OrderModel.fromFirestore(dynamic doc) {
    // Convert Timestamp to String
    String formatDate(dynamic timestamp) {
      if (timestamp is Timestamp) {
        DateTime dateTime = timestamp.toDate();
        // Format the date as you prefer
        return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      }
      return timestamp.toString();
    }

    return OrderModel(
      orderId: doc['orderId'] ?? '',
      productId: doc['productId'] ?? '',
      productTitle: doc['productTitle'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      orderDate:
          formatDate(doc['orderDate']), // Convert Timestamp to formatted string
      price: (doc['price'] ?? 0).toDouble(),
      totalPrice: (doc['totalPrice'] ?? 0).toDouble(),
      quantity: doc['quantity'] ?? 0,
      userId: doc['userId'] ?? '',
      userName: doc['userName'] ?? '',
    );
  }
}
