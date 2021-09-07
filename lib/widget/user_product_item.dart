import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop/providers/products.dart';
import 'package:real_shop/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl
});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black, size: 24,),
              onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routName, arguments: id),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 24,),
              onPressed: () async {
                try{
                  Provider.of<Products>(context,listen: false).deleteProduct(id);
                }catch(e){
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text("Deleting Failed!", style: TextStyle(color: Colors.white, fontSize: 25),),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                  );
                }
              }

            ),
          ],
        ),
      ),
    );
  }
}
