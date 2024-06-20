import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const CustomButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.elliptical(10, 19)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        color: const Color.fromARGB(255, 48, 38, 135),
        minWidth: 500,
        height: 50,
      ),
    );
  }
}
