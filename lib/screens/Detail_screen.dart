import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/providers.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = "/detail";
  @override
  Widget build(BuildContext context) {
    final prid = ModalRoute.of(context)!.settings.arguments as String;
    final data = Provider.of<ProviderP>(context, listen: false).findbyid(prid);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(data.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                data.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "\$${data.price.toString()}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  data.description,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  softWrap: true,
                )),
          ],
        ),
      ),
    );
  }
}
