import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'enumerated_values.dart';
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

  @override
  navigateToNewSupplier() {
    return _services.navigateToNewSupplier();
  }

  @override
  navigateToEditSupplier({required Supplier supplier}) {
    return _services.navigateToEditSupplier(supplier);
  }

  @override
  navigateToNewCustomerAccount() {
    return _services.navigateToNewCustomerAccount();
  }

  @override
  navigateToNewItem() {
    return _services.navigateToNewItem();
  }

  @override
  navigateToNewPurchaseOrder() {
    return _services.navigateToNewPurchaseOrder();
  }

  @override
  navigateToEditItem({required Item item}) {
    return _services.navigateToEditItem(item);
  }

  @override
  navigateToCurrentInventoryDetails(
      {required CurrentInventoryData currentInventoryData}) {
    return _services.navigateToCurrentInventoryDetails(currentInventoryData);
  }

  @override
  navigateToAddInventory({required Inventory inventory}) {
    return _services.navigateToAddInventory(inventory);
  }

  @override
  navigateToMoveInventory({required Stock stock}) {
    return _services.navigateToMoveInventory(stock);
  }

  @override
  navigateToAdjustInventory({required Stock stock}) {
    return _services.navigateToAdjustInventory(stock);
  }

  @override
  navigateToAddItemToPurchaseOrder() {
    return _services.navigateToAddItemToPurchaseOrder();
  }

  @override
  navigateToPurchaseOrderDetails({required PurchaseOrder purchaseOrder}) {
    return _services.navigateToPurchaseOrderDetails(purchaseOrder);
  }

  @override
  navigateToEditPurchaseOrder({required PurchaseOrder purchaseOrder}) {
    return _services.navigateToEditPurchaseOrder(purchaseOrder);
  }

  @override
  navigateToIncomingInventoryManagement(
      {required PurchaseOrder purchaseOrder}) {
    return _services.navigateToIncomingInventoryManagement(purchaseOrder);
  }

  @override
  navigateToNewInventoryStockFromPurchaseOrder(
      {required PurchaseOrderItem purchaseOrderItem,
      required PurchaseOrder purchaseOrder}) {
    return _services.navigateToNewInventoryStockFromPurchaseOrder(
        purchaseOrderItem, purchaseOrder);
  }

  @override
  navigateToProcessSalesOrder() {
    return _services.navigateToProcessSalesOrder();
  }

  @override
  navigateToCustomerAccountDetails({required Customer customer}) {
    return _services.navigateToCustomerAccountDetails(customer);
  }

  @override
  navigateToSalesOrderDetails({required String salesOrderID}) {
    return _services.navigateToSalesOrderDetails(salesOrderID);
  }

  @override
  navigateToSalesReportDetails({required String dateInYYYYMMDD}) {
    return _services.navigateToSalesReportDetails(dateInYYYYMMDD);
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
  processAddParentLocation(
      {required String uid, required StockLocation stockLocation}) {
    return _services.processAddParentLocation(uid, stockLocation);
  }

  @override
  removeLocationDialog(
      {required BuildContext context,
      required String uid,
      required StockLocation stockLocation}) {
    return _services.removeLocationDialog(context, uid, stockLocation);
  }

  @override
  processRemoveLocation(
      {required String uid, required StockLocation stockLocation}) {
    return _services.processRemoveLocation(uid, stockLocation);
  }

  @override
  addStockSubLocationDialog(
      {required BuildContext context,
      required String uid,
      required StockLocation parentLocation}) {
    return _services.addStockSubLocationDialog(context, uid, parentLocation);
  }

  @override
  processAddSubLocation(
      {required String uid,
      required StockLocation parentLocation,
      required StockLocation subLocation}) {
    return _services.processAddSubLocation(uid, parentLocation, subLocation);
  }

  @override
  removeSupplierDialog(
      {required BuildContext context,
      required String uid,
      required Supplier supplier}) {
    return _services.removeSupplierDialog(context, uid, supplier);
  }

  @override
  processRemoveSupplier({required String uid, required Supplier supplier}) {
    return _services.processRemoveSupplier(uid, supplier);
  }

  @override
  addPurchaseItemOrderDialog(
      {required BuildContext context,
      required Item item,
      required WidgetRef ref}) {
    return _services.addPurchaseItemOrderDialog(context, item, ref);
  }

  @override
  editPurchaseItemOrderDialog(
      {required BuildContext context,
      required PurchaseOrderItem purchaseOrderItem,
      required WidgetRef ref}) {
    return _services.editPurchaseItemOrderDialog(
        context, purchaseOrderItem, ref);
  }

  @override
  placeOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced}) {
    return _services.placeOrderDialog(context, uid, purchaseOrder, orderPlaced);
  }

  @override
  cancelOrderPlacementDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced}) {
    return _services.cancelOrderPlacementDialog(
        context, uid, purchaseOrder, orderPlaced);
  }

  @override
  orderConfirmationDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed}) {
    return _services.orderConfirmationDialog(
        context, uid, purchaseOrder, orderConfirmed);
  }

  @override
  cancelOrderConfirmationDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed}) {
    return _services.cancelOrderConfirmationDialog(
        context, uid, purchaseOrder, orderConfirmed);
  }

  @override
  cancelPurchaseOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder}) {
    return _services.cancelPurchaseOrderDialog(context, uid, purchaseOrder);
  }

  @override
  receivePurchaseOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder}) {
    return _services.receivePurchaseOrderDialog(context, uid, purchaseOrder);
  }

  @override
  processSetAsRetailStock(
      {required String uid, required String itemID, required Stock stock}) {
    return _services.processSetAsRetailStock(uid, itemID, stock);
  }

  @override
  setAsRetailStockDialog(
      {required BuildContext context,
      required String uid,
      required String itemID,
      required Stock stock}) {
    return _services.setAsRetailStockDialog(context, uid, itemID, stock);
  }

  @override
  processRemoveFromRetailStock(
      {required String uid, required String itemID, required Stock stock}) {
    return _services.processRemoveFromRetailStock(uid, itemID, stock);
  }

  @override
  removeFromRetailStockDialog(
      {required BuildContext context,
      required String uid,
      required String itemID,
      required Stock stock}) {
    return _services.removeFromRetailStockDialog(context, uid, itemID, stock);
  }

  @override
  addCustomItemOrderDialog(
      {required BuildContext context,
      required WidgetRef ref,
      required RetailItem retailItem}) {
    return _services.addCustomItemOrderDialog(context, ref, retailItem);
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
  Future<void> addItem(
      {required String uid,
      required Item item,
      required Stock stock,
      required Inventory inventory}) {
    return _db.addItem(uid, item, stock, inventory);
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

  @override
  reviewAndSubmitItem(
      {required GlobalKey<FormState> formKey,
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
      required DateTime purchaseDate}) {
    return _services.reviewAndSubmitItem(
        formKey: formKey,
        imageFile: imageFile,
        uid: uid,
        imageStorageUploadData: imageStorageUploadData,
        item: item,
        ref: ref,
        openingStock: openingStock,
        costPrice: costPrice,
        salePrice: salePrice,
        expirationWarning: expirationWarning,
        averageDailyDemand: averageDailyDemand,
        maximumDailyDemand: maximumDailyDemand,
        averageLeadTime: averageLeadTime,
        maximumLeadTime: maximumLeadTime,
        supplier: supplier,
        stockLocation: stockLocation,
        expirationDate: expirationDate,
        batchNumber: batchNumber,
        purchaseDate: purchaseDate);
  }

  @override
  reviewAndSubmitItemUpdate(
      {required GlobalKey<FormState> formKey,
      required WidgetRef ref,
      required ItemChangeNotifier itemChangeNotifier,
      required Item oldItem,
      required ImageFile imageFile,
      required uid,
      required ImageStorageUploadData imageStorageUploadData}) {
    return _services.reviewAndSubmitItemUpdate(
        formKey: formKey,
        ref: ref,
        itemChangeNotifier: itemChangeNotifier,
        oldItem: oldItem,
        imageFile: imageFile,
        uid: uid,
        imageStorageUploadData: imageStorageUploadData);
  }

  @override
  Stream<List<Item>> streamCurrentItemList({required String uid}) {
    return _db.streamCurrentItemList(uid);
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
  Future<void> addParentLocation(
      {required String uid, required StockLocation stockLocation}) {
    return _db.addParentLocation(uid, stockLocation);
  }

  @override
  Stream<List<StockLocation>> streamParentLocationDataList(
      {required String uid}) {
    return _db.streamParentLocationDataList(uid);
  }

  @override
  Future<void> removeParentLocation(
      {required String uid, required StockLocation stockLocation}) {
    return _db.removeParentLocation(uid, stockLocation);
  }

  @override
  Stream<List<StockLocation>> streamSubLocationDataList(
      {required String path}) {
    return _db.streamSubLocationDataList(path);
  }

  @override
  Future<void> addSubLocation(
      {required String uid,
      required StockLocation parentLocation,
      required StockLocation subLocation}) {
    return _db.addSubLocation(uid, parentLocation, subLocation);
  }

  @override
  Stream<List<StockLocation>> streamLocationDataList({required String uid}) {
    return _db.streamLocationDataList(uid);
  }
}

class SupplierRepository implements SupplierInterface {
  final DatabaseService _db;
  final Services _services;

  SupplierRepository(this._db, this._services);

  @override
  Stream<List<Supplier>> streamSupplierDataList({required String uid}) {
    return _db.streamSupplierDataList(uid);
  }

  @override
  String getSupplierID() {
    return _services.getSupplierID();
  }

  @override
  reviewAndSubmitSupplierProfile(
      {required GlobalKey<FormState> formKey,
      required String supplierName,
      required String contactPerson,
      required String email,
      required String contactNumber,
      required String address,
      required String uid}) {
    return _services.reviewAndSubmitSupplierProfile(
        formKey: formKey,
        supplierName: supplierName,
        contactPerson: contactPerson,
        email: email,
        contactNumber: contactNumber,
        address: address,
        uid: uid);
  }

  @override
  Future<void> addSupplier({required String uid, required Supplier supplier}) {
    return _db.addSupplier(uid, supplier);
  }

  @override
  Future<void> removeSupplier(
      {required String uid, required Supplier supplier}) {
    return _db.removeSupplier(uid, supplier);
  }

  @override
  Future<void> editSupplier(
      {required String uid,
      required Supplier oldSupplier,
      required Supplier newSupplier}) {
    return _db.editSupplier(uid, oldSupplier, newSupplier);
  }

  @override
  bool hasSupplierChanged(
      {required Supplier originalSupplier,
      required SupplierChangeNotifier notifier}) {
    return _services.hasSupplierChanged(originalSupplier, notifier);
  }

  @override
  reviewAndSubmitSupplierUpdate(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Supplier originalSupplier,
      required SupplierChangeNotifier notifier}) {
    return _services.reviewAndSubmitSupplierUpdate(
        formKey: formKey,
        uid: uid,
        originalSupplier: originalSupplier,
        notifier: notifier);
  }
}

class CustomerRepository implements CustomerInterface {
  final DatabaseService _db;
  final Services _services;

  CustomerRepository(this._db, this._services);

  @override
  Stream<List<Customer>> streamCustomerDataList({required String uid}) {
    return _db.streamCustomerDataList(uid);
  }

  @override
  String getCustomerID() {
    return _services.getCustomerID();
  }

  @override
  Future<void> addCustomer({required String uid, required Customer customer}) {
    return _db.addCustomer(uid, customer);
  }

  @override
  reviewAndSubmitCustomerProfile(
      {required GlobalKey<FormState> formKey,
      required String customerName,
      required String contactPerson,
      required String email,
      required String contactNumber,
      required String address,
      required String customerType,
      required String uid}) {
    return _services.reviewAndSubmitCustomerProfile(
        formKey: formKey,
        customerName: customerName,
        contactPerson: contactPerson,
        email: email,
        contactNumber: contactNumber,
        address: address,
        customerType: customerType,
        uid: uid);
  }

  @override
  Stream<CustomerAccount> streamCustomerAccount(
      {required String uid, required String customerID}) {
    return _db.streamCustomerAccount(uid, customerID);
  }
}

class ScannerRepository implements ScannerInterface {
  final Services _services;

  ScannerRepository(this._services);

  @override
  Future<String> scanBarcode() {
    return _services.scanBarcode();
  }

  @override
  Future<String> scanQRCode() {
    return _services.scanQRCode();
  }

  @override
  Future<void> streamBarcodes({required WidgetRef ref}) {
    return _services.streamBarcodes(ref);
  }
}

class ImageRepository implements ImageRepositoryInterface {
  final DatabaseService _db;

  ImageRepository(this._db);

  @override
  Future<File> getImage(
      {required bool isSourceCamera, required bool isCropStyleCircle}) async {
    File imageFile = await _db.getImage(
        isSourceCamera: isSourceCamera, isCropStyleCircle: isCropStyleCircle);
    return imageFile;
  }

  @override
  Future<void> uploadImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData,
      required VoidCallback retryOnError}) {
    Future<void> data =
        _db.uploadImage(image, uid, path, imageStorageUploadData, retryOnError);
    return data;
  }

  @override
  Future<UploadTask> uploadCategoryImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData}) {
    Future<UploadTask> uploadTask =
        _db.uploadCategoryImage(image, uid, path, imageStorageUploadData);
    return uploadTask;
  }

  @override
  Future<UploadTask> uploadItemImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData}) {
    Future<UploadTask> uploadTask =
        _db.uploadItemImage(image, uid, path, imageStorageUploadData);
    return uploadTask;
  }
}

