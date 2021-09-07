import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.quantity,
    @required this.price,
    @required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 24,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.all(8),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Color.fromRGBO(143, 157, 134, 1),
            title: Text('Are you sure?'),
            content: Text('Do you want remove this item from Cart?'),
            actions: [
              FlatButton(
                child: Text('No'),
                color: Colors.blue,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              FlatButton(
                child: Text('Yes'),
                color: Theme.of(ctx).errorColor,
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => Provider.of<Cart>(context, listen: false).removeItem(productId),
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('$price \$'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total \$ ${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
