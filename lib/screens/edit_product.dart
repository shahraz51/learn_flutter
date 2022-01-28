import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/providers.dart';
import 'package:shahroo_51/screens/add_screen.dart';
import 'package:shahroo_51/widget/Edit_widget.dart';
import 'package:shahroo_51/widget/drawer.dart';

class EditProduct extends StatelessWidget {
  static const routeName = "Edit";
Future<void>fetchdata(BuildContext context)async{
  await Provider.of<ProviderP>(context,listen: false).FetchData();
}

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProviderP>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Your Product"),
          actions: [IconButton(onPressed: () {
           Navigator.of(context).pushNamed(AddScreen.routeName,arguments: "");
          }, icon: const Icon(Icons.add))],
        ),
        drawer: Drawerapp(),
        body: 
           RefreshIndicator(
             onRefresh: ()=>fetchdata(context),
             child: ListView.builder(
                itemCount: data.item.length,
                itemBuilder: (ctx, i) => EditWidget(
                      id:data.item[i].id,
                      name: data.item[i].title,
                      imageurl: data.item[i].imageUrl,
                    )),
           ),
        );
  }
}
