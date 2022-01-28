import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/Cart.dart';
import 'package:shahroo_51/provider/providers.dart';
import 'package:shahroo_51/screens/carr_screen.dart';
import 'package:shahroo_51/widget/badge.dart';
import 'package:shahroo_51/widget/drawer.dart';
import 'package:shahroo_51/widget/overview_widget.dart';


// enum option{
//   favorite,
//   All,
//}
class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool show = false;
  var isinit=true;
  var isloading=false;
@override
  void didChangeDependencies() {
    if(isinit){
      isloading=true;
    Provider.of<ProviderP>(context).FetchData().then((value) {
      setState(() {
        isloading=false;
      });
    });}
    isinit=false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProviderP>(context);
    final db = show ? data.onlyfavorite : data.item;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                setState(() {
                if (value == true) {
                    show = true;
                  } else {
                    show = false;
                  }    
                });
              },
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: Text("Only Favorite"),
                      value: true,
                    ),
                    PopupMenuItem(
                      child: Text("All"),
                      value: false,
                    )
                  ])
        ],
        title: Text("Shahroo"),
      ),
      drawer: Drawerapp(),
      body:isloading?Center(child:CircularProgressIndicator.adaptive()) :
          GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: db.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: db[i],
              child: OverviewWidget(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5),
          ),
        
      
      floatingActionButton: Container(
        child: FittedBox(
          child: Consumer<CartC>(
            builder: (ctx,cartdata,ch)=>Badge(child: ch!,value:cartdata.itemlength.toString()),
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                backgroundColor: Theme.of(context).primaryColor,
                child:Icon(Icons.shopping_cart),      
                ),
          ),
        ),
      ),
    );
  }
}
