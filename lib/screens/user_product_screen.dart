import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/screens/edit_product_screen.dart';
import 'package:real_shop/widget/app_drawer.dart';
import 'package:real_shop/widget/user_product_item.dart';
class UserProductScreen extends StatelessWidget {
  static const String routName = "/user_product";

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 24),
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routName),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snabshot){
          return snabshot.connectionState == ConnectionState.waiting?
              Center(child: CircularProgressIndicator(),):
              RefreshIndicator(
                onRefresh: () => _refreshProduct(ctx),
                child: Consumer<Products>(
                  builder: (ctx, productData, _) => Container(
                    color: Colors.amber.withOpacity(.2),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: productData.items.length,
                        itemBuilder: (_, index) => Column(
                          children: [
                            UserProductItem(
                              id: productData.items[index].id,
                              title: productData.items[index].title,
                              imageUrl: productData.items[index].imageUrl,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
        },
      ),
      drawer: AppDrawer(),
    );
  }
}