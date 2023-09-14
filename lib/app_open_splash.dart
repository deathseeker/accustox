import 'package:flutter/material.dart';
import 'theme_text.dart';

class AppOpenSplash extends StatelessWidget {
  const AppOpenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Image.asset('assets/Logo_Primary, Merchant.png'),
              const Padding(padding: EdgeInsets.only(top: 16.0)),
              const CircularProgressIndicator(),
              const Padding(padding: EdgeInsets.only(top: 8.0)),
              Text(
                'Welcome...',
                style: customTextStyle.labelMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}