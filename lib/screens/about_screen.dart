import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class About extends StatefulWidget {
  static const routeName = '/about-page';
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.0,
                    spreadRadius: 2.0,
                    //offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('images/OSAppLogo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 45.0),
              child: Column(
                children: [
                  Text(
                    'ShopStop',
                    style: TextStyle(
                      color: Colors.purpleAccent[700],
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'M. ABHISHEK',
                    style: TextStyle(
                      color: Colors.purpleAccent[400],
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
