import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models.dart';

abstract class RoutingInterface {
  Future<String> getInitialRoute();
}

abstract class UserInterface {
  Future<bool> handleSignInWithGoogle();

  Future<void> createNewUser(
      {required String uid, required UserProfile userProfile});

  Future<bool> checkNewUser();

  Future<void> updateProfile({required UserProfile userProfile});

  reviewAndSubmitProfile(
      {required GlobalKey<FormState> formKey,
        required String businessName,
        required String ownerName,
        required String email,
        required String contactNumber,
        required String address,
        required String uid});

  Stream<User?> streamAuthStateChanges();
  Stream<UserProfile> streamUserProfile({required String uid});
}

abstract class SnackBarInterface {
  showSnackBarError(String errorMessage);

  showSnackBar(String message);

  showSnackBarErrorWithRetry(
      {required String errorMessage, required VoidCallback retryOnError});

  hideCurrentSnackBar();

  showLoadingSnackBar({required String message});
}

abstract class NavigationRepositoryInterface {
  Future<bool> handleSystemBackButton();

  popUntilHome();

  navigateToHome();

  navigateToSignIn();

  navigateToPreviousPage();

}
