import 'package:flutter/material.dart';
import 'theme_text.dart';

class ErrorSplash extends StatelessWidget {
  const ErrorSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Image.asset('assets/Logo_Primary, Merchant.png'),
              const Padding(padding: EdgeInsets.only(top: 16.0)),
              Text(
                'We are sorry. Something Went Wrong...',
                style: customTextStyle.labelMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