class InventoryRepository implements InventoryInterface {
  final DatabaseService _db;
  final Services _services;

  InventoryRepository(this._db, this._services);

  @override
  Stream<InventorySummary> streamInventorySummary(
      {required String uid, required String itemID}) {
    return _db.streamInventorySummary(uid, itemID);
  }

  @override
  getStockLevelState(
      {required num stockLevel,
      required num safetyStockLevel,
      required num reorderPoint}) {
    return _services.getStockLevelState(
        stockLevel, safetyStockLevel, reorderPoint);
  }

  @override
  Stream<List<Inventory>> streamInventoryList({required String uid}) {
    return _db.streamInventoryList(uid);
  }

  @override
  Stream<List<Stock>> streamStockList(
      {required String uid, required String itemID}) {
    return _db.streamStockList(uid, itemID);
  }

  @override
  Stream<List<Stock>> streamRetailStockList(
      {required String uid, required String itemID}) {
    return _db.streamRetailStockList(uid, itemID);
  }

  @override
  Future<void> addInventoryStock(
      {required String uid,
      required String itemID,
      required Stock stock,
      required Inventory inventory,
      required double newLeadTime}) {
    return _db.addInventoryStock(uid, itemID, stock, inventory, newLeadTime);
  }

  @override
  reviewAndSubmitStock(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Item item,
      required String openingStock,
      required String costPrice,
      required String salePrice,
      required String expirationWarning,
      required Supplier? supplier,
      required StockLocation? stockLocation,
      required DateTime expirationDate,
      required String batchNumber,
      required DateTime purchaseDate,
      required Inventory inventory,
      required String newLeadTime}) {
    return _services.reviewAndSubmitStock(
        formKey,
        uid,
        item,
        openingStock,
        costPrice,
        salePrice,
        expirationWarning,
        supplier,
        stockLocation,
        expirationDate,
        batchNumber,
        purchaseDate,
        inventory,
        newLeadTime);
  }

  @override
  Future<void> updateInventoryStatisticsOnStockAdd(
      {required String uid,
      required String itemID,
      required Inventory inventory,
      required double newLeadTime,
      required double stockLevel,
      required double costPrice}) {
    return _db.updateInventoryStatisticsOnStockAdd(
        uid, itemID, inventory, newLeadTime, stockLevel, costPrice);
  }

  @override
  Stream<Inventory> streamInventory(
      {required String uid, required String itemID}) {
    return _db.streamInventory(uid, itemID);
  }

  @override
  double getAdjustedStockLevelForMovement(
      {required double currentStockLevel, required double adjustment}) {
    return _services.getAdjustedStockLevelForMovement(
        currentStockLevel, adjustment);
  }

  @override
  Future<void> moveInventoryStock(
      {required String uid,
      required Stock currentStock,
      required Stock movedStock}) {
    return _db.moveInventoryStock(uid, currentStock, movedStock);
  }

  @override
  reviewAndMoveInventory(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required StockLocation? newStockLocation,
      required String movedStockLevel,
      required Stock currentStock}) {
    return _services.reviewAndMoveInventory(
        formKey, uid, newStockLocation, movedStockLevel, currentStock);
  }

  @override
  Stream<List<InventoryTransaction>> streamInventoryTransactionList(
      {required String uid, required Inventory inventory}) {
    return _db.streamInventoryTransactionList(uid, inventory);
  }

  @override
  Future<void> inventoryStockLevelAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedStockLevel,
      required String reason}) {
    return _db.inventoryStockLevelAdjustment(
        uid, stock, adjustedStockLevel, reason);
  }

  @override
  Future<void> costPriceAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedCostPrice,
      required String reason}) {
    return _db.costPriceAdjustment(uid, stock, adjustedCostPrice, reason);
  }

  @override
  Future<void> salePriceAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedSalePrice,
      required String reason}) {
    return _db.salePriceAdjustment(uid, stock, adjustedSalePrice, reason);
  }

  @override
  reviewAndAdjustStockLevel(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedStockLevel,
      required String reason}) {
    return _services.reviewAndAdjustStockLevel(
        formKey, uid, stock, adjustedStockLevel, reason);
  }

  @override
  reviewAndAdjustCostPrice(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedCostPrice,
      required String reason}) {
    return _services.reviewAndAdjustCostPrice(
        formKey, uid, stock, adjustedCostPrice, reason);
  }

  @override
  reviewAndAdjustSalePrice(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedSalePrice,
      required String reason}) {
    return _services.reviewAndAdjustSalePrice(
        formKey, uid, stock, adjustedSalePrice, reason);
  }

  @override
  Future<void> addStockToRetailStock(
      {required String uid, required String itemID, required Stock stock}) {
    return _db.addStockToRetailStock(uid, itemID, stock);
  }

  @override
  Future<void> removeStockFromRetailStock(
      {required String uid, required String itemID, required Stock stock}) {
    return _db.removeStockFromRetailStock(uid, itemID, stock);
  }

  @override
  Future<void> adjustRetailStockFromSalesOrder(
      {required String uid,
      required String itemID,
      required Stock adjustedStock,
      required String reason}) {
    return _db.adjustRetailStockFromSalesOrder(
        uid, itemID, adjustedStock, reason);
  }
}

