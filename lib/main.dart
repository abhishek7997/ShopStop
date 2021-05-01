import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/welcome_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/registration_screen.dart';
import './screens/login_screen.dart';
import './screens/about_screen.dart';
import './screens/cart_screen.dart';
import './screens/checkout_page.dart';
import 'package:provider/provider.dart';
import './screens/input_screen.dart';
import './screens/HomePage.dart';
import 'providers/item.dart';
import 'providers/price.dart';
import 'screens/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider.value(value: Items()),
        ChangeNotifierProvider.value(value: Item()),
        ChangeNotifierProvider.value(value: Price()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          title: 'ShopStop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          initialRoute: WelcomeScreen.routeName,
          routes: {
            WelcomeScreen.routeName: (context) => WelcomeScreen(),
            MyHomePage.routeName: (context) => MyHomePage(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            InputPage.routeName: (ctx) => InputPage(),
            RegistrationScreen.routeName: (context) => RegistrationScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            About.routeName: (context) => About(),
            CartList.routeName: (context) => CartList(),
            CheckoutPage.routeName: (context) => CheckoutPage(),
          },
        ),
      ),
    );
  }
}
