import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';
import '../providers/item.dart';
import '../providers/price.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser = _auth.currentUser;

class CartItem extends StatefulWidget {
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var product, priceProvider;
  TextEditingController controller;

  void subQuantity() {
    if (int.parse(controller.text) > 1) {
      controller.text = (int.parse(controller.text) - 1).toString();
      priceProvider.subtract(product.Price);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('There must be at least one type of the item!'),
        ),
      );
    }
  }

  void addQuantity() {
    if (int.parse(controller.text) < 50) {
      controller.text = (int.parse(controller.text) + 1).toString();
      priceProvider.add(product.Price);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('Maximum amount exceeded!'),
        ),
      );
    }
  }

  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.text = '1';
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    product = Provider.of<Item>(context, listen: false);
    priceProvider = Provider.of<Price>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFd8e2dc),
            borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
          trailing: IconButton(
            icon: Icon(
              Icons.delete_forever_rounded,
              size: 45.0,
            ),
            onPressed: () {
              _firestore
                  .collection(loggedInUser.email)
                  .doc(product.Id)
                  .delete();
              priceProvider.resetPrice();
            },
          ),
          title: Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                //padding: EdgeInsets.symmetric(vertical: 5.0),
                // height: double.infinity,
                alignment: Alignment.center,
                child: Image.file(
                  product.Image,
                  fit: BoxFit.contain,
                  width: 65,
                  height: 95,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 185.0,
                      child: Text(
                        "${product.Title}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        "\u20B9 ${product.Price}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: 75,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Color(0xff75c6b6),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 8,
                              color: Colors.black26,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            onTap: addQuantity,
                            child: const Icon(Icons.add),
                          ),
                          Expanded(
                              child: TextField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            readOnly: true,
                            controller: controller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.all(0)),
                          )),
                          GestureDetector(
                            onTap: subQuantity,
                            child: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: product);
          },
        ),
      ),
    );
  }
}
