import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'enumerated_values.dart';
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

  navigateToNewSupplier();

  navigateToEditSupplier({required Supplier supplier});

  navigateToNewCustomerAccount();

  navigateToNewItem();

  navigateToEditItem({required Item item});
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

  processAddSubLocation(
      {required String uid,
      required StockLocation parentLocation,
      required StockLocation subLocation});

  addStockSubLocationDialog(
      {required BuildContext context,
      required String uid,
      required StockLocation parentLocation});

  removeSupplierDialog(
      {required BuildContext context,
      required String uid,
      required Supplier supplier});

  processRemoveSupplier({required String uid, required Supplier supplier});
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

  Future<void> addItem(
      {required String uid,
      required Item item,
      required Stock stock,
      required Inventory inventory});

  Stream<List<Item>> getFilteredItemsStreamByCategory(
      {required String uid, required String categoryID});

  Stream<List<Item>> streamItemDataList({required String uid});

  Future<void> removeItem({required String uid, required Item item});

  Future<void> updateItemAvailability(
      {required String uid, required Item item, required bool isItemAvailable});

  Future<void> updateItem(
      {required String uid, required Item oldItem, required Item newItem});

  reviewAndSubmitItem(
      {
        required GlobalKey<FormState> formKey,
        required ImageFile imageFile,
        required String uid,
        required ImageStorageUploadData imageStorageUploadData,
        required Item item,
        required WidgetRef ref,
        required String openingStock,
        required String costPrice,
        required String salePrice,
        required String expirationWarning,
        required String averageDailyDemand,
        required String maximumDailyDemand,
        required String averageLeadTime,
        required String maximumLeadTime,
        required Supplier? supplier,
        required StockLocation? stockLocation,
        required DateTime expirationDate,
        required String batchNumber,
        required DateTime purchaseDate,
      });

  reviewAndSubmitItemUpdate(
      {required GlobalKey<FormState> formKey,
      required WidgetRef ref,
      required ItemChangeNotifier itemChangeNotifier,
      required Item oldItem,
      required ImageFile imageFile,
      required uid,
      required ImageStorageUploadData imageStorageUploadData});

  Stream<List<Item>> streamCurrentItemList({required String uid});
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

  Future<void> addSubLocation(
      {required String uid,
      required StockLocation parentLocation,
      required StockLocation subLocation});

  Stream<List<StockLocation>> streamLocationDataList({required String uid});
}

abstract class SupplierInterface {
  Stream<List<Supplier>> streamSupplierDataList({required String uid});

  String getSupplierID();

  reviewAndSubmitSupplierProfile(
      {required GlobalKey<FormState> formKey,
      required String supplierName,
      required String contactPerson,
      required String email,
      required String contactNumber,
      required String address,
      required String uid});

  Future<void> addSupplier({required String uid, required Supplier supplier});

  Future<void> removeSupplier(
      {required String uid, required Supplier supplier});

  Future<void> editSupplier(
      {required String uid,
      required Supplier oldSupplier,
      required Supplier newSupplier});

  bool hasSupplierChanged(
      {required Supplier originalSupplier,
      required SupplierChangeNotifier notifier});

  reviewAndSubmitSupplierUpdate(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Supplier originalSupplier,
      required SupplierChangeNotifier notifier});
}

abstract class CustomerInterface {
  Stream<List<Customer>> streamCustomerDataList({required String uid});

  String getCustomerID();

  Future<void> addCustomer({required String uid, required Customer customer});

  reviewAndSubmitCustomerProfile(
      {required GlobalKey<FormState> formKey,
      required String customerName,
      required String contactPerson,
      required String email,
      required String contactNumber,
      required String address,
      required String customerType,
      required String uid});
}

abstract class ScannerInterface {
  Future<String> scanBarcode();

  Future<String> scanQRCode();
}

abstract class ImageRepositoryInterface {
  Future<File> getImage(
      {required bool isSourceCamera, required bool isCropStyleCircle});

  Future<void> uploadImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData,
      required VoidCallback retryOnError});

  Future<UploadTask> uploadCategoryImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData});

  Future<UploadTask> uploadItemImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData});
}

abstract class InventoryInterface {
  Stream<InventorySummary> streamInventorySummary(
      {required String uid, required String itemID});

  getStockLevelState(
      {required num stockLevel,
      required num safetyStockLevel,
      required num reorderPoint});

  Stream<List<Inventory>> streamInventory({required String uid});
}

abstract class DateTimeInterface {
  DateTime timestampToDateTime({required Timestamp timestamp});

  Timestamp dateTimeToTimestamp({required DateTime dateTime});

  Future<DateTime?> selectDate(
      {required BuildContext context,
      required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate});
}

abstract class PerishabilityInterface {
  bool enableExpirationDateInput({required Perishability perishability});
}

abstract class PluralizationInterface {
  String pluralize({required String noun, required num count});
}
