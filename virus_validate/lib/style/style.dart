import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color primaryColor = Color.fromARGB(255, 24, 94, 121);
const Color primaryDarkColor = Color.fromARGB(255, 13, 58, 64);
const Color primaryLightColor = Color.fromARGB(255, 49, 249, 239);

const double standardText = 15.0;
const double largeText = 18.0;
const double smallText = 12.0;

DateFormat myDateFormat = DateFormat('MM-dd-yyyy');
DateFormat myTimeFormat = DateFormat('h:mm a');

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

void snackBar(BuildContext context, String text) => 
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

InputDecoration inputStyling(String labelText, {hintText}) =>
  InputDecoration(labelText: labelText, hintText: hintText, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))));

myHeaderText(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
    child: Text(text, style: const TextStyle(
      fontSize: largeText,
      fontWeight: FontWeight.bold 
      ),
    ),
  );
}

myStandardText(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
    child: Text(
      text, 
      style: const TextStyle(
        fontSize: standardText,
      ),
    ),
  );
}

OutlineInputBorder myInputBorder(){ //return type is OutlineInputBorder
  return const OutlineInputBorder( //Outline border type for TextFeild
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
        // color:Colors.redAccent,
        width: 3,
      )
  );
}