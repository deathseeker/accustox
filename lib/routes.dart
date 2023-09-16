

import 'package:accustox/edit_profile.dart';
import 'package:flutter/material.dart';
import 'app_open_splash.dart';
import 'create_profile.dart';
import 'error_splash.dart';
import 'home.dart';
import 'sign_in.dart';

Map<String, Widget Function(BuildContext)> routes(BuildContext context) {
  Map<String, Widget Function(BuildContext)> routes = {
    'home': (context) => const Home(),
    'signIn': (context) => const SignIn(),
    'createProfile': (context) => const CreateProfile(),
    'appOpenSplash': (context) => const AppOpenSplash(),
    'errorSplash': (context) => const ErrorSplash(),
    'editProfile': (context) =>  const EditProfile(),
  };

  return routes;
}