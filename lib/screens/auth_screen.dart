import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/AuthP.dart';
import 'package:shahroo_51/provider/Http_exception.dart';

enum Authmod { signup, login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(138, 43, 226, 1).withOpacity(0.5),
                Color.fromRGBO(255, 218, 135, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              stops: [0, 1],
            )),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                        transform: Matrix4.rotationZ(-10 * pi / 180)
                          ..translate(-10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.orangeAccent,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black,
                                  offset: Offset(0, 3))
                            ]),
                        child: Text(
                          "MyShop",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.normal),
                        ),
                      )),
                  Flexible(
                    flex: 1,
                    child: AuthWidget(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  Authmod _authmod = Authmod.login;
  final GlobalKey<FormState> _globalKey = GlobalKey();
  Map<String, String> _authdata = {
    "Email": "",
    "Password": "",
  };
  final _passwordcontroller = TextEditingController();
  var isloading = false;
  void _showdialog(String massage){
showDialog(context: context, builder: (ctx)=>AlertDialog(
  title: Text("An error Occoured"),
  content: Text(massage),
  actions:<Widget> [
    ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Ok"))
  ],
));
  }
  Future<void> _submited() async{
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    _globalKey.currentState!.save();

    setState(() {
      isloading = true;
    });
    try {
      if (_authmod == Authmod.login) {
await Provider.of<AuthP>(context,listen: false).login(_authdata["Email"]!,_authdata["Password"]!);
    } else {
  
      await Provider.of<AuthP>(context,listen: false).signup(_authdata["Email"]!,_authdata["Password"]!);
    }
    
    }on HttpExeption catch(error){
      var errormassage="error a accured";
     if(error.toString().contains("EMAIL_EXISTS")){
        errormassage="This email is already in use";
     }
     else if(error.toString().contains("EMAIL_NOT_FOUND")){
        errormassage="Could not find a user with that email ";
     }
     else if(error.toString().contains("INVALID_PASSWORD")){
        errormassage="invalid password ";
     }
     _showdialog(errormassage);
    }
     catch (error) {
       const errormassage="Network Error ops";
       _showdialog(errormassage);
    }
    
    setState(() {
      isloading = false;
    });
  }

  void _switchAuthmod() {
    if(_authmod==Authmod.login){
      setState(() {
         _authmod=Authmod.signup;
      });
     
    }else{
      setState(() {
        _authmod=Authmod.login;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      child: Container(
        height: _authmod == Authmod.signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authmod == Authmod.signup ? 320 : 260),
        width: devicesize.width * 0.8,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authdata["Email"] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  controller: _passwordcontroller,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return "Password is too short";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authdata["Password"] = value!;
                  },
                ),
                if (_authmod == Authmod.signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    obscureText: true,
                    validator: _authmod == Authmod.signup
                        ? (value) {
                            if (value != _passwordcontroller.text) {
                              return "Passwords dont match";
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (isloading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submited,
                    child:
                        Text(_authmod == Authmod.login ? "LOGIN" : "SIGN UP"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      primary: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _switchAuthmod,
                  child: Text(
                    "${_authmod == Authmod.login ? "SIGNUP " : "LOGIN "}INSTEAD",
                    style: TextStyle(color: Colors.purple),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
