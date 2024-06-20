import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hinttext;
  final TextInputType textInputType;
  final TextEditingController mycontroller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.textInputType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      keyboardType: textInputType,
      controller: mycontroller,
      onChanged: onChanged,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 252, 19, 3),
            )),
        errorStyle: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 252, 19, 3),
            fontWeight: FontWeight.w600),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
    );
  }
}
