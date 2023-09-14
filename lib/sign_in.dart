import 'package:flutter/material.dart';
import 'controllers.dart';
import 'services.dart';
import 'widget_components.dart';

final Services services = Services();

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
            child: Center(
              child: SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: Image.asset('assets/Logo_Primary, Merchant.png')),
            ),
          ),
          googleSignInButton(() async {
            services.loginSplash();
            bool userExists = await signInController.handleSignInWithGoogle();
            userExists
                ? signInController.navigateToHome()
                : signInController.navigateToCreateProfile();
          }),

        ],
      ),
    );
  }
}