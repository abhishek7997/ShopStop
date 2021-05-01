import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class Item with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  File image;
  String imageUrl;
  String seller;
  bool isFavorite = false;

  Item({
    this.id,
    this.title,
    this.description,
    this.price,
    this.image,
    this.seller,
    this.isFavorite,
  });

  // ignore: non_constant_identifier_names
  String get Id => id;
  String get Title => title;
  String get Description => description;
  String get Seller => seller;
  double get Price => price;
  File get Image => image;
  bool get getFavorite => isFavorite;

  set setImage(File img) {
    image = img;
    notifyListeners();
  }

  set setTitle(String title) {
    title = title;
  }

  set setId(String uid) {
    id = uid;
  }

  set setFavourite(bool isFav) {
    isFavorite = isFav;
    notifyListeners();
  }

  void toggleFavourite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'seller': seller,
        'image': base64Encode(image.readAsBytesSync()),
        'isFavorite': isFavorite ?? false,
      };
}