class DateTimeRepository implements DateTimeInterface {
  final Services _services;

  DateTimeRepository(this._services);

  @override
  Timestamp dateTimeToTimestamp({required DateTime dateTime}) {
    return _services.dateTimeToTimestamp(dateTime);
  }

  @override
  DateTime timestampToDateTime({required Timestamp timestamp}) {
    return _services.timestampToDateTime(timestamp);
  }

  @override
  Future<DateTime?> selectDate(
      {required BuildContext context,
      required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate}) {
    return _services.selectDate(context, initialDate, firstDate, lastDate);
  }

  @override
  String formatDateTimeToYMd({required DateTime dateTime}) {
    return _services.formatDateTimeToYMd(dateTime);
  }

  @override
  ExpirationState getExpirationState(
      {required DateTime expirationDate, required double expirationWarning}) {
    return _services.getExpirationState(expirationDate, expirationWarning);
  }

  @override
  int getDaysToExpiration({required DateTime expirationDate}) {
    return _services.getDaysToExpiration(expirationDate);
  }

  @override
  String formatDateTimeToYMdjm({required DateTime dateTime}) {
    return _services.formatDateTimeToYMdjm(dateTime);
  }

  @override
  double leadTimeFromPO(
      {required DateTime orderPlacedOn, required DateTime orderDeliveredOn}) {
    return _services.leadTimeFromPO(orderPlacedOn, orderDeliveredOn);
  }

