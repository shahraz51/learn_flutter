import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/Cart.dart';
class CartWidget extends StatelessWidget {
  final String id; 
  final String prid;
  final String name;
  final double price;
  final int quantity;
  CartWidget(
      {
      required this.id,
      required this.prid,
      required this.name,
      required this.price,
      required this.quantity});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        color: Theme.of(context).errorColor,
      child: Icon(Icons.delete,size: 30),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (ctx)=>AlertDialog(
         title: Text("Are you sure ?"),
         content: Text("You want to delet cart"),
         actions: <Widget>[
           TextButton(onPressed: (){Navigator.of(context).pop(true);}, child: Text("Yes")),
           TextButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("No")),
         ],
        ));
      },
      onDismissed: (direction){
        Provider.of<CartC>(context,listen: false).removthisid(prid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
              leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: FittedBox(
                      child: Text(
                    "\$$price",
                    style: TextStyle(color: Colors.white),
                  ))),
              title: Text(
                name,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text("Total:\$${(price * quantity).toStringAsFixed(2)}"),
              trailing: Text("x$quantity"),
              ),
        ),
      ),
    );
  }
}
