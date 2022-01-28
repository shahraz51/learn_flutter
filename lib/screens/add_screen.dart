import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/productClass.dart';
import 'package:shahroo_51/provider/providers.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);
  static const routeName = "Add";
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _pricefocusnode = FocusNode();
  final _descriptionnode = FocusNode();
  final _imageURL = TextEditingController();
  final _imageUrlfocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _initValues = {
    "title": "",
    "price": "",
    "description": "",
    "imageUrl": ""
  };
  var editproduct =
      ProductC(id: "", title: "", description: "", price: 0, imageUrl: "");
  var _isInit = true;
  var isloading = false;
  @override
  void initState() {
    print("data");
    _imageUrlfocusnode.addListener(_updateimage);
    //  TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlfocusnode.dispose();
    _imageUrlfocusnode.removeListener(_updateimage);
    _pricefocusnode.dispose();
    _descriptionnode.dispose();
    _imageURL.dispose();
    super.dispose();
  }

  _updateimage() {
    if (!_imageUrlfocusnode.hasFocus) {
      if (!_imageURL.text.startsWith("http")) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isvalid = _form.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      isloading = true;
    });
    if (editproduct.id != "") {
      await Provider.of<ProviderP>(context, listen: false)
          .update(editproduct.id, editproduct);
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProviderP>(context, listen: false)
            .addproduct(editproduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("ops some thing went wrong "),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Okay"))
                  ],
                ));
      }
      finally{
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != "") {
        editproduct =
            Provider.of<ProviderP>(context, listen: false).findbyid(productId);
        _initValues = {
          'title': editproduct.title,
          'description': editproduct.description,
          'price': editproduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageURL.text = editproduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
        ],
        title: Text("Add Your Product"),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues["title"],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionnode);
                      },
                      onSaved: (value) {
                        editproduct = ProductC(
                          title: value.toString(),
                          price: editproduct.price,
                          description: editproduct.description,
                          imageUrl: editproduct.imageUrl,
                          id: editproduct.id,
                          isfavorite: editproduct.isfavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please provide Title";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["price"],
                      decoration: InputDecoration(labelText: "price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _pricefocusnode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionnode);
                      },
                      onSaved: (value) {
                        editproduct = ProductC(
                          id: editproduct.id,
                          title: editproduct.title,
                          description: editproduct.description,
                          price: double.parse(value.toString()),
                          imageUrl: editproduct.imageUrl,
                          isfavorite: editproduct.isfavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please enter a price";
                        }
                        if (double.tryParse(value) == null) {
                          return "please enter a valid number";
                        }
                        if (double.parse(value) <= 0) {
                          return "please enter a number grater than 0";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["description"],
                      decoration: InputDecoration(labelText: "description"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionnode,
                      onSaved: (value) {
                        editproduct = ProductC(
                          id: editproduct.id,
                          title: editproduct.title,
                          description: value.toString(),
                          price: editproduct.price,
                          imageUrl: editproduct.imageUrl,
                          isfavorite: editproduct.isfavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please enter a Description";
                        }
                        if (value.length < 10) {
                          return "please enter at least 10 character ";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 5, top: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: _imageURL.text.isEmpty
                                ? Text("Enter URL")
                                : FittedBox(
                                    child: Image.network(
                                      _imageURL.text,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURL,
                            focusNode: _imageUrlfocusnode,
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (value) {
                              editproduct = ProductC(
                                id: editproduct.id,
                                title: editproduct.title,
                                description: editproduct.description,
                                price: editproduct.price,
                                imageUrl: value.toString(),
                                isfavorite: editproduct.isfavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please enter IMAGE URL";
                              }
                              if (!value.startsWith("http") &&
                                  value.startsWith("https")) {
                                return "please enter a valid URL";
                              }
                              if (!value.endsWith("jpg") &&
                                  !value.endsWith("png")) {
                                return "please enter a valid image URL";
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
