import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:project/components/custombutton.dart';
import 'package:project/components/customlogo.dart';
import 'package:project/components/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // cities
  List<String> cities = ['Damascus', 'Homs', 'Aleppo', 'Latakkia'];
  //regions
  List<String> damasRegions = ['Abbasyeen', 'Midan', 'Salhieh', 'Jaramana'];
  List<String> homsRegions = ['Homs City', 'Palmyra', 'Sadad', 'Fairouzeh'];
  List<String> alepRegions = [
    'Aleppo City',
    'Hamdanieh',
    'Salah Al Deen',
    'Merdian'
  ];
  List<String> latRegions = [
    'Latakkia City',
    'Jableh',
    'Quardaha',
    'Ain Al Baidda'
  ];
  //damascus streets
  List<String> abbasStreets = ['Square', 'Main Road'];
  List<String> midanStreets = ['Souk', 'Jazmatieh'];
  List<String> salhStreets = ['Al shuhadaa', 'Al Arabiyah'];
  List<String> jaraStreets = ['Qrrayyat', 'Rawdah'];
  //homs streets
  List<String> homsStreets = ['Bab Al Sebaa', 'Hamedieh'];
  List<String> palStreets = ['Ancient Souk', 'Center Square'];
  List<String> sadadStreets = ['Al Dalleh', 'Al Souk'];
  List<String> faiStreets = ['Al Nawras', 'Al Alieh'];
  //aleppo streets
  List<String> alepStreets = ['Jamelieh', 'Slemanieh'];
  List<String> hamStreets = ['Main Souk', 'Main Square'];
  List<String> salahStreets = ['Main Road', 'Al Sabeel'];
  List<String> merStreets = ['Mokambo', 'Al Ahmadeih'];
  //latakia streets
  List<String> latStreets = ['Al Samak Square', 'Al Raiedieh'];
  List<String> jabStreets = ['Main Road', 'Souk Al Ahmad'];
  List<String> quarStreets = ['Al Akram', 'The Square'];
  List<String> ainStreets = ['Al Bustan', 'Al Ashraf'];
  //...
  List<String> regions = [];
  String? selectedCity;
  String? selectedRegion;
  List<String> streets = [];
  String? selectedStreet;
  bool isloading = false;
  GlobalKey<FormState> form = GlobalKey();
  TextEditingController username = TextEditingController();
  TextEditingController pharmacy = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
