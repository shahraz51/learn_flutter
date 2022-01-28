import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/AuthP.dart';
import 'package:shahroo_51/provider/Cart.dart';
import 'package:shahroo_51/provider/productClass.dart';
import 'package:shahroo_51/screens/Detail_screen.dart';

class OverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProductC>(context, listen: false);
    final db = Provider.of<CartC>(context, listen: false);
    final auth = Provider.of<AuthP>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            data.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(DetailScreen.routeName, arguments: data.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black26,
          leading: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              db.addcartitem(data.id, data.title, data.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Item Added to Cart"),
                duration: Duration(seconds: 1),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    db.removesingleitem(data.id);
                  },
                ),
              ));
            },
          ),
          title: Text(
            data.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<ProductC>(
            builder: (_, cartdata, child) => IconButton(
              icon: Icon(
                  data.isfavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                
                data.myfavorite(auth.token!,auth.userid!);
              },
            ),
          ),
        ),
      ),
    );
  }
}
