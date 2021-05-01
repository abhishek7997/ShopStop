import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/item.dart';
import '../providers/price.dart';
import '../screens/checkout_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser = _auth.currentUser;

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

class CartList extends StatefulWidget with ChangeNotifier {
  static const routeName = '/cart-page';
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final _stream = _firestore
      .collection(loggedInUser.email)
      .orderBy('price', descending: true)
      .snapshots();
  Stream<List<Item>> lops;
  var priceProvider;

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
    final String id = pt['id'];
    final String title = pt['title'];
    final String description = pt['description'];
    final bool isFavorite = pt['isFavorite'];
    final String seller = pt['seller'];
    final double price = await pt['price'];
    priceProvider.add(price);

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

  void calculatePrice() async {}
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      priceProvider.resetPrice();
    });
    lops = _stream.asyncMap((product) =>
        Future.wait([for (var pt in product.docs) generateList(pt)]));

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getCurrentUser();
    priceProvider = Provider.of<Price>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: 'Proceed to checkout',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.arrow_forward_rounded),
              onPressed: () {
                // Go to checkout page
                if (priceProvider.getPrice > 0.0) {
                  Navigator.of(context).pushNamed(CheckoutPage.routeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('There is no item in cart!'),
                    ),
                  );
                }
              },
            ),
            label: 'Go!',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Item>>(
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: snapshot.data[i],
                      child: CartItem(),
                    ),
                  );
                }
              },
            ),
            Text(
              'Total Price: \u20B9 ${priceProvider.getPrice}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