  @override
  String formatDateTimeToYYYYMMDD({required DateTime date}) {
    return _services.formatDateTimeToYYYYMMDD(date);
  }
}

class PerishabilityRepository implements PerishabilityInterface {
  final Services _services;

  PerishabilityRepository(this._services);

  @override
  bool enableExpirationDateInput({required Perishability perishability}) {
    return _services.enableExpirationDateInput(perishability);
  }

  @override
  Perishability getPerishabilityState({required String perishabilityString}) {
    return _services.getPerishabilityState(
        perishabilityString: perishabilityString);
  }
}

class PluralizationRepository implements PluralizationInterface {
  final Services _services;

  PluralizationRepository(this._services);

  @override
  String pluralize({required String noun, required num count}) {
    return _services.pluralize(noun, count);
  }
}

class CurrencyRepository implements CurrencyInterface {
  final Services _services;

  CurrencyRepository(this._services);

  @override
  String formatAsPhilippineCurrency({required num amount}) {
    return _services.formatAsPhilippineCurrency(amount);
  }

  @override
  String formatAsPhilippineCurrencyWithoutSymbol({required num amount}) {
    return _services.formatAsPhilippineCurrencyWithoutSymbol(amount);
  }

  @override
  String getAveragePrice({required double quantity, required double total}) {
    return _services.getAveragePrice(quantity, total);
  }
}

