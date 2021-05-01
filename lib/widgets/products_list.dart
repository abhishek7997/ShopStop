import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

// void getCurrentUser() async {
//   try {
//     final user = _auth.currentUser;
//     if (user != null) {
//       loggedInUser = user;
//       print(loggedInUser.email);
//     }
//   } catch (e) {
//     print(e);
//   }
// }

class ProductsList extends StatefulWidget with ChangeNotifier {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final _stream = _firestore
      .collection('items')
      .orderBy("id", descending: true)
      .snapshots();

  Stream<List<Item>> lops;

  Future<File> _createFileFromString(String encodedStr) async {
    Uint8List bytes = base64Decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<Item> generateList(pt) async {
    File image = await _createFileFromString(pt['image']);
    final id = pt['id'];
    final title = pt['title'];
    final description = pt['description'];
    final isFavorite = pt['isFavorite'];
    final seller = pt['seller'];
    final price = pt['price'];
    return Item(
      id: id,
      title: title,
      description: description,
      price: price,
      image: image,
      seller: seller,
      isFavorite: isFavorite,
    );
  }

  void initState() {
    lops = _stream.asyncMap((products) =>
        Future.wait([for (var pt in products.docs) generateList(pt)]));
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //getCurrentUser();
    //var potholesData = Provider.of<Items>(context);
    return StreamBuilder<List<Item>>(
      stream: lops,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print("No data yet");
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: snapshot.data.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              // builder: (c) => products[i],
              value: snapshot.data[i],
              child: ProductItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        }
      },
    );
  }
}
