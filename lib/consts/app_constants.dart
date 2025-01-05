import 'package:flutter/material.dart';

class AppConstants {
  static const String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/adoptsmarten.firebasestorage.app/o/productsImages%2FAndy%20the%20bird.jpg?alt=media&token=b26e0a33-c4c0-4f4c-9c2a-b4c0571ec994';

  static List<String> categoriesList = [
    'Dogs',
    'Cats',
    'Fish',
    'Birds',
    'Turtles',
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
      categoriesList.length,
      (index) => DropdownMenuItem(
        value: categoriesList[index],
        child: Text(categoriesList[index]),
      ),
    );
    return menuItem;
  }
}
