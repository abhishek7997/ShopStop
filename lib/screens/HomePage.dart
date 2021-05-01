import 'package:flutter/material.dart';
import '../widgets/products_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/input_screen.dart';
import '../screens/about_screen.dart';
import 'cart_screen.dart';

final _auth = FirebaseAuth.instance;
User loggedInUser = _auth.currentUser;

class MyHomePage extends StatefulWidget {
  static const routeName = '/home-page';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        title: Text(
          'ShopStop',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Take user to their cart screen
                Navigator.of(context).pushNamed(CartList.routeName);
              },
            ),
          ),
        ],
      ),
      body: ProductsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(InputPage.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 30),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 45.0,
                  child: Text(
                    'AB',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    loggedInUser.email,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   widget.user.phoneNumber,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 18,
                  //     letterSpacing: 2,
                  //   ),
                  // ),
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
        ),
        ListTile(
          title: Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('About'),
          onTap: () {
            Navigator.of(context).pushNamed(About.routeName);
          },
        ),
      ],
    ),
  );
}
