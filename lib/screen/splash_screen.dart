import 'package:flutter/material.dart';
import 'package:shop_app/utilities/constants.dart';
import '../widgets/general/custom_circular_progress.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading...', style: textStyleTheme),
            SizedBox(width: 4),
            CustomCircularProgress(),
          ],
        ),
      ),
    );
  }
}
