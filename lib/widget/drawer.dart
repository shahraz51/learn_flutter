import 'package:flutter/material.dart';
import 'package:shahroo_51/screens/Order_screen.dart';
import 'package:shahroo_51/screens/edit_product.dart';
import 'package:shahroo_51/screens/sli.dart';



class Drawerapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Column(
        children: [
          AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("YOUR ORDER"),
          ),
          ListTile(
            leading:Icon(Icons.shop),
            title: Text("Shop"),
            onTap: (){Navigator.of(context).pushNamed("/");}
              
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.payment),
            title: Text("Order"),
            onTap: (){Navigator.of(context).pushNamed(OrderScreen.routeName);}
              
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.edit),
            title: Text("Your Product"),
            onTap: (){Navigator.of(context).pushNamed(EditProduct.routeName);}
              
          ),
          ListTile(
            leading:Icon(Icons.sledding),
            title: Text("Slider"),
            onTap: (){Navigator.of(context).pushNamed(Sli.routeName);})
          
        ],
      ),
    );
  }
}