class StatisticsRepository implements StatisticsInterface {
  final Services _services;

  StatisticsRepository(this._services);

  @override
  double getAverageLeadTime(
      {required double oldAverageLeadTime, required newLeadTime}) {
    return _services.getAverageLeadTime(oldAverageLeadTime, newLeadTime);
  }

  @override
  double getInventoryValue(
      {required double stockLevel, required double costPrice}) {
    return _services.getInventoryValue(stockLevel, costPrice);
  }

  @override
  double getMaximumLeadTime(
      {required double oldMaximumLeadTime, required double newLeadTime}) {
    return _services.getMaximumLeadTime(oldMaximumLeadTime, newLeadTime);
  }

  @override
  double getReorderPoint(
      {required double averageLeadTime,
      required double averageDailyDemand,
      required double safetyStockLevel}) {
    return _services.getReorderPoint(
        averageLeadTime, averageDailyDemand, safetyStockLevel);
  }

  @override
  double getSafetyStockLevel(
      {required double maximumLeadTime,
      required double maximumDailyDemand,
      required double averageDailyDemand,
      required double averageLeadTime}) {
    return _services.getSafetyStockLevel(maximumLeadTime, maximumDailyDemand,
        averageDailyDemand, averageLeadTime);
  }

  @override
  Map<String, dynamic> getInventoryStatisticsOnStockAdd(
      {required Inventory inventory,
      required double newLeadTime,
      required double stockLevel,
      required double costPrice}) {
    return _services.getInventoryStatisticsOnStockAdd(
        inventory, newLeadTime, stockLevel, costPrice);
  }
}

