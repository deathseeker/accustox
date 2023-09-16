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

  bool hasProfileChanged(
      {required UserProfile originalProfile,
      required UserProfileChangeNotifier notifier}) {
    return _userRepository.hasProfileChanged(
        originalProfile: originalProfile, notifier: notifier);
  }

  reviewAndSubmitProfileUpdate(
      {required GlobalKey<FormState> formKey,
      required UserProfile originalProfile,
      required UserProfileChangeNotifier notifier}) {
    return _userRepository.reviewAndSubmitProfileUpdate(
        formKey: formKey, originalProfile: originalProfile, notifier: notifier);
  }

  Future<void> addSalesperson(
      {required String uid, required Salesperson salesperson}) {
    return _userRepository.addSalesperson(uid: uid, salesperson: salesperson);
  }

  Future<void> removeSalesperson(
      {required String uid, required Salesperson salesperson}) {
    return _userRepository.removeSalesperson(
        uid: uid, salesperson: salesperson);
  }

  Stream<SalespersonDocument> streamSalespersonDocument({required String uid}) {
    return _userRepository.streamSalespersonDocument(uid: uid);
  }

  Stream<List<Salesperson>> streamSalespersonList({required String uid}) {
    return _userRepository.streamSalespersonList(uid: uid);
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
  final NavigationRepository _navigationRepository =
      NavigationRepository(Services());

  Future<bool> handleSystemBackButton() {
    return _navigationRepository.handleSystemBackButton();
  }

  navigateToHome() {
    return _navigationRepository.navigateToHome();
  }

  navigateToSignIn() {
    return _navigationRepository.navigateToSignIn();
  }

  popUntilHome() {
    return _navigationRepository.popUntilHome();
  }

  navigateToPreviousPage() {
    return _navigationRepository.navigateToPreviousPage();
  }

  navigateToEditProfile() {
    return _navigationRepository.navigateToEditProfile();
  }
}

final DialogController dialogController = DialogController();

class DialogController {
  final DialogRepository _dialogRepository = DialogRepository(Services());

  addNewSalespersonDialog(
      {required BuildContext context, required String uid}) {
    return _dialogRepository.addNewSalespersonDialog(
        context: context, uid: uid);
  }

  processAddSalesperson(
      {required String uid, required Salesperson salesperson}) {
    return _dialogRepository.processAddSalesperson(
        uid: uid, salesperson: salesperson);
  }

  removeSalespersonDialog(
      {required BuildContext context,
      required String uid,
      required Salesperson salesperson}) {
    return _dialogRepository.removeSalespersonDialog(
        context: context, uid: uid, salesperson: salesperson);
  }

  processRemoveSalesperson(
      {required String uid, required Salesperson salesperson}) {
    return _dialogRepository.processRemoveSalesperson(
        uid: uid, salesperson: salesperson);
  }

  addCategoryDialog({required BuildContext context, required String uid}) {
    return _dialogRepository.addCategoryDialog(context: context, uid: uid);
  }

  processAddCategory({required String uid, required Category category}) {
    return _dialogRepository.processAddCategory(uid: uid, category: category);
  }

  removeCategoryDialog(
      {required BuildContext context,
      required String uid,
      required Category category}) {
    return _dialogRepository.removeCategoryDialog(
        context: context, uid: uid, category: category);
  }

  processRemoveCategory({required String uid, required Category category}) {
    return _dialogRepository.processRemoveCategory(
        uid: uid, category: category);
  }
}

final CategoryController categoryController = CategoryController();

class CategoryController {
  final CategoryRepository _categoryRepository =
      CategoryRepository(DatabaseService(), Services());

  Future<void> addCategory({required String uid, required Category category}) {
    return _categoryRepository.addCategory(uid: uid, category: category);
  }

  String getCategoryID() {
    return _categoryRepository.getCategoryID();
  }

  Stream<CategoryDocument> streamCategoryDocument({required String uid}) {
    return _categoryRepository.streamCategoryDocument(uid: uid);
  }

  Future<List<CategorySelectionData>> getCategoryListWithSelection(
      {required String uid}) {
    return _categoryRepository.getCategoryListWithSelection(uid: uid);
  }

  Future<List<Category>> getCategoryList({required String uid}) {
    return _categoryRepository.getCategoryList(uid: uid);
  }

  Future<List<CategoryFilter>> getCategoryFilterList({required String uid}) {
    return _categoryRepository.getCategoryFilterList(uid: uid);
  }

  Stream<List<CategoryFilter>> getCategoryFilterListStream(
      {required String uid}) {
    return _categoryRepository.getCategoryFilterListStream(uid: uid);
  }

  Stream<List<CategorySelectionData>> streamCategorySelectionDataList(
      {required String uid}) {
    return _categoryRepository.streamCategorySelectionDataList(uid: uid);
  }

  Stream<List<Category>> streamCategoryDataList({required String uid}) {
    return _categoryRepository.streamCategoryDataList(uid: uid);
  }

  Future<void> removeItemFromCategory(
      {required String uid, required String categoryID, required Item item}) {
    return _categoryRepository.removeItemFromCategory(
        uid: uid, categoryID: categoryID, item: item);
  }

  Future<void> editCategory(
      {required String uid,
      required Category oldCategory,
      required Category newCategory}) {
    return _categoryRepository.editCategory(
        uid: uid, oldCategory: oldCategory, newCategory: newCategory);
  }

  Future<void> removeCategory(
      {required String uid, required Category category}) {
    return _categoryRepository.removeCategory(uid: uid, category: category);
  }

  Future<List<Category?>> getCategoryListForItem(
      {required String uid, required String itemID}) {
    return _categoryRepository.getCategoryListForItem(uid: uid, itemID: itemID);
  }
}

final ItemController itemController = ItemController();

class ItemController {
  final ItemRepository _itemRepository =
      ItemRepository(DatabaseService(), Services());

  String getItemID() {
    return _itemRepository.getItemID();
  }

  Future<void> addItem({required String uid, required Item item}) {
    return _itemRepository.addItem(uid: uid, item: item);
  }

  Stream<List<Item>> getFilteredItemsStreamByCategory(
      {required String uid, required String categoryID}) {
    return _itemRepository.getFilteredItemsStreamByCategory(
        uid: uid, categoryID: categoryID);
  }

  Stream<List<Item>> streamItemDataList({required String uid}) {
    return _itemRepository.streamItemDataList(uid: uid);
  }

  Future<void> removeItem({required String uid, required Item item}) {
    return _itemRepository.removeItem(uid: uid, item: item);
  }

  Future<void> updateItemAvailability(
      {required String uid,
      required Item item,
      required bool isItemAvailable}) {
    return _itemRepository.updateItemAvailability(
        uid: uid, item: item, isItemAvailable: isItemAvailable);
  }

  Future<void> updateItem(
      {required String uid, required Item oldItem, required Item newItem}) {
    return _itemRepository.updateItem(
        uid: uid, oldItem: oldItem, newItem: newItem);
  }
}
