import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:project/components/crud.dart';
import 'package:project/components/custombutton.dart';
import 'package:project/components/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //cities
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
  GlobalKey<FormState> form = GlobalKey();
  TextEditingController username = TextEditingController();
  TextEditingController pharmacy = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  //...
  editProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final data = {
      'name': username.text.toString(),
      'pharmacy_name': pharmacy.text.toString(),
      'city': selectedCity.toString(),
      'region': selectedRegion.toString(),
      'street': selectedStreet.toString(),
      'phone_number': phonenumber.text.toString(),
    };

    final response = await Crud()
        .postRequest(route: '/user/editprofile', data: data, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    final responsebody = jsonDecode(response.body);

    if (responsebody['status'] == true) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 183, 151, 240),
            title: Text("Message"),
            content: Text(responsebody['message']),
            actions: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('home', (route) => false);
                },
                child: Text("Ok"),
              )
            ],
          );
        },
      );
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: '${responsebody['message']}',
        btnOkOnPress: () {},
        btnOkColor: const Color.fromARGB(255, 220, 53, 41),
      )..show();
    }
  }

  @override
  void initState() {
    super.initState();
    getSavedUserData();
  }

  getSavedUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    var response = await Crud().getRequest(route: "/user/profile", headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var responsebody = jsonDecode(response.body);
    setState(() {});
    return {
      username.text = responsebody['data']['name'],
      pharmacy.text = responsebody['data']['pharmacy_name'],
      selectedCity = responsebody['data']['city'],
      selectedRegion = responsebody['data']['region'],
      selectedStreet = responsebody['data']['street'],
      phonenumber.text = responsebody['data']['phone_number']
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 48, 38, 135),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      height: 50,
                    ),
                    CustomButton(
                      title: "Edit",
                      onPressed: () async {
                        if (form.currentState!.validate()) {
                          await editProfile();
                        }
                      },
                    ),
                    Container(
                      height: 40,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
