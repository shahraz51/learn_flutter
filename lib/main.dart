import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahroo_51/provider/AuthP.dart';
import 'package:shahroo_51/provider/Cart.dart';
import 'package:shahroo_51/provider/order.dart';
import 'package:shahroo_51/provider/providers.dart';
import 'package:shahroo_51/screens/Detail_screen.dart';
import 'package:shahroo_51/screens/Order_screen.dart';
import 'package:shahroo_51/screens/add_screen.dart';
import 'package:shahroo_51/screens/auth_screen.dart';
import 'package:shahroo_51/screens/carr_screen.dart';
import 'package:shahroo_51/screens/edit_product.dart';
import 'package:shahroo_51/screens/product_screen.dart';
import 'package:shahroo_51/screens/sli.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  get create => null;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthP()),
        ChangeNotifierProxyProvider<AuthP, ProviderP>(
          create: (ctx) => ProviderP("", []),
          update: (ctx, auth, previousproduct) => ProviderP(
              auth.token.toString(),
              previousproduct == null ? [] : previousproduct.item),
        ),
        ChangeNotifierProvider(create: (ctx) => CartC()),
        
        ChangeNotifierProxyProvider<AuthP,OrderO>(create: (ctx)=>OrderO("", []), 
        update:  (ctx, auth, previousproduct) => OrderO(
              auth.token.toString(),
              previousproduct == null ? [] : previousproduct.item),
        
        ),
      ],
      child: Consumer<AuthP>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.purple.shade400,
          ),
          home: auth.isAuth ? OverviewScreen() : AuthScreen(),
          routes: {
            CartScreen.routeName: (ctx) => CartScreen(),
            DetailScreen.routeName: (ctx) => DetailScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            EditProduct.routeName: (ctx) => EditProduct(),
            AddScreen.routeName: (ctx) => AddScreen(),
            Sli.routeName: (ctx) => Sli(),
          },
        ),
      ),
    );
  }
}

