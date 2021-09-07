import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/cart.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/screens/cart_screen.dart';
import 'package:real_shop/widget/app_drawer.dart';
import 'package:real_shop/widget/badge.dart';
import 'package:real_shop/widget/products_grid.dart';
class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

enum FilterOption{Favorite, All}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  FilterOption selected_val;
  var _isLoading = false;
  bool _showOnlyFavorite = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Provider.of<Products>(context, listen: false).fetchAndSetProducts()
        .then((_) => setState(() {
      _isLoading = false;
        }),
    ).catchError(
        (_) => setState(() {
          _isLoading = false;
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(143, 157, 134, 1),
      appBar: AppBar(
        title: Text("shop"),
        actions: [
          PopupMenuButton(
            onSelected: (selected_val){
              setState(() {
                if(selected_val == FilterOption.Favorite){
                  _showOnlyFavorite = true;
                }else{
                  _showOnlyFavorite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert_sharp, color: Colors.white, size: 24,),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorite"),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white, size: 24,),
              onPressed: () => Navigator.of(context).pushNamed(CartScreen.routName),
            ),
            builder:(_, cart, child) => Badge(value:cart.itemCount.toString(), child: child),
          ),
        ],
      ),
      body:_isLoading?Center(child: CircularProgressIndicator()):ProductsGrid(_showOnlyFavorite),
      drawer: AppDrawer(),
    );
  }
}
