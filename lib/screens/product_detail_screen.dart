import 'package:flutter/material.dart';
import '../providers/item.dart';
import 'package:firebase_auth/firebase_auth.dart';

User loggedInUser;

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    final Item item = ModalRoute.of(context).settings.arguments as Item;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.Title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.file(item.Image),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                "Product ID : ${item.Id}",
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${item.Title}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Seller: ${item.Seller}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: showMore ? 512.0 : 200.0,
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            elevation: 6.0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  '${item.Description}',
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: TextButton(
                          child:
                              showMore ? Text('Show Less') : Text('Show More'),
                          onPressed: () {
                            setState(() {
                              showMore = !showMore;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Price: \u20B9 ${item.Price}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
