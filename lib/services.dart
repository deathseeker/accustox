import 'package:accustox/color_scheme.dart';
import 'package:accustox/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'controllers.dart';
import 'database.dart';
import 'login_splash.dart';
import 'main.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final DatabaseService _db = DatabaseService();
final ScaffoldMessengerState _scaffoldMessengerState =
    scaffoldKey.currentState!;

class Services {
  static final Services _services = Services._privateConstructor();

  Services._privateConstructor();

  factory Services() {
    return _services;
  }

  Future<String> getInitialRoute() async {
    User? user = auth.currentUser;

    if (user != null) {
      bool userHasProfile = await _db.userCheck(user.uid);
      if (userHasProfile) {
        return '/';
      } else {
        return 'createProfile';
      }
    } else {
      return 'signIn';
    }
  }

  loginSplash() {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => const LoginSplash(), fullscreenDialog: true));
  }

  Future<bool> handleSignInWithGoogle() async {
    UserCredential userCredential = await signInWithGoogle();
    User user = userCredential.user!;
    bool userExists = await _db.userCheck(user.uid);
    return userExists;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  showSnackBarError(String errorMessage) {
    _scaffoldMessengerState.showSnackBar(SnackBar(
      backgroundColor: lightColorScheme.error,
      content: Text(
        errorMessage,
        style: TextStyle(color: lightColorScheme.onError),
      ),
    ));
  }

  showSnackBarErrorWithRetry(String errorMessage, VoidCallback retryOnError) {
    _scaffoldMessengerState.showSnackBar(SnackBar(
      backgroundColor: lightColorScheme.error,
      content: Text(
        errorMessage,
        style: TextStyle(color: lightColorScheme.onError),
      ),
      action: SnackBarAction(label: 'Retry?', onPressed: retryOnError),
    ));
  }

  showSnackBar(String message) {
    _scaffoldMessengerState.showSnackBar(SnackBar(
      content: Text(
        message,
      ),
    ));
  }

  hideCurrentSnackBar() {
    _scaffoldMessengerState.hideCurrentSnackBar();
  }

  showLoadingSnackBar(String message) {
    _scaffoldMessengerState.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16.0),
            Text(message),
          ],
        ),
        duration: const Duration(minutes: 1), // Adjust the duration as needed
      ),
    );
  }

  reviewAndSubmitProfile(
      {required GlobalKey<FormState> formKey,
      required String businessName,
      required String ownerName,
      required String email,
      required String contactNumber,
      required String address,
      required String uid}) {
    bool isValid = formKey.currentState!.validate();

    if (!isValid) {
      snackBarController.showSnackBarError('Please provide valid information.');
    } else {
      var userProfile = UserProfile(
          businessName: businessName,
          ownerName: ownerName,
          email: email,
          contactNumber: contactNumber,
          address: address,
          uid: uid);

      snackBarController.showSnackBar('Creating profile...');
      userController
          .createNewUser(uid: uid, userProfile: userProfile)
          .whenComplete(() async {
        bool userExists = await userController.checkNewUser();
        if (userExists) {
          navigationController.navigateToHome();
        } else {
          snackBarController.showSnackBarErrorWithRetry(
              'Something went wrong while creating your profile...',
              reviewAndSubmitProfile(
                  formKey: formKey,
                  businessName: businessName,
                  ownerName: ownerName,
                  email: email,
                  contactNumber: contactNumber,
                  address: address,
                  uid: uid));
        }
      });
    }
  }

  Future<bool> handleSystemBackButton() async {
    // Close the app if we're at the top of the navigation stack
    return !(navigatorKey.currentState?.canPop() ?? false);
  }

  popUntilHome() {
    return navigatorKey.currentState?.popUntil(ModalRoute.withName('home'));
  }

  navigateToPreviousPage() {
    return navigatorKey.currentState?.pop();
  }

  navigateToHome() {
    return navigatorKey.currentState?.pushReplacementNamed('home');
  }

  navigateToSignIn() {
    return navigatorKey.currentState?.pushReplacementNamed('signIn');
  }
}
