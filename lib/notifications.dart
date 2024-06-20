import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(255, 228, 199, 248),
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('home', (route) => false);
                  },
                  icon: Icon(
                    Icons.home,
                    size: 35,
                    color: Color.fromARGB(255, 48, 38, 135),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('category');
                  },
                  icon: Icon(
                    Icons.medication,
                    size: 35,
                    color: Color.fromARGB(255, 48, 38, 135),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('favorite');
                  },
                  icon: Icon(
                    Icons.star,
                    size: 35,
                    color: Color.fromARGB(255, 48, 38, 135),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('cart');
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: Color.fromARGB(255, 48, 38, 135),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('report');
                  },
                  icon: Icon(
                    Icons.fact_check,
                    size: 35,
                    color: Color.fromARGB(255, 48, 38, 135),
                  ))
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 48, 38, 135),
          title: Text(
            "Notifications",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
          future: notifications(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data['data']['orders'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shadowColor: Color.fromARGB(255, 48, 38, 135),
                      elevation: 5,
                      child: ListTile(
                        onTap: () async {
                          read() async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String token = prefs.getString('token') ?? '';
                            var data = {
                              'order_id': snapshot.data['data']['orders'][index]
                                      ['order_id']
                                  .toString(),
                              'status': snapshot.data['data']['orders'][index]
                                      ['status']
                                  .toString()
                            };
                            var response = await Crud().postRequest(
                                route: "/read",
                                data: data,
                                headers: {
                                  'Content-type': 'application/json',
                                  'Accept': 'application/json',
                                  'Authorization': 'Bearer $token'
                                });
                            var responsebody = jsonDecode(response.body);
                            if (responsebody['status'] == true) {
                              Navigator.of(context).pushNamed('order');
                            } else {
                              print(responsebody['message']);
                            }
                          }

                          await read();
                        },
                        leading: Icon(
                          Icons.notifications_active_outlined,
                          color: Color.fromARGB(255, 48, 38, 135),
                        ),
                        title: Text(
                            "The status has changed for the order number:${snapshot.data['data']['orders'][index]['order_id']} "),
                      ),
                      color: Color.fromARGB(255, 183, 151, 240),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 48, 38, 135)),
            );
          },
        ));
  }
}
