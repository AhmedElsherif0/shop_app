import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/utilities/custom_route.dart';

const TextStyle headLineTheme = TextStyle(
    color: Color(0xffffffff), fontSize: 20, fontFamily: 'RobotoCondensed');
const TextStyle textStyleTheme = TextStyle(
    color: Color(0xff6200ee), fontSize: 20, fontWeight: FontWeight.bold);

ThemeData themeLightMode = ThemeData(
    fontFamily: 'Raleway',
    primaryColor: Color(0xff6200ee),
    accentColor:Color(0xfff4511e),
    appBarTheme: AppBarTheme(
        color: Color(0xff6200ee),
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        )),
    pageTransitionsTheme: PageTransitionsTheme(
        builders: ({
      TargetPlatform.android: CustomRouteTransitionBuilder(),
      TargetPlatform.iOS: CustomRouteTransitionBuilder(),
    })),
    textTheme: const TextTheme(headline6: headLineTheme));
