import 'package:flutter/material.dart';

class details extends StatefulWidget {
  final name;
  final company;
  final price;
  final quantity;
  final date;
  final comName;
  final caliberData;
  details({
    super.key,
    this.name,
    this.company,
    this.price,
    this.quantity,
    this.date,
    this.comName,
    this.caliberData,
  });

  @override
  State<details> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<details> {
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 48, 38, 135),
        centerTitle: true,
        title: Text(
          "Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 4),
          height: 28,
          width: 500,
        ),
        Container(
          padding: EdgeInsets.all(10),
          color: Color.fromARGB(255, 183, 151, 240),
          child: Text(
            "${widget.comName}" "${widget.caliberData}",
            style: TextStyle(
                fontSize: 25, color: Color.fromARGB(255, 48, 38, 135)),
          ),
        ),
        Container(
          height: 30,
        ),
        Expanded(
          child: ListView(children: [
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 48, 38, 135),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Card(
                  color: Color.fromARGB(255, 183, 151, 240),
                  margin: EdgeInsets.all(10),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Container(
                      height: 35,
                      child: ListTile(
                        leading: Text(
                          "Scientific Name:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          widget.name.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )),
            ),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 48, 38, 135),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Card(
                  color: Color.fromARGB(255, 183, 151, 240),
                  margin: EdgeInsets.all(10),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Container(
                      height: 35,
                      child: ListTile(
                        leading: Text("Company:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        title: Text(widget.company.toString(),
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  )),
            ),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 48, 38, 135),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Card(
                  color: Color.fromARGB(255, 183, 151, 240),
                  margin: EdgeInsets.all(10),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Container(
                      height: 35,
                      child: ListTile(
                        leading: Text("Price:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        title: Text(widget.price.toString(),
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  )),
            ),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 48, 38, 135),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Card(
                  color: Color.fromARGB(255, 183, 151, 240),
                  margin: EdgeInsets.all(10),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Container(
                      height: 35,
                      child: ListTile(
                        leading: Text("Quantity:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        title: Text(widget.quantity.toString(),
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  )),
            ),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 48, 38, 135),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Card(
                  color: Color.fromARGB(255, 183, 151, 240),
                  margin: EdgeInsets.all(10),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Container(
                      height: 35,
                      child: ListTile(
                        leading: Text("Expiration Date:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        title: Text(widget.date.toString(),
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  )),
            ),
          ]),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 4),
          height: 28,
          width: 500,
        ),
      ]),
    );
  }
}
