import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 24, 94, 121);
const Color primaryDarkColor = Color.fromARGB(255, 13, 58, 64);
const Color primaryLightColor = Color.fromARGB(255, 49, 249, 239);

const double standardText = 15.0;
const double largeText = 18.0;
const double smallText = 12.0;

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

void snackBar(BuildContext context, String text) => 
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

InputDecoration inputStyling(String labelText, {hintText}) =>
  InputDecoration(labelText: labelText, hintText: hintText, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))));

myHeaderText(String text) {
  return Text(text, style: const TextStyle(
      fontSize: largeText,
      fontWeight: FontWeight.bold
    ),
  );
}

myStandardText(String text) {
  return Text(
    text, 
    style: const TextStyle(
      fontSize: standardText,
    ),
  );
}