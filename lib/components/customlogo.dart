import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            child: ClipRRect(
                child: Image.asset(
              "images/1703057726807.png",
              fit: BoxFit.cover,
            )),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
            width: 180,
            height: 150,
          ),
          Text("DrugSwift",
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Lobster",
                  color: Color.fromARGB(229, 139, 139, 139))),
        ],
      ),
    );
  }
}
