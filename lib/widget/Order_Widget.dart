import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shahroo_51/provider/order.dart';

class OrderWidget extends StatefulWidget {
  final Orderitem order;
  OrderWidget({required this.order});

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  var _expand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
              title: Text(
                  "Total Amount \$${widget.order.amount.toStringAsFixed(2)}"),
              subtitle: Text(
                  DateFormat("dd MM yyyy hh:m,").format(widget.order.date)),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _expand = !_expand;
                    });
                  },
                  icon: Icon(_expand ? Icons.expand_less : Icons.expand_more))),
          if (_expand)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              height: min(widget.order.whatyouorder.length * 20+10 , 80),
              child: ListView(
                  children:
                      widget.order.whatyouorder.map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Text(e.name),
                         Text("${(e.quantity)}x   \$${(e.price)}")
                        ],
                      )).toList()),
            )
        ],
      ),
    );
  }
}
