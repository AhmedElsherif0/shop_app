import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/product_screen.dart';
import 'package:shop_app/screen/splash_screen.dart';
import 'package:shop_app/utilities/constants.dart';

import 'widgets/general/multi_provider_list.dart';
import 'widgets/general/routes.dart';

void main() {
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderList.providerList,
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
            theme: kThemeData,
            debugShowCheckedModeBanner: false,
            home: auth.isAuth
                ? ProductScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (_, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: Routes().routes),
      ),
    );
  }
}