class ValidatorRepository implements ValidatorInterface {
  final Services _services;

  ValidatorRepository(this._services);

  @override
  bool isPositiveDoubleBelowOrEqualToCount(
      {required String input, required double maxCount}) {
    return _services.isPositiveDoubleBelowOrEqualToCount(input, maxCount);
  }
}

class PurchaseOrderRepository implements PurchaseOrderInterface {
  final Services _services;
  final DatabaseService _databaseService;

  PurchaseOrderRepository(this._services, this._databaseService);

  @override
  String createPurchaseOrderNumber({required int a}) {
    return _services.createPurchaseOrderNumber(a);
  }

  @override
  Future<void> addPurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder}) {
    return _databaseService.addPurchaseOrder(uid, purchaseOrder);
  }

  @override
  reviewAndSubmitPurchaseOrder(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Supplier? supplier,
      required String? deliveryAddress,
      required DateTime? expectedDeliveryDate,
      required List<PurchaseOrderItem>? purchaseOrderItemList}) {
    return _services.reviewAndSubmitPurchaseOrder(
        formKey: formKey,
        uid: uid,
        supplier: supplier,
        deliveryAddress: deliveryAddress,
        expectedDeliveryDate: expectedDeliveryDate,
        purchaseOrderItemList: purchaseOrderItemList);
  }

  @override
  Stream<List<PurchaseOrder>> streamIncomingInventoryList(
      {required String uid}) {
    return _databaseService.streamIncomingInventoryList(uid);
  }

  @override
  getIncomingInventoryState(
      {required bool orderPlaced,
      required bool orderConfirmed,
      required bool orderDelivered}) {
    return _services.getIncomingInventoryState(
        orderPlaced, orderConfirmed, orderDelivered);
  }

  @override
  Stream<PurchaseOrder> streamPurchaseOrder(
      {required String uid, required String purchaseOrderID}) {
    return _databaseService.streamPurchaseOrder(uid, purchaseOrderID);
  }

  @override
  Future<void> updateOrderPlacedStatus(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced}) {
    return _databaseService.updateOrderPlacedStatus(
        uid, purchaseOrder, orderPlaced);
  }

  @override
  Future<void> updateOrderConfirmedStatus(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed}) {
    return _databaseService.updateOrderConfirmedStatus(
        uid, purchaseOrder, orderConfirmed);
  }

  @override
  Future<void> cancelPurchaseOrder(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required String reason}) {
    return _databaseService.cancelPurchaseOrder(uid, purchaseOrder, reason);
  }

  @override
  checkIfPurchaseOrderChanged(
      {required PurchaseOrder originalPurchaseOrder,
      required PurchaseOrder newPurchaseOrder}) {
    return _services.checkIfPurchaseOrderChanged(
        originalPurchaseOrder, newPurchaseOrder);
  }

  @override
  Future<void> updatePurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder}) {
    return _databaseService.updatePurchaseOrder(uid, purchaseOrder);
  }

  @override
  processEditPurchaseOrder(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required PurchaseOrder originalPurchaseOrder,
      required PurchaseOrder newPurchaseOrder}) {
    return _services.processEditPurchaseOrder(
        formKey, uid, originalPurchaseOrder, newPurchaseOrder);
  }

  @override
  Future<void> receivePurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder}) {
    return _databaseService.receivePurchaseOrder(uid, purchaseOrder);
  }

  @override
  Future<void> addInventoryStockFromPO(
      {required String uid,
      required String itemID,
      required Stock stock,
      required Inventory inventory,
      required double newLeadTime,
      required PurchaseOrder purchaseOrder}) {
    return _databaseService.addInventoryStockFromPO(
        uid, itemID, stock, inventory, newLeadTime, purchaseOrder);
  }

  @override
  reviewAndSubmitStockFromPO(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Item item,
      required double stockLevel,
      required double costPrice,
      required String salePrice,
      required String expirationWarning,
      required Supplier? supplier,
      required StockLocation? stockLocation,
      required DateTime expirationDate,
      required String batchNumber,
      required DateTime purchaseDate,
      required Inventory inventory,
      required PurchaseOrder purchaseOrder}) {
    return _services.reviewAndSubmitStockFromPO(
        formKey,
        uid,
        item,
        stockLevel,
        costPrice,
        salePrice,
        expirationWarning,
        supplier,
        stockLocation,
        expirationDate,
        batchNumber,
        purchaseDate,
        inventory,
        purchaseOrder);
  }

  @override
  Future<void> completeInventoryAndPurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder}) {
    return _databaseService.completeInventoryAndPurchaseOrder(
        uid, purchaseOrder);
  }
}

