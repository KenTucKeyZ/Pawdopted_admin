import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductModel> products = [];
  List<ProductModel> get getProducts {
    return products;
  }

  ProductModel? findByProdId(String productId) {
    if (products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    return products.firstWhere((element) => element.productId == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    List<ProductModel> categoryList = products
        .where(
          (element) => element.productCategory.toLowerCase().contains(
                categoryName.toLowerCase(),
              ),
        )
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    List<ProductModel> searchList = passedList
        .where(
          (element) => element.productTitle.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return searchList;
  }

  final productDb = FirebaseFirestore.instance.collection("products");
  Future<List<ProductModel>> fetchProducts() async {
    try {
      await productDb.get().then((productSnapshot) {
        products.clear();
        // products = []
        for (var element in productSnapshot.docs) {
          products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchProductsStream() {
    try {
      return productDb.snapshots().map((snapshot) {
        products.clear();
        // products = []
        for (var element in snapshot.docs) {
          products.insert(0, ProductModel.fromFirestore(element));
        }
        return products;
      });
    } catch (e) {
      rethrow;
    }
  }

  /*List<ProductModel> products = [
    // Phones -> dogs
    ProductModel(
      //1
      productId: 'Golden Retriever Dog',
      productTitle: "Marcellinus the Golden Retriever",
      productPrice: "10.00",
      productCategory: "Dogs",
      productDescription: "He is a good dog",
      productImage:
          "https://th.bing.com/th/id/OIP.QzyqUQtFs8ehWLHtERm_bwHaGf?w=216&h=190&c=7&r=0&o=5&pid=1.7",
      productQuantity: "1",
    ),
    ProductModel(
      //2
      productId: 'Bulldog Dog',
      productTitle: "Henry the Bulldog",
      productPrice: "10.99",
      productCategory: "Dogs",
      productDescription: "Good bulldog.",
      productImage:
          "https://live.staticflickr.com/65535/49635403906_de7d5caa13_n.jpg",
      productQuantity: "1",
    ),
    // Laptops -> cats
    // https://i.ibb.co/MDcGHsb/12-ASUS-ROG-Zephyrus-G15.jpg
    ProductModel(
      //12
      productId: const Uuid().v4(),
      productTitle: "Surya the Munchkin",
      productPrice: "50.99",
      productCategory: "Cats",
      productDescription: "he is very cute",
      productImage:
          "https://th.bing.com/th/id/R.6e85b931ef98f8e452b84ba2af92dba2?rik=ZtqxCvnVC5E35w&riu=http%3a%2f%2f4.bp.blogspot.com%2f-W1aPa00cyrM%2fTyJY_nQak9I%2fAAAAAAAAH3Y%2feSjlVvLmwAc%2fs1600%2f%2525D8%2525B3%2525D9%252583%2525D9%252588%2525D9%252583%2525D9%252585%2bSkookum.jpg&ehk=xzuOpQqrFzQMPcOyeDCBuIcVTSJ5R5UCnED%2bDECWHHw%3d&risl=&pid=ImgRaw&r=0",
      productQuantity: "1",
    ),
    ProductModel(
      //13
      productId: const Uuid().v4(),
      productTitle: "Hans and Sherryn the munchkin",
      productPrice: "20.99",
      productCategory: "Cats",
      productDescription: "Both are very cute, you can choose one",
      productImage:
          "https://th.bing.com/th/id/OIP.FKJyQbwITXRyvfKZsBrotQAAAA?w=198&h=159&c=7&r=0&o=5&pid=1.7",
      productQuantity: "2",
    ),

    // WATCHES->Birds
    ProductModel(
      //16
      productId: const Uuid().v4(),
      productTitle: "Kenrick the Lovebird",
      productPrice: "100.99",
      productCategory: "Birds",
      productDescription: "Birds the best.",
      productImage:
          "https://th.bing.com/th/id/R.30a9020a939a6a8b839328e84d4f554b?rik=%2bqmUa34XGMfLvw&riu=http%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2fe%2fe6%2fMasked_Lovebird_(Agapornis_personata)_-Auckland_Zoo.jpg&ehk=yBrHhRtqLpJjyPKqnqtK47O04WK7v5ZgBFjQt6NCcmY%3d&risl=&pid=ImgRaw&r=0",
      productQuantity: "1",
    ),

    // SHOES -> Fish
    ProductModel(
      //20
      productId: const Uuid().v4(),
      productTitle: "Betta fishes",
      productPrice: "1.88",
      productCategory: "Fish",
      productDescription: "Get multiple betta fish here.",
      productImage:
          "https://live.staticflickr.com/3083/3176135732_5e0f07f54f_b.jpg",
      productQuantity: "100",
    ),

    // Clothes-> Turtles
    ProductModel(
      //29
      productId: const Uuid().v4(),
      productTitle: "Gerald the Sulcata Turtles",
      productPrice: "40.75",
      productCategory: "Turtles",
      productDescription: "cute turtle and smart",
      productImage:
          "https://live.staticflickr.com/6003/6006388423_1d7240b1c3_b.jpg",
      productQuantity: "1",
    ),
  ];*/
}
