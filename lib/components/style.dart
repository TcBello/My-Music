import 'package:flutter/material.dart';

const String montserrat = "Montserrat";
const String comfortaa = "Comfortaa";
const String hkGrotesk= "HK Grotesk";
const String chivo = "Chivo";

const Color color1 = Color(0xFF363636);
const Color color2 = Color(0xFF474747);
const Color color3 = Color(0xFFE8175D);
const Color color4 = Color(0xFFCC527A);
const Color color5 = Color(0xFFA8A7A7);

const TabBarTheme kTabBarTheme = TabBarTheme(
  labelColor: Colors.pinkAccent,
  unselectedLabelColor: Colors.white,
  labelStyle: TextStyle(
    color: Colors.pinkAccent,
    fontWeight: FontWeight.w600
  ),
  unselectedLabelStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600
  ),
);

const AppBarTheme kAppBarTheme = AppBarTheme(
  textTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20
    )
  ),
  titleTextStyle: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20
  )
);

TextTheme textTheme = TextTheme(
  headline4: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 40
  ),
  headline5: TextStyle(
    fontWeight: FontWeight.w600
  ),
  headline6: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20
  ),
  bodyText1: TextStyle(
    color: Colors.white
  ),
  bodyText2: TextStyle(
    color: Colors.white
  ),
  button: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w500,
    fontSize: 15
  ),
  caption: TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey[700]
  )
);

DialogTheme dialogTheme = DialogTheme(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  ),
  titleTextStyle: TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontSize: 20
  ),
  contentTextStyle: TextStyle(
    color: Colors.black,
    fontSize: 15
  )
);

CardTheme cardTheme = CardTheme(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  )
);

const TextStyle defaultStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w600
);

const TextStyle monserratStyle = TextStyle(
  color: Colors.white,
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w600
);

const TextStyle comfortaaStyle = TextStyle(
  color: Colors.white,
  fontFamily: comfortaa,
  fontSize: 16,
  fontWeight: FontWeight.w600
);

const TextStyle hkGroteskStyle = TextStyle(
  color: Colors.white,
  fontFamily: hkGrotesk,
  fontSize: 16,
  fontWeight: FontWeight.w600
);

const TextStyle chivoStyle = TextStyle(
  color: Colors.white,
  fontFamily: chivo,
  fontSize: 16,
  fontWeight: FontWeight.w600
);