class SalesOrderRepository implements SalesOrderInterface {
  final Services _services;
  final DatabaseService _databaseService;

  SalesOrderRepository(this._services, this._databaseService);

  @override
  Stream<List<RetailItem>> streamRetailItemDataList({required String uid}) {
    return _databaseService.streamRetailItemDataList(uid);
  }

  @override
  SalesOrderItem getSalesOrderItem(
      {required RetailItem retailItem, required double quantity}) {
    return _services.getSalesOrderItem(retailItem, quantity);
  }

  @override
  List<Stock> getAdjustedStocksFromSO(
      {required RetailItem retailItem, required double quantity}) {
    return _services.getAdjustedStocksFromSO(retailItem, quantity);
  }

  @override
  addSalesOrderItem(
      {required WidgetRef ref,
      required RetailItem retailItem,
      required double stockLimit,
      required double count}) {
    return _services.addSalesOrderItem(ref, retailItem, stockLimit, count);
  }

  @override
  addCustomSalesOrderItem(
      {required WidgetRef ref,
      required RetailItem retailItem,
      required double stockLimit,
      required double quantity}) {
    return _services.addCustomSalesOrderItem(
        ref, retailItem, stockLimit, quantity);
  }

  @override
  String createSalesOrderNumber({required int a}) {
    return _services.createSalesOrderNumber(a);
  }

