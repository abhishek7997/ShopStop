import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'HomePage.dart';
import '../constants.dart';
import '../components/rounded_button.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = '/registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email, password, password2;
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordController2 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register your account'),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value.trim();
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 36.0,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 12.0,
              ),
              // TextField(
              //   obscureText: true,
              //   textAlign: TextAlign.center,
              //   controller: passwordController2,
              //   onChanged: (value) {
              //     password2 = value;
              //   },
              //   decoration: kTextFieldDecoration.copyWith(
              //       hintText: 'Re-Enter your password'),
              // ),
              SizedBox(
                height: 96.0,
              ),
              RoundedButton(
                title: 'Register',
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    if (EmailValidator.validate(email)) {
                      if (passwordController.value != null) {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, MyHomePage.routeName);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Passwords don\'t match, please check again')));
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please enter a valid email address')));
                    }
                  } catch (e) {
                    if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'The email address is already in use by another account.')));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                    print(e);
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
