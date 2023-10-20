import 'package:flutter/material.dart';
import 'theme_text.dart';

class LoginSplash extends StatelessWidget {
  const LoginSplash({super.key});

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
              SizedBox(
                height: 300.0,
                width: 300.0,
                child: Image.asset(
                  'assets/Fingerprint-bro.png',
                  fit: BoxFit.contain,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 16.0)),
              const CircularProgressIndicator(),
              const Padding(padding: EdgeInsets.only(top: 8.0)),
              Text(
                'Signing in...',
                style: customTextStyle.labelMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
