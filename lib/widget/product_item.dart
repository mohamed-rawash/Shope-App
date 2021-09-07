import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/auth.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:real_shop/providers/product.dart';
import 'package:real_shop/screens/product_detail_screen.dart';
import 'package:like_button/like_button.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    bool isLiked = false;

    Future<bool> onLikeButtonTapped(bool isLike) async{
      isLiked = isLike;
      await product.toggleFavoriteStatus(authData.token, authData.userId);
      return !isLike;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(ProductDetailScreen.routName, arguments: product.id),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: product.isFavorite? Icon(Icons.favorite):Icon(Icons.favorite_border),
              onPressed: () => product.toggleFavoriteStatus(authData.token, authData.userId),
            ),
          ),
          title: Text(product.title, textAlign: TextAlign.center,),
          trailing:IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white, size: 24),
            onPressed: (){
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text(
                    "Added to Cart!",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "Undo!",
                    textColor: Colors.black,
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
