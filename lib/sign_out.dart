import 'package:firebase_auth/firebase_auth.dart';
import 'controllers.dart';
import 'text_theme.dart';
import 'package:flutter/material.dart';

class SignOut extends StatelessWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Are you signing out?',
            style: customTextStyle.headlineMedium,
          ),
          const Padding(padding: EdgeInsets.only(top: 32.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () =>
                      navigationController.navigateToPreviousPage(),
                  child: const Text('No')),
              const Padding(padding: EdgeInsets.only(left: 32.0)),
              FilledButton(
                  onPressed: () => _signOut(), child: const Text('Yes'))
            ],
          )
        ],
      ),
    );
  }
}

Future<void> _signOut() async {
  navigationController.navigateToPreviousPage();
  snackBarController.showLoadingSnackBar(message: 'Signing out...');
  await FirebaseAuth.instance
      .signOut()
      .whenComplete(() => snackBarController.hideCurrentSnackBar());
  navigationController.navigateToSignIn();
}
