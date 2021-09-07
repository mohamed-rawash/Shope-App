import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(143, 157, 134, 1),
        child: Column(
          children: [
            AppBar(
              title: Text("Hello"),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              title:Text("Shop"),
              leading:Icon(Icons.shop, color: Colors.white,) ,
              onTap: () => Navigator.of(context).pushReplacementNamed("/"),
            ),
            Divider(
              thickness: 2,
              indent: 15,
              endIndent: 20,
              color: Colors.white,
            ),
            ListTile(
              title:Text("Orders"),
              leading:Icon(Icons.payment, color: Colors.white,) ,
              onTap: () => Navigator.of(context).pushReplacementNamed(OrderScreen.routName),
            ),
            Divider(
              thickness: 2,
              indent: 15,
              endIndent: 20,
              color: Colors.white,
            ),
            ListTile(
              title:Text("Mange Product"),
              leading:Icon(Icons.edit, color: Colors.white,) ,
              onTap: () => Navigator.of(context).pushReplacementNamed(UserProductScreen.routName),
            ),
            Divider(
              thickness: 2,
              indent: 15,
              endIndent: 20,
              color: Colors.white,
            ),
            ListTile(
              title:Text("Logout"),
              leading:Icon(Icons.exit_to_app, color: Colors.white,) ,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/");
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