//postRequest
  registerUser() async {
    isloading = true;
    setState(() {});
    var data = {
      'name': username.text.toString(),
      'pharmacy_name': pharmacy.text.toString(),
      'city': selectedCity.toString(),
      'region': selectedRegion.toString(),
      'street': selectedStreet.toString(),
      'phone_number': phonenumber.text.toString(),
      'password': password.text.toString(),
      'password_confirmation': confirmpassword.text.toString(),
    };

    var response = await Crud().postRequest(
        route: '/user/register',
        data: data,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    var responsebody = jsonDecode(response.body);
    isloading = false;
    setState(() {});
    if (responsebody['status'] == true) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('token', responsebody['data']['token']);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responsebody['message'])));
      Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: '${responsebody['message']['phone_number']}',
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
                    key: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                        ),
                        Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Container(
                          height: 15,
                        ),
                        Text(
                          "Enter Your Personal Information",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Container(
                          height: 20,
                        ),
                        Text(
                          "Username",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          height: 15,
                        ),
                        CustomTextField(
                          hinttext: "Enter Your Name",
                          mycontroller: username,
                          textInputType: TextInputType.name,
                          prefixIcon: Icon(Icons.person),
                          obscureText: false,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        Container(
                          height: 20,
                        ),
                        Text(
                          "Pharmacy Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          height: 15,
                        ),
                        CustomTextField(
                          hinttext: "Enter Your Pharmacy's Name",
                          mycontroller: pharmacy,
                          textInputType: TextInputType.name,
                          prefixIcon: Icon(Icons.local_pharmacy),
                          obscureText: false,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        Container(
                          height: 15,
                        ),
                        Text(
                          "City",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          height: 15,
                        ),
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.elliptical(10, 10)),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 252, 19, 3),
                                )),
                            errorStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 252, 19, 3),
                                fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(10, 10)),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          hint: Text('Select Your City'),
                          value: selectedCity,
                          isExpanded: true,
                          items: cities.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (city) {
                            if (city == 'Damascus') {
                              regions = damasRegions;
                            } else if (city == 'Homs') {
                              regions = homsRegions;
                            } else if (city == 'Aleppo') {
                              regions = alepRegions;
                            } else if (city == 'Latakkia') {
                              regions = latRegions;
                            } else {
                              regions = [];
                            }
                            setState(() {
                              selectedRegion = null;
                              selectedCity = city;
                            });
                          },
                        ),
                        Container(
                          height: 15,
                        ),
                        Text(
                          "Region",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          height: 15,
                        ),
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.elliptical(10, 10)),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 252, 19, 3),
                                )),
                            errorStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 252, 19, 3),
                                fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(10, 10)),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          hint: Text('Select Your Region'),
                          value: selectedRegion,
                          isExpanded: true,
                          items: regions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (region) {
                            if (region == 'Abbasyeen') {
                              streets = abbasStreets;
                            } else if (region == 'Midan') {
                              streets = midanStreets;
                            } else if (region == 'Salhieh') {
                              streets = salhStreets;
                            } else if (region == 'Jaramana') {
                              streets = jaraStreets;
                            } else if (region == 'Homs City') {
                              streets = homsStreets;
                            } else if (region == 'Palmyra') {
                              streets = palStreets;
                            } else if (region == 'Sadad') {
                              streets = sadadStreets;
                            } else if (region == 'Fairouzeh') {
                              streets = faiStreets;
                            } else if (region == 'Aleppo City') {
                              streets = alepStreets;
                            } else if (region == 'Hamdanieh') {
                              streets = hamStreets;
                            } else if (region == 'Salah Al Deen') {
                              streets = salahStreets;
                            } else if (region == 'Merdian') {
                              streets = merStreets;
                            } else if (region == 'Latakkia City') {
                              streets = latStreets;
                            } else if (region == 'Jableh') {
                              streets = jabStreets;
                            } else if (region == 'Quardaha') {
                              streets = quarStreets;
                            } else if (region == 'Ain Al Baidda') {
                              streets = ainStreets;
                            } else {
                              streets = [];
                            }
                            setState(() {
                              selectedStreet = null;
                              selectedRegion = region;
                            });
                          },
                        ),
                        Container(
                          height: 15,
                        ),
                        Text(
                          "Street",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          height: 15,
                        ),
                        DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.elliptical(10, 10)),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 252, 19, 3),
                                )),
                            errorStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 252, 19, 3),
                                fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(10, 10)),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          hint: Text('Select Your Street'),
                          value: selectedStreet,
                          isExpanded: true,
                          items: streets.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (street) {
                            setState(() {
                              selectedStreet = street;
                            });
                          },
                        ),
                        Container(
                          height: 15,
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
                          textInputType: TextInputType.phone,
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
                              } else if (p0.length < 8) {
                                return "The password must contain at least 8 characters";
                              }
                              return null;
                            }),
                        Container(
                          height: 15,
                        ),
                        Text(
                          "Confirm Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          height: 15,
                        ),
                        CustomTextField(
                            hinttext: "Confirm Your Password",
                            mycontroller: confirmpassword,
                            textInputType: TextInputType.text,
                            obscureText: true,
                            prefixIcon: Icon(Icons.lock_person),
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return "This field is required";
                              } else if (p0 != password.text) {
                                return "Password confirmation doesn't match";
                              }
                              return null;
                            }),
                        Container(
                          height: 50,
                        ),
                        CustomButton(
                          title: "Register",
                          onPressed: () async {
                            if (form.currentState!.validate()) {
                              await registerUser();
                            }
                          },
                        ),
                        Container(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have an account?",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      'login', (route) => false);
                                },
                                child: Text("Login",
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
