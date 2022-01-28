import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/providers.dart';
import 'package:shahroo_51/screens/add_screen.dart';

class EditWidget extends StatelessWidget {
  final String id;
  final String name;
  final String imageurl;
  EditWidget({required this.id, required this.name, required this.imageurl});
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
    return Column(
      children: [
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageurl),
          ),
          title: Text(name),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AddScreen.routeName, arguments: id);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    )),
                IconButton(
                    onPressed: () async{
                      try {
                         await Provider.of<ProviderP>(context,listen: false).deleteProduct(id);
                       
                      } catch (e) {
                        print("object");
                      //  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
