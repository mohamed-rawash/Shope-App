import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/orders.dart';
import 'package:real_shop/widget/cart_item.dart';

import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const String routName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor:Color.fromRGBO(143, 157, 134, 1),
      appBar: AppBar(title: Text("your Cart"),),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title: cart.items.values.toList()[index].title,
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: Colors.white,

            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total", style: TextStyle(fontSize: 20),),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  OrderButton({@required this.cart});

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading?CircularProgressIndicator():Text("Order Now"),
      textColor: Theme.of(context).primaryColor,
      onPressed:(widget.cart.totalAmount <= 0 || _isLoading)? null:() async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context,listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState(() {
          _isLoading = false;
        });
        widget.cart.clearCart();
      },
    );
  }
}
