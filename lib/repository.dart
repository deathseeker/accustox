import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'database.dart';
import 'models.dart';
import 'repository_interface.dart';
import 'services.dart';

class RoutingRepository implements RoutingInterface {
  final Services _services;

  RoutingRepository(this._services);

  @override
  Future<String> getInitialRoute() {
    Future<String> initialRoute = _services.getInitialRoute();
    return initialRoute;
  }
}

class UserRepository implements UserInterface {
  final DatabaseService _db;
  final Services _services;

  UserRepository(this._db, this._services);

  @override
  Future<bool> handleSignInWithGoogle() {
    return _services.handleSignInWithGoogle();
  }

  @override
  Future<void> createNewUser(
      {required String uid, required UserProfile userProfile}) {
    return _db.createNewUser(uid, userProfile);
  }

  @override
  Future<bool> checkNewUser() {
    return _db.checkNewUser();
  }

  @override
  Future<void> updateProfile({required UserProfile userProfile}) {
    return _db.updateProfile(userProfile);
  }

  @override
  reviewAndSubmitProfile(
      {required GlobalKey<FormState> formKey,
      required String businessName,
      required String ownerName,
      required String email,
      required String contactNumber,
      required String address,
      required String uid}) {
    return _services.reviewAndSubmitProfile(
        formKey: formKey,
        businessName: businessName,
        ownerName: ownerName,
        email: email,
        contactNumber: contactNumber,
        address: address,
        uid: uid);
  }

  @override
  Stream<User?> streamAuthStateChanges() {
    return _db.streamAuthStateChanges();
  }

  @override
  Stream<UserProfile> streamUserProfile({required String uid}) {
    return _db.streamUserProfile(uid);
  }
}

class SnackBarRepository implements SnackBarInterface {
  final Services _services;

  SnackBarRepository(this._services);

  @override
  showSnackBarError(String errorMessage) {
    return _services.showSnackBarError(errorMessage);
  }

  @override
  showSnackBar(String message) {
    return _services.showSnackBar(message);
  }

  @override
  showSnackBarErrorWithRetry(
      {required String errorMessage, required VoidCallback retryOnError}) {
    return _services.showSnackBarErrorWithRetry(errorMessage, retryOnError);
  }

  @override
  showLoadingSnackBar({required String message}) {
    return _services.showLoadingSnackBar(message);
  }

  @override
  hideCurrentSnackBar() {
    return _services.hideCurrentSnackBar();
  }
}

class NavigationRepository implements NavigationRepositoryInterface {
  final Services _services;

  NavigationRepository(this._services);

  @override
  Future<bool> handleSystemBackButton() {
    return _services.handleSystemBackButton();
  }

  @override
  popUntilHome() {
    return _services.popUntilHome();
  }

  @override
  navigateToHome() {
    return _services.navigateToHome();
  }

  @override
  navigateToSignIn() {
    return _services.navigateToSignIn();
  }

  @override
  navigateToPreviousPage() {
    return _services.navigateToPreviousPage();
  }

}
