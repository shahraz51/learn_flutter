import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/Cart.dart';
import 'package:shahroo_51/provider/order.dart';
import 'package:shahroo_51/widget/cart_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<CartC>(context);
    final db = Provider.of<OrderO>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("YOUR CART"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${data.totalamount.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  order(data: data, db: db)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: data.item.length,
                itemBuilder: (ctx, i) => CartWidget(
                      id: data.item.values.toList()[i].id,
                      prid: data.item.keys.toList()[i],
                      name: data.item.values.toList()[i].name,
                      price: data.item.values.toList()[i].price,
                      quantity: data.item.values.toList()[i].quantity,
                    )),
          )
        ],
      ),
    );
  }
}

class order extends StatefulWidget {
  const order({
    Key? key,
    required this.data,
    required this.db,
  }) : super(key: key);

  final CartC data;
  final OrderO db;

  @override
  _orderState createState() => _orderState();
}

class _orderState extends State<order> {
  var isloading=false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:(widget.data.totalamount<=0 || isloading)?null: () async{
        
        setState(() {
          isloading=true;
        });
       await  widget.db.addOrder(widget.data.totalamount, widget.data.item.values.toList());
        widget.data.clear();
        setState(() {
          isloading=false;
        });
      },
      
      
      child:isloading?CircularProgressIndicator(): Text(
        "ORDER NOW",
        style: TextStyle(
            fontSize: 15, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
