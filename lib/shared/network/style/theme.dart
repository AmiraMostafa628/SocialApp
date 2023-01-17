

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'color.dart';

ThemeData darkTheme = ThemeData(
    fontFamily: 'Jannah',
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
        backgroundColor: HexColor('333739'),
        titleSpacing: 20,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: HexColor('333739'),
            statusBarIconBrightness: Brightness.light
        ),
        titleTextStyle: TextStyle(
            fontFamily: 'Jannah',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold
        )
    ),
    scaffoldBackgroundColor:HexColor('333739'),
    cardColor: HexColor('333739'),
    hintColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: HexColor('333739'),
      elevation: 20.0,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey[400],

    ),

    textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white
      ),
      subtitle1: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.white
      ),

    )
);

ThemeData lightTheme =ThemeData(
  fontFamily: 'Jannah',
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white ,
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleSpacing: 20,
      iconTheme: IconThemeData(
          color: Colors.black ),
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark
      ),
      titleTextStyle: TextStyle(
          fontFamily: 'Jannah',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          height: 1.3
      )

  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 20.0,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey[400],
      backgroundColor: Colors.white
  ),
  textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.black
      ),
      subtitle1: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        //height: 1.4
    ),

  ),
);