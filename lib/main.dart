//@dart=2.9
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/order_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/Cart_Screen.dart';
import 'screens/product_detail.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'screens/edit_product_screen.dart';
import 'widgets/orders.dart';
import 'screens/user_product_screen.dart';
import 'package:shopping_app/providers/auth.dart';

import 'widgets/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (BuildContext context) => Products(
                  Provider.of<Auth>(context, listen: false).toString(), []),
              update: (context, auth, previousProducts) => Products(auth.token,
                  previousProducts == null ? [] : previousProducts.items)),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (context) => Orders(),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'SHOPPING APP',
            theme: ThemeData(
              fontFamily: 'Lato', // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: auth.Isauth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen()
            },
          ),
        ));
  }
}
