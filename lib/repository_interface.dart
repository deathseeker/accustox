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

  bool hasProfileChanged(
      {required UserProfile originalProfile,
      required UserProfileChangeNotifier notifier});

  reviewAndSubmitProfileUpdate(
      {required GlobalKey<FormState> formKey,
      required UserProfile originalProfile,
      required UserProfileChangeNotifier notifier});

  Future<void> addSalesperson(
      {required String uid, required Salesperson salesperson});

  Future<void> removeSalesperson(
      {required String uid, required Salesperson salesperson});

  Stream<SalespersonDocument> streamSalespersonDocument({required String uid});

  Stream<List<Salesperson>> streamSalespersonList({required String uid});
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

  navigateToEditProfile();
}

abstract class DialogInterface {
  addNewSalespersonDialog({required BuildContext context, required String uid});

  processAddSalesperson(
      {required String uid, required Salesperson salesperson});

  removeSalespersonDialog(
      {required BuildContext context,
      required String uid,
      required Salesperson salesperson});

  processRemoveSalesperson(
      {required String uid, required Salesperson salesperson});

  addCategoryDialog({required BuildContext context, required String uid});

  processAddCategory({required String uid, required Category category});

  removeCategoryDialog(
      {required BuildContext context,
      required String uid,
      required Category category});

  processRemoveCategory({required String uid, required Category category});

  addStockLocationDialog({required BuildContext context, required String uid});

  processAddParentLocation(
      {required String uid, required StockLocation stockLocation});

  removeLocationDialog(
      {required BuildContext context,
      required String uid,
      required StockLocation stockLocation});

  processRemoveLocation(
      {required String uid, required StockLocation stockLocation});
}

abstract class CategoryInterface {
  Future<void> addCategory({required String uid, required Category category});

  String getCategoryID();

  Stream<CategoryDocument> streamCategoryDocument({required String uid});

  Future<List<CategorySelectionData>> getCategoryListWithSelection(
      {required String uid});

  Future<List<Category>> getCategoryList({required String uid});

  Future<List<CategoryFilter>> getCategoryFilterList({required String uid});

  Stream<List<CategoryFilter>> getCategoryFilterListStream(
      {required String uid});

  Stream<List<CategorySelectionData>> streamCategorySelectionDataList(
      {required String uid});

  Stream<List<Category>> streamCategoryDataList({required String uid});

  Future<void> removeItemFromCategory(
      {required String uid, required String categoryID, required Item item});

  Future<void> editCategory(
      {required String uid,
      required Category oldCategory,
      required Category newCategory});

  Future<void> removeCategory(
      {required String uid, required Category category});

  Future<List<Category?>> getCategoryListForItem(
      {required String uid, required String itemID});
}

abstract class ItemInterface {
  String getItemID();

  Future<void> addItem({required String uid, required Item item});

  Stream<List<Item>> getFilteredItemsStreamByCategory(
      {required String uid, required String categoryID});

  Stream<List<Item>> streamItemDataList({required String uid});

  Future<void> removeItem({required String uid, required Item item});

  Future<void> updateItemAvailability(
      {required String uid, required Item item, required bool isItemAvailable});

  Future<void> updateItem(
      {required String uid, required Item oldItem, required Item newItem});
}

abstract class StockLocationInterface {
  String getLocationID();

  Future<void> addParentLocation(
      {required String uid, required StockLocation stockLocation});

  Stream<List<StockLocation>> streamParentLocationDataList(
      {required String uid});

  Future<void> removeParentLocation(
      {required String uid, required StockLocation stockLocation});

  Stream<List<StockLocation>> streamSubLocationDataList({required String path});
}
