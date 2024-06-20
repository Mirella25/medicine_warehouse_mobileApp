import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:project/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  Future getFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final response =
        await Crud().getRequest(route: "/user/favorites", headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    final responsebody = jsonDecode(response.body);
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
                    Navigator.of(context).pushNamed('cart');
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: Color.fromARGB(255, 48, 38, 135),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('order');
                  },
                  icon: Icon(
                    Icons.cases_rounded,
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
            "Favorite",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
          future: getFavorite(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data['data'].length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    var calibers = snapshot.data['data'][index]['caliber'];

                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
                        color: Color.fromARGB(255, 48, 38, 135),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                getDetails() async {
                                  String name = calibers['commercial']
                                          ['commercial_name']
                                      .toString();
                                  String caliber;
                                  if (calibers['caliber'] == null) {
                                    caliber = " ";
                                  } else {
                                    caliber = calibers['caliber'].toString();
                                  }
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String token = prefs.getString('token') ?? '';
                                  var data = {
                                    'commercial_name': name,
                                    'caliber': caliber
                                  };
                                  var response = await Crud().postRequest(
                                      route: "/details",
                                      data: data,
                                      headers: {
                                        'Content-type': 'application/json',
                                        'Accept': 'application/json',
                                        'Authorization': 'Bearer $token'
                                      });
                                  var responsebody = jsonDecode(response.body);
                                  if (responsebody['status'] == true) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => details(
                                          name: responsebody['data']
                                              ['scientific_name'],
                                          company: responsebody['data']
                                              ['company'],
                                          price: responsebody['data']['price'],
                                          quantity: responsebody['data']
                                              ['quantity'],
                                          date: responsebody['data']
                                              ['expiration_date'],
                                          comName: name,
                                          caliberData: caliber),
                                    ));
                                  } else {
                                    print(responsebody['message']);
                                  }
                                }

                                await getDetails();
                              },
                              child: Container(
                                height: 120,
                                width: 150,
                                color: Color.fromARGB(255, 183, 151, 240),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${calibers['commercial']['commercial_name']}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${calibers['caliber'] == null ? "" : calibers['caliber']}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 48, 38, 135)),
            );
          },
        ));
  }
}
