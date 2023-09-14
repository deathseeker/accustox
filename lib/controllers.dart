import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'database.dart';
import 'main.dart';
import 'models.dart';
import 'repository.dart';
import 'services.dart';

AppController appController = AppController();

class AppController {
  final RoutingRepository _routingRepository = RoutingRepository(Services());

  Future<String> getInitialRoute() {
    Future<String> initialRoute = _routingRepository.getInitialRoute();

    return initialRoute;
  }
}

final SignInController signInController = SignInController();

class SignInController {
  final UserRepository _userRepository =
      UserRepository(DatabaseService(), Services());

  handleSignInWithGoogle() async {
    bool userExists = await _userRepository.handleSignInWithGoogle();

    return userExists;
  }

  void navigateToHome() {
    navigatorKey.currentState!.pushReplacementNamed('/');
  }

  void navigateToCreateProfile() {
    navigatorKey.currentState!.pushReplacementNamed('createProfile');
  }
}

final UserController userController = UserController();

class UserController {
  final UserRepository _userRepository =
      UserRepository(DatabaseService(), Services());

  Future<void> createNewUser(
      {required String uid, required UserProfile userProfile}) {
    return _userRepository.createNewUser(uid: uid, userProfile: userProfile);
  }

  Future<void> updateProfile({required UserProfile userProfile}) {
    return _userRepository.updateProfile(userProfile: userProfile);
  }

  Future<bool> checkNewUser() {
    return _userRepository.checkNewUser();
  }

  reviewAndSubmitProfile(
      {required GlobalKey<FormState> formKey,
      required String businessName,
      required String ownerName,
      required String email,
      required String contactNumber,
      required String address,
      required String uid}) {
    return _userRepository.reviewAndSubmitProfile(
        formKey: formKey,
        businessName: businessName,
        ownerName: ownerName,
        email: email,
        contactNumber: contactNumber,
        address: address,
        uid: uid);
  }

  Stream<User?> streamAuthStateChanges() {
    return _userRepository.streamAuthStateChanges();
  }

  Stream<UserProfile> streamUserProfile({required String uid}) {
    return _userRepository.streamUserProfile(uid: uid);
  }
}

final SnackBarController snackBarController = SnackBarController();

class SnackBarController {
  final SnackBarRepository _snackBarRepository = SnackBarRepository(Services());

  showSnackBarError(String errorMessage) {
    return _snackBarRepository.showSnackBarError(errorMessage);
  }

  showSnackBar(String message) {
    return _snackBarRepository.showSnackBar(message);
  }

  showSnackBarErrorWithRetry(String errorMessage, VoidCallback retryOnError) {
    return _snackBarRepository.showSnackBarErrorWithRetry(
        errorMessage: errorMessage, retryOnError: retryOnError);
  }

  showLoadingSnackBar({required String message}) {
    return _snackBarRepository.showLoadingSnackBar(message: message);
  }

  hideCurrentSnackBar() {
    return _snackBarRepository.hideCurrentSnackBar();
  }
}

final NavigationController navigationController = NavigationController();

class NavigationController {
  final NavigationRepository navigationRepository =
      NavigationRepository(Services());

  Future<bool> handleSystemBackButton() {
    return navigationRepository.handleSystemBackButton();
  }

  navigateToHome() {
    return navigationRepository.navigateToHome();
  }

  navigateToSignIn() {
    return navigationRepository.navigateToSignIn();
  }

  popUntilHome() {
    return navigationRepository.popUntilHome();
  }

  navigateToPreviousPage() {
    return navigationRepository.navigateToPreviousPage();
  }
}
