import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers.dart';
import 'models.dart';

final initialRouteProvider = FutureProvider<String>((ref) async {
  return appController.getInitialRoute();
});

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());

final StreamProvider<User?> _userProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final StreamProvider<User?> userStateProvider = StreamProvider<User?>((ref) {
  ref.watch(_userProvider);
  return userController.streamAuthStateChanges();
});

final StreamProvider<UserProfile> userProfileProvider =
    StreamProvider<UserProfile>((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return userController.streamUserProfile(uid: uid);
});
