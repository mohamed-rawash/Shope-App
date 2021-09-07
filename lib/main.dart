import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './providers/auth.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_product_screen.dart';
import './screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (context, authValue, previousProducts) =>
                previousProducts..getData(
                    authValue.token,
                    authValue.userId,
                    previousProducts == null?null:previousProducts.items,
                ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (context, authValue, previousOrders) =>
          previousOrders..getData(
            authValue.token,
            authValue.userId,
            previousOrders == null?null:previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) =>MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
            appBarTheme: AppBarTheme(
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
          ),

          home: auth.isAuth? ProductOverviewScreen():FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ?SplahScreen()
                    :AuthScreen(),
          ),
          routes: {
            ProductDetailScreen.routName: (_)=> ProductDetailScreen(),
            CartScreen.routName: (_)=> CartScreen(),
            OrderScreen.routName: (_)=> OrderScreen(),
            UserProductScreen.routName: (_)=> UserProductScreen(),
            EditProductScreen.routName: (_)=> EditProductScreen(),
            AuthScreen.routName: (_)=> AuthScreen(),
          },
        ),
      ),
    );
  }
}

