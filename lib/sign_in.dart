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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
            child: Center(
              child: SizedBox(
                  height: 300.0,
                  width: 300.0,
                  child: Image.asset('assets/Logo_Transparent.png')),
            ),
          ),
          googleSignInButton(() async {
            //services.loginSplash();
            snackBarController.showLoadingSnackBar(message: 'Signing you in...');
            bool userExists = await signInController.handleSignInWithGoogle();
            if (userExists) {
              navigationController.navigateToHome();
              snackBarController.hideCurrentSnackBar();
            } else {
              signInController.navigateToCreateProfile();
              snackBarController.hideCurrentSnackBar();
            }
          }),

        ],
      ),
    );
  }
}