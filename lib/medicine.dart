import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:project/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Medicine extends StatefulWidget {
  final medData;
  Medicine({super.key, this.medData});

  @override
  State<Medicine> createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {
  TextEditingController search = TextEditingController();
  List<dynamic> filteredMedicines = [];
  List<bool> favoriteStates = [];

  @override
  void initState() {
    super.initState();

    loadFavoriteStates();
    filteredMedicines = List.from(widget.medData['commercial']);
  }

  void loadFavoriteStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteStates = List.generate(
        widget.medData['commercial'].length,
        (index) {
          return loadFavoriteState(index, prefs);
        },
      );
    });
  }

  bool loadFavoriteState(int index, SharedPreferences prefs) {
    String commercialKey = getUniqueKey(index, 0);
    if (commercialKey.isNotEmpty) {
      bool favoriteState =
          prefs.getBool('favoriteState_$commercialKey') ?? false;
      return favoriteState;
    } else {
      return false;
    }
  }

  void saveFavoriteState(int index, int caliberIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uniqueKey = getUniqueKey(index, caliberIndex);
    if (uniqueKey.isNotEmpty) {
      prefs.setBool('favoriteState_$uniqueKey', favoriteStates[index]);
    }
  }

  String getUniqueKey(int index, int caliberIndex) {
    if (index >= 0 && index < widget.medData['commercial'].length) {
      String commercialName =
          widget.medData['commercial'][index]['commercial_name']?.toString() ??
              '';
      List<dynamic> calibersList =
          widget.medData['commercial'][index]['calibers'];

      if (calibersList.isNotEmpty && caliberIndex < calibersList.length) {
        String caliber =
            calibersList[caliberIndex]['caliber']?.toString() ?? '';
        return "$commercialName$caliber";
      }
    }
    return '';
  }

  void filterMedicines(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMedicines = List.from(widget.medData['commercial']);
      } else {
        filteredMedicines = widget.medData['commercial']
            .where((medicine) =>
                medicine['commercial_name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                medicine['calibers'].any((caliber) => caliber['caliber']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase())))
            .toList();
      }
    });
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
          "Medicines",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
                onChanged: filterMedicines,
                controller: search,
                decoration: InputDecoration(
                  hintText: "Search for a medicine",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.grey,
                )),
          ),
          Divider(
            color: Color.fromARGB(255, 183, 151, 240),
            thickness: 5,
          ),
          Expanded(
              child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: filteredMedicines.length,
            itemBuilder: (context, index) {
              final List<dynamic> medicines = filteredMedicines;
              List<dynamic> calibers = medicines[index]['calibers'];

              for (int caliberIndex = 0;
                  caliberIndex < calibers.length;
                  // ignore: dead_code
                  caliberIndex++) {
                if (calibers[caliberIndex]['status'] == 1) {
                  return Card(
                      child: Container(
                    color: Color.fromARGB(255, 183, 151, 240),
                    height: 50,
                    child: ListTile(
                      leading: IconButton(
                          icon: Icon(
                            favoriteStates.isNotEmpty &&
                                    favoriteStates[index] == true
                                ? Icons.star
                                : Icons.star_border,
                          ),
                          color: Color.fromARGB(255, 48, 38, 135),
                          onPressed: () async {
                            setState(() {
                              favoriteStates[index] = !favoriteStates[index];
                            });
                            saveFavoriteState(index, caliberIndex);

                            if (favoriteStates[index]) {
                              addFavorite() async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String token = prefs.getString('token') ?? '';
                                String name = medicines[index]
                                        ['commercial_name']
                                    .toString();
                                String caliber;
                                if (calibers[caliberIndex]['caliber'] == null) {
                                  caliber = " ";
                                } else {
                                  caliber = calibers[caliberIndex]['caliber']
                                      .toString();
                                }
                                var data = {
                                  'commercial_name': name,
                                  'caliber': caliber
                                };
                                var response = await Crud().postRequest(
                                    route: "/user/addfavorite",
                                    data: data,
                                    headers: {
                                      'Content-type': 'application/json',
                                      'Accept': 'application/json',
                                      'Authorization': 'Bearer $token'
                                    });
                                var responsebody = jsonDecode(response.body);
                                if (responsebody['status'] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(responsebody['message'])));
                                } else {
                                  print(responsebody['message']);
                                }
                              }

                              await addFavorite();
                            } else {
                              removeFavorite() async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String token = prefs.getString('token') ?? '';
                                String name = medicines[index]
                                        ['commercial_name']
                                    .toString();
                                String caliber;
                                if (calibers[caliberIndex]['caliber'] == null) {
                                  caliber = " ";
                                } else {
                                  caliber = calibers[caliberIndex]['caliber']
                                      .toString();
                                }
                                var data = {
                                  'commercial_name': name,
                                  'caliber': caliber
                                };
                                var response = await Crud().postRequest(
                                    route: "/user/removefavorite",
                                    data: data,
                                    headers: {
                                      'Content-type': 'application/json',
                                      'Accept': 'application/json',
                                      'Authorization': 'Bearer $token'
                                    });
                                var responsebody = jsonDecode(response.body);
                                if (responsebody['status'] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(responsebody['message'])));
                                } else {
                                  print(responsebody['message']);
                                }
                              }

                              await removeFavorite();
                            }
                          }),
                      title: Text("${medicines[index]['commercial_name']}"
                          "${calibers[caliberIndex]['caliber'] == null ? "" : calibers[caliberIndex]['caliber']}"),
                      trailing: Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: IconButton(
                                  onPressed: () async {
                                    getDetails() async {
                                      String name = medicines[index]
                                              ['commercial_name']
                                          .toString();
                                      String caliber;
                                      if (calibers[caliberIndex]['caliber'] ==
                                          null) {
                                        caliber = " ";
                                      } else {
                                        caliber = calibers[caliberIndex]
                                                ['caliber']
                                            .toString();
                                      }
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String token =
                                          prefs.getString('token') ?? '';
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
                                      var responsebody =
                                          jsonDecode(response.body);
                                      if (responsebody['status'] == true) {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => details(
                                              name: responsebody['data']
                                                  ['scientific_name'],
                                              company: responsebody['data']
                                                  ['company'],
                                              price: responsebody['data']
                                                  ['price'],
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
                                  icon: Icon(Icons.menu_book_rounded)),
                            ),
                            Expanded(
                              child: MaterialButton(
                                color: Color.fromARGB(255, 48, 38, 135),
                                onPressed: () async {
                                  addToCart() async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String token =
                                        prefs.getString('token') ?? '';
                                    String caliber;
                                    if (calibers[caliberIndex]['caliber'] ==
                                        null) {
                                      caliber = " ";
                                    } else {
                                      caliber = calibers[caliberIndex]
                                              ['caliber']
                                          .toString();
                                    }

                                    var data = {
                                      'commercial_name': medicines[index]
                                              ['commercial_name']
                                          .toString(),
                                      'caliber': caliber,
                                      'quantity': calibers[caliberIndex]
                                              ['quantity']
                                          .toString(),
                                    };
                                    var response = await Crud().postRequest(
                                        route: "/user/addcart",
                                        data: data,
                                        headers: {
                                          'Content-type': 'application/json',
                                          'Accept': 'application/json',
                                          'Authorization': 'Bearer $token'
                                        });
                                    var responsebody =
                                        jsonDecode(response.body);
                                    if (responsebody['status'] == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  responsebody['message'])));
                                    } else {
                                      print(Text(responsebody['message']));
                                    }
                                  }

                                  await addToCart();
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
                } else {
                  return Container();
                }
              }

              return Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 48, 38, 135)),
              );
            },
          ))
        ],
      ),
    );
  }
}
