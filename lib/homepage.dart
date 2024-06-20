import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:project/components/customlogo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  bool isloading = false;
  logout() async {
    isloading = true;
    setState(() {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    prefs.remove('token');
    final response = await Crud().getRequest(route: "/logout", headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    final responsebody = jsonDecode(response.body);
    isloading = false;
    setState(() {});
    if (responsebody['status'] == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responsebody['message'])));
      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: '${responsebody['message']}',
        btnOkOnPress: () {},
        btnOkColor: const Color.fromARGB(255, 220, 53, 41),
      )..show();
    }
  }

  Future notifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    var response = await Crud().getRequest(route: "/notification", headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var responsebody = jsonDecode(response.body);
    if (responsebody['status'] == true) {
      return responsebody;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    var response = await Crud().getRequest(route: "/user/profile", headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var responsebody = jsonDecode(response.body);
    return responsebody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Profile Information",
                      style: TextStyle(
                          color: Color.fromARGB(255, 48, 38, 135),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                        highlightColor: Colors.grey,
                        hoverColor: Colors.grey,
                        onPressed: () {
                          Navigator.of(context).pushNamed('editprofile');
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 48, 38, 135),
                        ))
                  ],
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                color: Color.fromARGB(255, 228, 199, 248),
                child: Icon(Icons.account_box,
                    size: 50, color: Color.fromARGB(255, 48, 38, 135)),
              ),
              FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      color: Color.fromARGB(255, 228, 199, 248),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Name: ',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 48, 38, 135)),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${snapshot.data['data']['name']}',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w400),
                                )
                              ])),
                          Container(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                              text: 'Phone Number: ',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 48, 38, 135)),
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      '${snapshot.data['data']['phone_number']}',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w400),
                                )
                              ])),
                          Container(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                              text: 'Pharmacy Name: ',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 48, 38, 135)),
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      '${snapshot.data['data']['pharmacy_name']}',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w400),
                                )
                              ])),
                          Container(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                              text: 'City: ',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 1, 41, 110)),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${snapshot.data['data']['city']}',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w400),
                                )
                              ])),
                          Container(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                              text: 'Region: ',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 48, 38, 135)),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${snapshot.data['data']['region']}',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w400),
                                )
                              ])),
                          Container(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                              text: 'Street: ',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 48, 38, 135)),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${snapshot.data['data']['street']}',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w400),
                                )
                              ])),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 48, 38, 135)),
                  );
                },
              )
            ],
          ),
        ),
        body: isloading == true
            ? Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 48, 38, 135)),
              )
            : ListView(children: [
                Container(height: 20),
                CustomLogo(),
                Container(
                  height: 70,
                ),
                Container(
                  height: 50,
                  margin:
                      EdgeInsets.only(right: 20, left: 20, bottom: 13, top: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
                    child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('category');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Medicines",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            Icon(
                              Icons.medication,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                        color: Color.fromARGB(255, 48, 38, 135)),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('cart');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Cart ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      color: Color.fromARGB(255, 48, 38, 135),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('order');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "My orders ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          Icon(
                            Icons.cases_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      color: Color.fromARGB(255, 48, 38, 135),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('favorite');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Favorite ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      color: Color.fromARGB(255, 48, 38, 135),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
                    child: MaterialButton(
                      onPressed: () {
                        scaffoldkey.currentState!.openDrawer();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Profile ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          Icon(
                            Icons.account_box,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      color: Color.fromARGB(255, 48, 38, 135),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('notification');
                      },
                      child: FutureBuilder(
                        future: notifications(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Notifications ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                                Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  "${snapshot.data['data']['counter'] == 0 ? "" : "+${snapshot.data['data']['counter']}"}",
                                  style: TextStyle(color: Colors.red),
                                )
                              ],
                            );
                          }
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Notifications ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                                Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 30,
                                )
                              ]);
                        },
                      ),
                      color: Color.fromARGB(255, 48, 38, 135),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('report');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Report ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          Icon(
                            Icons.fact_check,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      color: Color.fromARGB(255, 48, 38, 135),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
                    child: MaterialButton(
                      onPressed: () async {
                        await logout();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "LogOut ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      color: Color.fromARGB(255, 48, 38, 135),
                    ),
                  ),
                ),
              ]));
  }
}
