import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/widget/app_drawer.dart';
import 'package:real_shop/widget/order_item.dart';
import '../providers/orders.dart' show Orders;



class OrderScreen extends StatelessWidget {

  static const String routName = "/order";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snabshot){
          if(snabshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else{
            if(snabshot.error != null){
              return Center(
                child: Text("An error occurred"),
              );
            }else{
              return Consumer<Orders>(
                builder: (ctx, orderData, child){
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index) => OrderItem(order: orderData.orders[index],),
                  );
                },
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}