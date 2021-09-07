import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/products.dart';
class ProductDetailScreen extends StatelessWidget {
  static const String routName = "/product_detail";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      backgroundColor: Color.fromRGBO(143, 157, 134, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title, style: TextStyle(color: Colors.white)),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Text(
                  "${loadedProduct.price} \$",
                  style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child:Text(
                    loadedProduct.description,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
