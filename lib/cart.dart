import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:project/components/custombutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartData = [];
  List<int> counters = [];
  List<Map<String, dynamic>> selectedItems = [];

  @override
  void initState() {
    super.initState();
    loadCountersFromPrefs();
    showOrder();
  }

  @override
  void dispose() {
    saveCountersToPrefs();
    counters.clear();
    super.dispose();
  }

  Future showOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    var response = await Crud().getRequest(route: "/user/cart", headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var responsebody = jsonDecode(response.body);

    return responsebody['data'];
  }

  Future<void> loadCountersFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countersJson = prefs.getString('counters') ?? '[]';
    setState(() {
      counters = List<int>.from(jsonDecode(countersJson));
    });
  }

  Future<void> saveCountersToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('counters', jsonEncode(counters));
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
            "Cart",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: showOrder(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartData = List.from(snapshot.data);
                    return Expanded(
                      child: ListView.builder(
                        itemCount: cartData.length,
                        itemBuilder: (context, index) {
                          if (counters.length <= index) {
                            counters.add(0);
                          }
                          return Container(
                            color: Color.fromARGB(255, 183, 151, 240),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Text(
                                  "${cartData[index]['commercial_name']}"
                                  "${cartData[index]['caliber'] == null ? "" : cartData[index]['caliber']}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          color:
                                              Color.fromARGB(255, 48, 38, 135),
                                          onPressed: () {
                                            if (counters[index] <
                                                cartData[index]['quantity']) {
                                              setState(() {
                                                counters[index]++;
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.add)),
                                      Text(
                                        "${counters[index]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          color:
                                              Color.fromARGB(255, 48, 38, 135),
                                          onPressed: () {
                                            if (counters[index] > 0) {
                                              setState(() {
                                                counters[index]--;
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.remove)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    color: Color.fromARGB(255, 48, 38, 135),
                                    onPressed: () async {
                                      removeFromCart(int index) async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        String token =
                                            prefs.getString('token') ?? '';
                                        var data = {
                                          'id': cartData[index]['id'].toString()
                                        };
                                        var response = await Crud().postRequest(
                                            route: "/user/removecart",
                                            data: data,
                                            headers: {
                                              'Content-type':
                                                  'application/json',
                                              'Accept': 'application/json',
                                              'Authorization': 'Bearer $token'
                                            });
                                        var responsebody =
                                            jsonDecode(response.body);
                                        if (responsebody['status'] == true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(responsebody[
                                                      'message'])));
                                        } else {
                                          print(responsebody['message']);
                                        }
                                      }

                                      await removeFromCart(index);
                                      setState(() {
                                        cartData.removeAt(index);
                                      });
                                    },
                                    icon: Icon(Icons.delete_forever_outlined)),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Container();
                }),
            Container(
              margin: EdgeInsets.all(10),
              child: CustomButton(
                  title: "Send the order",
                  onPressed: () async {
                    sendOrder(List<Map<String, dynamic>> items) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String token = prefs.getString('token') ?? '';
                      final url =
                          Uri.parse("http://10.0.0.2:8000/api/user/order");
                      final data = {'arr': items};
                      var response = await http
                          .post(url, body: jsonEncode(data), headers: {
                        'Content-type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token'
                      });
                      var responsebody = jsonDecode(response.body);

                      if (responsebody['status'] == true) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor:
                                  Color.fromARGB(255, 183, 151, 240),
                              title: Text("Message"),
                              content: Text(responsebody['message']),
                              actions: [
                                FloatingActionButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            'home', (route) => false);
                                  },
                                  child: Text("Ok"),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        print(responsebody['message']);
                      }
                    }

                    for (int i = 0; i < cartData.length; i++) {
                      selectedItems.add({
                        'id': cartData[i]['id'],
                        'quantity': counters[i],
                      });
                    }

                    await sendOrder(selectedItems);
                  }),
            ),
          ],
        ));
  }
}
