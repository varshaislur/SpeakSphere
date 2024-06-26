import 'package:flutter/material.dart';


ThemeData lightTheme = ThemeData(
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //     style: ButtonStyle(
    //         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
    //             EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
    //         ),
    //         shape: MaterialStateProperty.all<OutlinedBorder>(
    //             RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(20.0))
    //         ),
    //         backgroundColor: MaterialStateProperty.all<Color>(Color(0xffb74093))
    //     )
    // ),

  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff0f5132),
   brightness: Brightness.light),




);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xff0f5132),
    brightness: Brightness.dark,
  ).copyWith(
    primary: Color(0xff0f5132),
    onPrimary: Colors.white,
    secondary: Color(0xff0f5132),
    onSecondary: Colors.white,
  ),
);