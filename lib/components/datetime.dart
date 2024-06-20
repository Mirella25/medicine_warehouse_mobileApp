import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ...

// ignore: must_be_immutable
class BasicDateField extends StatelessWidget {
  TextEditingController date;
  String labelText;
  String prefixText;
  final format = DateFormat("yyyy-MM-dd");

  BasicDateField(
      {super.key,
      required this.date,
      required this.labelText,
      required this.prefixText});
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        validator: (p0) {
          if (p0 == null) {
            return "This field is required";
          }
          return null;
        },
        controller: date,
        decoration: InputDecoration(
          labelText: labelText,
          prefixText: prefixText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
          ),
          fillColor: Colors.grey[200],
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          );
        },
      ),
    ]);
  }
}
