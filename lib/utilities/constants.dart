import 'package:flutter/material.dart';
import 'package:shop_app/utilities/custom_route.dart';

const TextStyle headLineTheme = TextStyle(
    color: Color(0xffffffff), fontSize: 20, fontFamily: 'RobotoCondensed');
const TextStyle textStyleTheme =
    TextStyle(color: Colors.purpleAccent, fontSize: 20, fontWeight: FontWeight.bold);

const baseAppUrl = 'https://shop-app-374e3-default-rtdb.firebaseio.com';
const apiKey = 'AIzaSyAh2Bg5dh4dKEddHWG5PwO-JebPrvvy5sM';
const baseAuthUrl = 'https://identitytoolkit.googleapis.com';

ThemeData kThemeData = ThemeData(
    fontFamily: 'Raleway',
    primaryColor: Colors.purpleAccent,
    accentColor: Colors.pinkAccent,
    pageTransitionsTheme: PageTransitionsTheme(
        builders: ({
      TargetPlatform.android: CustomRouteTransitionBuilder(),
      TargetPlatform.iOS: CustomRouteTransitionBuilder(),
    })),
    textTheme: const TextTheme(headline6: headLineTheme));
