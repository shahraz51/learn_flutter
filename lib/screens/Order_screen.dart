import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/order.dart';
import 'package:shahroo_51/widget/Order_Widget.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "Order";
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isloading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async{
      setState(() {
        isloading=true;
      });
          await Provider.of<OrderO>(context, listen: false).fetchorder();
          setState(() {
        isloading=false;
      });
      
        });
        
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<OrderO>(context);
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("YOUR ORDER"),
      ),
      body:isloading?Center(child: CircularProgressIndicator(),): ListView.builder(
          itemCount: data.item.length,
          itemBuilder: (ctx, i) => OrderWidget(order: data.item[i])),
    );
  }
}
