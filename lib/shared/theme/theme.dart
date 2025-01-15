import 'package:flutter/material.dart';

import '../constant/constant.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: 'NotoSansArabic',
    useMaterial3: true,
    appBarTheme:  const AppBarTheme(color: kPrimaryColor,titleTextStyle: TextStyle(color: Colors.white,fontSize: 24),),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
    ),
    cardColor: kPrimaryLightColor,
  );
