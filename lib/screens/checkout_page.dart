import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/price.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser = _auth.currentUser;

TextEditingController addressController = TextEditingController();

class CheckoutPage extends StatefulWidget with ChangeNotifier {
  static const routeName = '/checkout-page';
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priceProvider = Provider.of<Price>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Enter address to be delivered to',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some value';
                  } else if (double.parse(value) < 0.0) {
                    return 'Please enter some correct value';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              decoration: BoxDecoration(),
              child: Text(
                'Total Amount : ${priceProvider.getPrice}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.green,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    if (addressController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 8),
                          content: Text('Order Made!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text('Please enter a valid address!'),
                        ),
                      );
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Make order',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