  @override
  Future<void> addSalesOrder(
      {required String uid,
      required SalesOrder salesOrder,
      required List<Stock> adjustedStockList}) {
    return _databaseService.addSalesOrder(uid, salesOrder, adjustedStockList);
  }

  @override
  Future<void> incrementSaleToDailyDemand(
      {required String uid, required String itemID, required double sales}) {
    return _databaseService.incrementSaleToDailyDemand(uid, itemID, sales);
  }

  @override
  submitRetailSalesOrder(
      {required String uid,
      required List<SalesOrderItem> salesOrderItemList,
      required String? paymentTerms,
      required String? orderTotal,
      required List<Stock> stockList}) {
    return _services.submitRetailSalesOrder(
        uid: uid,
        salesOrderItemList: salesOrderItemList,
        paymentTerms: paymentTerms,
        orderTotal: orderTotal,
        stockList: stockList);
  }

  @override
  Future<void> updateInventoryStatisticsOnSale(
      {required String uid, required String itemID}) {
    return _databaseService.updateInventoryStatisticsOnSale(uid, itemID);
  }

  @override
  Future<void> addAccountSalesOrder(
      {required String uid,
      required SalesOrder salesOrder,
      required List<Stock> adjustedStockList}) {
    return _databaseService.addAccountSalesOrder(
        uid, salesOrder, adjustedStockList);
  }

  @override
  reviewAndSubmitAccountSalesOrder(
      {required String uid,
      required List<SalesOrderItem> salesOrderItemList,
      required Customer? customer,
      required String? paymentTerms,
      required String? orderTotal,
      required List<Stock> stockList}) {
    return _services.reviewAndSubmitAccountSalesOrder(
        uid: uid,
        salesOrderItemList: salesOrderItemList,
        customer: customer,
        paymentTerms: paymentTerms,
        orderTotal: orderTotal,
        stockList: stockList);
  }

  @override
  Future<SalesOrder> fetchSalesOrder(
      {required String uid, required String salesOrderID}) {
    return _databaseService.fetchSalesOrder(uid, salesOrderID);
  }

  @override
  Stream<List<SalesOrder>> streamSalesOrders({required String uid}) {
    return _databaseService.streamSalesOrders(uid);
  }

  @override
  Stream<List<SalesOrder>> streamCurrentSalesOrders({required String uid}) {
    return _databaseService.streamCurrentSalesOrders(uid);
  }
}

class StringRepository implements StringInterface {
  final Services _services;

  StringRepository(this._services);

  @override
  String removeTrailingZeros({required double value}) {
    return _services.removeTrailingZeros(value);
  }
}

class ReportsRepository implements ReportsInterface {
  final DatabaseService _databaseService;

  ReportsRepository(this._databaseService);

  @override
  Future<void> updateDailySalesReport(
      {required String uid, required SalesOrder salesOrder}) {
    return _databaseService.updateDailySalesReport(uid, salesOrder);
  }

  @override
  Future<SalesReports> fetchSalesReportMasterList({required String uid}) {
    return _databaseService.fetchSalesReportMasterList(uid);
  }

  @override
  Future<DailySalesReport> fetchDailySalesReport({required String uid, required String dateInYYYYMMDD}) {
    return _databaseService.fetchDailySalesReport(uid, dateInYYYYMMDD);
  }
}
