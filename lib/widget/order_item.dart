import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  OrderItem({
    @required this.order
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text("${order.amount} \$"),
        subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
        children: order.products.map((product) =>
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '${product.quantity} x',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Total price ${product.price * product.quantity} \$',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                Divider(thickness: 2, color: Colors.blue, indent: 6,)
              ],
            ),
        ).toList(),
      ),
    );
  }
}
