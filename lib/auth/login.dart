import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart ';
import 'package:project/components/crud.dart';
import 'package:project/components/custombutton.dart';
import 'package:project/components/customlogo.dart';
import 'package:project/components/textformfield.dart';
import 'package:project/main.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isloading = false;

  logInUser() async {
    isloading = true;
    setState(() {});
    final data = {
      'phone_number': phonenumber.text.toString(),
      'password': password.text.toString(),
    };
    final response = await Crud().postRequest(
        route: '/user/login',
        data: data,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    final responsebody = jsonDecode(response.body);
    isloading = false;
    setState(() {});
    if (responsebody['status'] == true) {
      preferences.setString('token', responsebody['data']['token']);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responsebody['message'])));
      Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: '${response['message']}',
        btnOkOnPress: () {},
        btnOkColor: const Color.fromARGB(255, 220, 53, 41),
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 48, 38, 135)),
            )
          : ListView(
              children: [
                Container(height: 20),
                CustomLogo(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Container(
                          height: 15,
                        ),
                        Text(
                          "Login to continue using the app",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Container(
                          height: 20,
                        ),
                        Text(
                          "Phone Number",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          height: 15,
                        ),
                        CustomTextField(
                          hinttext: "Enter Your Phone Number",
                          mycontroller: phonenumber,
                          textInputType: TextInputType.number,
                          prefixIcon: Icon(Icons.phone),
                          obscureText: false,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "This field is required";
                            } else if (p0.length < 10 || p0.length > 10) {
                              return "The number must contain 10 digits";
                            } else if (!p0.startsWith('09')) {
                              return "The number must start with 09";
                            }
                            return null;
                          },
                        ),
                        Container(
                          height: 15,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          height: 15,
                        ),
                        CustomTextField(
                            hinttext: "Enter Your Password",
                            mycontroller: password,
                            textInputType: TextInputType.text,
                            obscureText: true,
                            prefixIcon: Icon(Icons.lock),
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return "This field is required";
                              }
                              if (p0.length < 8) {
                                return "The password must contain at least 8 characters";
                              }
                              return null;
                            }),
                        Container(
                          height: 65,
                        ),
                        CustomButton(
                          title: "Login",
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              await logInUser();
                            }
                          },
                        ),
                        Container(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      'register', (route) => false);
                                },
                                child: Text("Register",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 48, 38, 135),
                                        fontWeight: FontWeight.bold)))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
