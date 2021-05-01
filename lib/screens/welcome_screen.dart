import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import 'dart:math' as math;

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 250.0,
            child: Transform.rotate(
              angle: -math.pi / 10.0,
              child: Icon(
                Icons.shop,
                size: 450.0,
                color: Colors.black12,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.deepOrange,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'SHOPSTOP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 48.0,
                ),
                RoundedButton(
                  title: 'Log In',
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                ),
                RoundedButton(
                  title: 'Register',
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
