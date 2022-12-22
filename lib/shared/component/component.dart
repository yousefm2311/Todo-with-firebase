// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultFormField({
  required String text,
  required TextInputType type,
  required IconData perfix,
  required TextEditingController controller,
  IconData? suffix,
  VoidCallback? suffixButton,
  bool isPassword = false,
  String? Function(String?)? validator,
  VoidCallback? ontap,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: isPassword,
        keyboardType: type,
        onTap: ontap,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          // labelText: text,
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(12.0),
          ),
          prefixIcon: Icon(perfix),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixButton,
                  icon: Icon(suffix),
                )
              : null,
        ),
      ),
    );

Widget defaultButton({required String text, void Function()? onpressed}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: MaterialButton(
          onPressed: onpressed,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );

// ignore: constant_identifier_names
Future<bool?> defaultToast({
  required String text,
  required ToastColor color,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseColor(color),
        textColor: Colors.white,
        fontSize: 14.0);

enum ToastColor { SUCCESS, ERROR, WANING }

Color chooseColor(ToastColor state) {
  Color color;
  switch (state) {
    case ToastColor.SUCCESS:
      color = Colors.green;
      break;
    case ToastColor.ERROR:
      color = Colors.redAccent;
      break;
    case ToastColor.WANING:
      color = Colors.red;
      break;
  }
  return color;
}
