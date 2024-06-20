import 'package:flutter/material.dart';
import 'package:project/auth/login.dart';
import 'package:project/auth/register.dart';
import 'package:project/cart.dart';
import 'package:project/details.dart';
import 'package:project/editprofile.dart';
import 'package:project/favorite.dart';
import 'package:project/homepage.dart';
import 'package:project/categories.dart';
import 'package:project/medicine.dart';
import 'package:project/notifications.dart';
import 'package:project/orders.dart';
import 'package:project/report.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 227, 190, 251),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 48, 38, 135)),
        useMaterial3: true,
      ),
      home: Center(
          child: FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Some error has Occurred');
                } else if (snapshot.hasData) {
                  final token = snapshot.data!.getString('token');
                  if (token != null) {
                    return HomePage();
                  } else {
                    return LogIn();
                  }
                } else {
                  return LogIn();
                }
              })),
      routes: {
        'home': (context) => HomePage(),
        'register': (context) => Register(),
        'login': (context) => LogIn(),
        'category': (context) => CategoryPage(),
        'medicine': (context) => Medicine(),
        'details': (context) => details(),
        'editprofile': (context) => EditProfile(),
        'favorite': (context) => Favorite(),
        'cart': (context) => CartPage(),
        'order': (context) => Orders(),
        'notification': (context) => Notifications(),
        'report': (context) => Report(),
      },
    );
  }
}
