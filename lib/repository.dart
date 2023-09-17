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

  @override
  bool hasProfileChanged(
      {required UserProfile originalProfile,
      required UserProfileChangeNotifier notifier}) {
    return _services.hasProfileChanged(originalProfile, notifier);
  }

  @override
  reviewAndSubmitProfileUpdate(
      {required GlobalKey<FormState> formKey,
      required UserProfile originalProfile,
      required UserProfileChangeNotifier notifier}) {
    return _services.reviewAndSubmitProfileUpdate(
        formKey: formKey, originalProfile: originalProfile, notifier: notifier);
  }

  @override
  Future<void> addSalesperson(
      {required String uid, required Salesperson salesperson}) {
    return _db.addSalesperson(uid, salesperson);
  }

  @override
  Future<void> removeSalesperson(
      {required String uid, required Salesperson salesperson}) {
    return _db.removeSalesperson(uid, salesperson);
  }

  @override
  Stream<SalespersonDocument> streamSalespersonDocument({required String uid}) {
    return _db.streamSalespersonDocument(uid);
  }

  @override
  Stream<List<Salesperson>> streamSalespersonList({required String uid}) {
    return _db.streamSalespersonList(uid);
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

  @override
  navigateToEditProfile() {
    return _services.navigateToEditProfile();
  }
}

class DialogRepository implements DialogInterface {
  final Services _services;

  DialogRepository(this._services);

  @override
  addNewSalespersonDialog(
      {required BuildContext context, required String uid}) {
    return _services.addNewSalespersonDialog(context, uid);
  }

  @override
  processAddSalesperson(
      {required String uid, required Salesperson salesperson}) {
    return _services.processAddSalesperson(uid, salesperson);
  }

  @override
  removeSalespersonDialog(
      {required BuildContext context,
      required String uid,
      required Salesperson salesperson}) {
    return _services.removeSalespersonDialog(context, uid, salesperson);
  }

  @override
  processRemoveSalesperson(
      {required String uid, required Salesperson salesperson}) {
    return _services.processRemoveSalesperson(uid, salesperson);
  }

  @override
  addCategoryDialog({required BuildContext context, required String uid}) {
    return _services.addNewCategoryDialog(context, uid);
  }

  @override
  processAddCategory({required String uid, required Category category}) {
    return _services.processAddCategory(uid, category);
  }

  @override
  removeCategoryDialog(
      {required BuildContext context,
      required String uid,
      required Category category}) {
    return _services.removeCategoryDialog(context, uid, category);
  }

  @override
  processRemoveCategory({required String uid, required Category category}) {
    return _services.processRemoveCategory(uid, category);
  }

  @override
  addStockLocationDialog({required BuildContext context, required String uid}) {
    return _services.addStockLocationDialog(context, uid);
  }

  @override
  processAddParentLocation({required String uid, required StockLocation stockLocation}) {
    return _services.processAddParentLocation(uid, stockLocation);
  }

  @override
  removeLocationDialog({required BuildContext context, required String uid, required StockLocation stockLocation}) {
    return _services.removeLocationDialog(context, uid, stockLocation);
  }

  @override
  processRemoveLocation({required String uid, required StockLocation stockLocation}) {
    return _services.processRemoveLocation(uid, stockLocation);
  }
}

class CategoryRepository implements CategoryInterface {
  final DatabaseService _db;
  final Services _services;

  CategoryRepository(this._db, this._services);

  @override
  Future<void> addCategory({required String uid, required Category category}) {
    return _db.addCategory(uid, category);
  }

  @override
  String getCategoryID() {
    return _services.getCategoryID();
  }

  @override
  Stream<CategoryDocument> streamCategoryDocument({required String uid}) {
    return _db.streamCategoryDocument(uid);
  }

  @override
  Future<List<CategorySelectionData>> getCategoryListWithSelection(
      {required String uid}) {
    return _db.getCategoryListWithSelection(uid);
  }

  @override
  Future<List<Category>> getCategoryList({required String uid}) {
    return _db.getCategoryList(uid);
  }

  @override
  Future<List<CategoryFilter>> getCategoryFilterList({required String uid}) {
    return _db.getCategoryFilterList(uid);
  }

  @override
  Stream<List<CategoryFilter>> getCategoryFilterListStream(
      {required String uid}) {
    return _db.getCategoryFilterListStream(uid);
  }

  @override
  Stream<List<CategorySelectionData>> streamCategorySelectionDataList(
      {required String uid}) {
    return _db.streamCategorySelectionDataList(uid);
  }

  @override
  Stream<List<Category>> streamCategoryDataList({required String uid}) {
    return _db.streamCategoryDataList(uid);
  }

  @override
  Future<void> removeItemFromCategory(
      {required String uid, required String categoryID, required Item item}) {
    return _db.removeItemFromCategory(uid, categoryID, item);
  }

  @override
  Future<void> editCategory(
      {required String uid,
      required Category oldCategory,
      required Category newCategory}) {
    return _db.editCategory(uid, oldCategory, newCategory);
  }

  @override
  Future<void> removeCategory(
      {required String uid, required Category category}) {
    return _db.removeCategory(uid, category);
  }

  @override
  Future<List<Category?>> getCategoryListForItem(
      {required String uid, required String itemID}) {
    return _db.getCategoryListForItem(uid, itemID);
  }
}

class ItemRepository implements ItemInterface {
  final DatabaseService _db;
  final Services _services;

  ItemRepository(this._db, this._services);

  @override
  String getItemID() {
    return _services.getItemID();
  }

  @override
  Future<void> addItem({required String uid, required Item item}) {
    return _db.addItem(uid, item);
  }

  @override
  Stream<List<Item>> getFilteredItemsStreamByCategory(
      {required String uid, required String categoryID}) {
    return _db.getFilteredItemsStreamByCategory(uid, categoryID);
  }

  @override
  Stream<List<Item>> streamItemDataList({required String uid}) {
    return _db.streamItemDataList(uid);
  }

  @override
  Future<void> removeItem({required String uid, required Item item}) {
    return _db.removeItem(uid, item);
  }

  @override
  Future<void> updateItemAvailability(
      {required String uid,
      required Item item,
      required bool isItemAvailable}) {
    return _db.updateItemAvailability(uid, item, isItemAvailable);
  }

  @override
  Future<void> updateItem(
      {required String uid, required Item oldItem, required Item newItem}) {
    return _db.updateItem(uid, oldItem, newItem);
  }
}

class StockLocationRepository implements StockLocationInterface {
  final DatabaseService _db;
  final Services _services;

  StockLocationRepository(this._db, this._services);

  @override
  String getLocationID() {
    return _services.getLocationID();
  }

  @override
  Future<void> addParentLocation({required String uid, required StockLocation stockLocation}) {
    return _db.addParentLocation(uid, stockLocation);
  }

  @override
  Stream<List<StockLocation>> streamParentLocationDataList({required String uid}) {
    return _db.streamParentLocationDataList(uid);
  }

  @override
  Future<void> removeParentLocation({required String uid, required StockLocation stockLocation}) {
    return _db.removeParentLocation(uid, stockLocation);
  }

  @override
  Stream<List<StockLocation>> streamSubLocationDataList({required String path}) {
    return _db.streamSubLocationDataList(path);
  }

}
