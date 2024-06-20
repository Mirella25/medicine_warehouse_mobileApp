import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:project/medicine.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController search = TextEditingController();
  List<dynamic> originalCategories = [];
  List<dynamic> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    getMedicines().then((data) {
      setState(() {
        originalCategories = data['data'];
        filteredCategories = List.from(originalCategories);
      });
    });
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = originalCategories
          .where((category) => category['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future getMedicines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final response = await Crud().getRequest(route: "/all", headers: {
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
            "Categories",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                  onChanged: (value) {
                    filterCategories(value);
                  },
                  controller: search,
                  decoration: InputDecoration(
                    hintText: "Search for a category",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.grey,
                  )),
            ),
            Divider(
              color: Color.fromARGB(255, 183, 151, 240),
              thickness: 5,
            ),
            FutureBuilder(
              future: getMedicines(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Medicine(
                                medData: filteredCategories[index],
                              ),
                            ));
                          },
                          child: Card(
                            margin: EdgeInsets.all(15),
                            child: Container(
                                color: Color.fromARGB(255, 183, 151, 240),
                                height: 50,
                                child: Center(
                                    child: Text(
                                  "${filteredCategories[index]['name']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ))),
                          ),
                        );
                      },
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
        ));
  }
}
