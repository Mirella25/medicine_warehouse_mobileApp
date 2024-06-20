import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  TextEditingController search = TextEditingController();
  List<dynamic> originalId = [];
  List<dynamic> filteredId = [];
  @override
  void initState() {
    super.initState();
    allOrders().then((data) {
      setState(() {
        originalId = data['data'];
        filteredId = List.from(originalId);
      });
    });
  }

  void filterId(String query) {
    setState(() {
      filteredId = originalId
          .where((id) =>
              id['id'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future allOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final response =
        await Crud().getRequest(route: "/user/showorders", headers: {
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
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
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
            "Orders",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                  onChanged: (value) {
                    filterId(value);
                  },
                  controller: search,
                  decoration: InputDecoration(
                    hintText: "Search for order number",
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
              child: FutureBuilder(
                future: allOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: filteredId.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: (itemWidth / itemHeight),
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color.fromARGB(255, 183, 151, 240),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      filteredId[index]['details'].length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      margin:
                                          EdgeInsets.only(right: 5, left: 5),
                                      child: Column(
                                        children: [
                                          Text(
                                            "${filteredId[index]['details'][i]['caliber']['commercial']['commercial_name']}${filteredId[index]['details'][i]['caliber']['caliber'] == null ? "" : snapshot.data['data'][index]['details'][i]['caliber']['caliber']}",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                              "quantity:${filteredId[index]['details'][i]['quantity']}"),
                                          Divider(
                                              color: Color.fromARGB(
                                                  255, 227, 190, 251))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                color: Color.fromARGB(255, 227, 190, 251),
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "${filteredId[index]['status']}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                color: Color.fromARGB(255, 227, 190, 251),
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "${filteredId[index]['id']}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
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
              ),
            ),
          ],
        ));
  }
}
