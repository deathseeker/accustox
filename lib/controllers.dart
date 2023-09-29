import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';
import 'enumerated_values.dart';
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

  navigateToNewSupplier() {
    return _navigationRepository.navigateToNewSupplier();
  }

  navigateToEditSupplier({required Supplier supplier}) {
    return _navigationRepository.navigateToEditSupplier(supplier: supplier);
  }

  navigateToNewCustomerAccount() {
    return _navigationRepository.navigateToNewCustomerAccount();
  }

  navigateToNewItem() {
    return _navigationRepository.navigateToNewItem();
  }

  navigateToNewPurchaseOrder() {
    return _navigationRepository.navigateToNewPurchaseOrder();
  }

  navigateToEditItem({required Item item}) {
    return _navigationRepository.navigateToEditItem(item: item);
  }

  navigateToCurrentInventoryDetails(
      {required CurrentInventoryData currentInventoryData}) {
    return _navigationRepository.navigateToCurrentInventoryDetails(
        currentInventoryData: currentInventoryData);
  }

  navigateToAddInventory({required Inventory inventory}) {
    return _navigationRepository.navigateToAddInventory(inventory: inventory);
  }

  navigateToMoveInventory({required Stock stock}) {
    return _navigationRepository.navigateToMoveInventory(stock: stock);
  }

  navigateToAdjustInventory({required Stock stock}) {
    return _navigationRepository.navigateToAdjustInventory(stock: stock);
  }

  navigateToAddItemToPurchaseOrder() {
    return _navigationRepository.navigateToAddItemToPurchaseOrder();
  }

  navigateToPurchaseOrderDetails({required PurchaseOrder purchaseOrder}) {
    return _navigationRepository.navigateToPurchaseOrderDetails(
        purchaseOrder: purchaseOrder);
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

  addStockLocationDialog({required BuildContext context, required String uid}) {
    return _dialogRepository.addStockLocationDialog(context: context, uid: uid);
  }

  processAddParentLocation(
      {required String uid, required StockLocation stockLocation}) {
    return _dialogRepository.processAddParentLocation(
        uid: uid, stockLocation: stockLocation);
  }

  removeLocationDialog(
      {required BuildContext context,
      required String uid,
      required StockLocation stockLocation}) {
    return _dialogRepository.removeLocationDialog(
        context: context, uid: uid, stockLocation: stockLocation);
  }

  processRemoveLocation(
      {required String uid, required StockLocation stockLocation}) {
    return _dialogRepository.processRemoveLocation(
        uid: uid, stockLocation: stockLocation);
  }

  addStockSubLocationDialog(
      {required BuildContext context,
      required String uid,
      required StockLocation parentLocation}) {
    return _dialogRepository.addStockSubLocationDialog(
        context: context, uid: uid, parentLocation: parentLocation);
  }

  processAddSubLocation(
      {required String uid,
      required StockLocation parentLocation,
      required StockLocation subLocation}) {
    return _dialogRepository.processAddSubLocation(
        uid: uid, parentLocation: parentLocation, subLocation: subLocation);
  }

  removeSupplierDialog(
      {required BuildContext context,
      required String uid,
      required Supplier supplier}) {
    return _dialogRepository.removeSupplierDialog(
        context: context, uid: uid, supplier: supplier);
  }

  processRemoveSupplier({required String uid, required Supplier supplier}) {
    return _dialogRepository.processRemoveSupplier(
        uid: uid, supplier: supplier);
  }

  addPurchaseItemOrderDialog(
      {required BuildContext context,
      required Item item,
      required WidgetRef ref}) {
    return _dialogRepository.addPurchaseItemOrderDialog(
        context: context, item: item, ref: ref);
  }

  editPurchaseItemOrderDialog(
      {required BuildContext context,
      required PurchaseOrderItem purchaseOrderItem,
      required WidgetRef ref}) {
    return _dialogRepository.editPurchaseItemOrderDialog(
        context: context, purchaseOrderItem: purchaseOrderItem, ref: ref);
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

  Future<void> addItem(
      {required String uid,
      required Item item,
      required Stock stock,
      required Inventory inventory}) {
    return _itemRepository.addItem(
        uid: uid, item: item, stock: stock, inventory: inventory);
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
    return _itemRepository.reviewAndSubmitItem(
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

  reviewAndSubmitItemUpdate(
      {required GlobalKey<FormState> formKey,
      required WidgetRef ref,
      required ItemChangeNotifier itemChangeNotifier,
      required Item oldItem,
      required ImageFile imageFile,
      required uid,
      required ImageStorageUploadData imageStorageUploadData}) {
    return _itemRepository.reviewAndSubmitItemUpdate(
        formKey: formKey,
        ref: ref,
        itemChangeNotifier: itemChangeNotifier,
        oldItem: oldItem,
        imageFile: imageFile,
        uid: uid,
        imageStorageUploadData: imageStorageUploadData);
  }

  Stream<List<Item>> streamCurrentItemList({required String uid}) {
    return _itemRepository.streamCurrentItemList(uid: uid);
  }
}

final StockLocationController stockLocationController =
    StockLocationController();

class StockLocationController {
  final StockLocationRepository _stockLocationRepository =
      StockLocationRepository(DatabaseService(), Services());

  String getLocationID() {
    return _stockLocationRepository.getLocationID();
  }

  Future<void> addParentLocation(
      {required String uid, required StockLocation stockLocation}) {
    return _stockLocationRepository.addParentLocation(
        uid: uid, stockLocation: stockLocation);
  }

  Stream<List<StockLocation>> streamParentLocationDataList(
      {required String uid}) {
    return _stockLocationRepository.streamParentLocationDataList(uid: uid);
  }

  Future<void> removeParentLocation(
      {required String uid, required StockLocation stockLocation}) {
    return _stockLocationRepository.removeParentLocation(
        uid: uid, stockLocation: stockLocation);
  }

  Stream<List<StockLocation>> streamSubLocationDataList(
      {required String path}) {
    return _stockLocationRepository.streamSubLocationDataList(path: path);
  }

  Future<void> addSubLocation(
      {required String uid,
      required StockLocation parentLocation,
      required StockLocation subLocation}) {
    return _stockLocationRepository.addSubLocation(
        uid: uid, parentLocation: parentLocation, subLocation: subLocation);
  }

  Stream<List<StockLocation>> streamLocationDataList({required String uid}) {
    return _stockLocationRepository.streamLocationDataList(uid: uid);
  }
}

final SupplierController supplierController = SupplierController();

class SupplierController {
  final SupplierRepository _supplierRepository =
      SupplierRepository(DatabaseService(), Services());

  Stream<List<Supplier>> streamSupplierDataList({required String uid}) {
    return _supplierRepository.streamSupplierDataList(uid: uid);
  }

  String getSupplierID() {
    return _supplierRepository.getSupplierID();
  }

  reviewAndSubmitSupplierProfile(
      {required GlobalKey<FormState> formKey,
      required String supplierName,
      required String contactPerson,
      required String email,
      required String contactNumber,
      required String address,
      required String uid}) {
    return _supplierRepository.reviewAndSubmitSupplierProfile(
        formKey: formKey,
        supplierName: supplierName,
        contactPerson: contactPerson,
        email: email,
        contactNumber: contactNumber,
        address: address,
        uid: uid);
  }

  Future<void> addSupplier({required String uid, required Supplier supplier}) {
    return _supplierRepository.addSupplier(uid: uid, supplier: supplier);
  }

  Future<void> removeSupplier(
      {required String uid, required Supplier supplier}) {
    return _supplierRepository.removeSupplier(uid: uid, supplier: supplier);
  }

  Future<void> editSupplier(
      {required String uid,
      required Supplier oldSupplier,
      required Supplier newSupplier}) {
    return _supplierRepository.editSupplier(
        uid: uid, oldSupplier: oldSupplier, newSupplier: newSupplier);
  }

  bool hasSupplierChanged(
      {required Supplier originalSupplier,
      required SupplierChangeNotifier notifier}) {
    return _supplierRepository.hasSupplierChanged(
        originalSupplier: originalSupplier, notifier: notifier);
  }

  reviewAndSubmitSupplierUpdate(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Supplier originalSupplier,
      required SupplierChangeNotifier notifier}) {
    return _supplierRepository.reviewAndSubmitSupplierUpdate(
        formKey: formKey,
        uid: uid,
        originalSupplier: originalSupplier,
        notifier: notifier);
  }
}

final CustomerController customerController = CustomerController();

class CustomerController {
  final CustomerRepository _customerRepository =
      CustomerRepository(DatabaseService(), Services());

  Stream<List<Customer>> streamCustomerDataList({required String uid}) {
    return _customerRepository.streamCustomerDataList(uid: uid);
  }

  String getCustomerID() {
    return _customerRepository.getCustomerID();
  }

  Future<void> addCustomer({required String uid, required Customer customer}) {
    return _customerRepository.addCustomer(uid: uid, customer: customer);
  }

  reviewAndSubmitCustomerProfile(
      {required GlobalKey<FormState> formKey,
      required String customerName,
      required String contactPerson,
      required String email,
      required String contactNumber,
      required String address,
      required String customerType,
      required String uid}) {
    return _customerRepository.reviewAndSubmitCustomerProfile(
        formKey: formKey,
        customerName: customerName,
        contactPerson: contactPerson,
        email: email,
        contactNumber: contactNumber,
        address: address,
        customerType: customerType,
        uid: uid);
  }
}

final ScannerController scannerController = ScannerController();

class ScannerController {
  final ScannerRepository _scannerRepository = ScannerRepository(Services());

  Future<String> scanBarCode() {
    return _scannerRepository.scanBarcode();
  }

  Future<String> scanQRCode() {
    return _scannerRepository.scanQRCode();
  }
}

final ImageDataController imageDataController = imageDataController;

class ImageDataController {
  final ImageRepository _imageRepository = ImageRepository(DatabaseService());

  Future<File> getImage(
      {required bool isSourceCamera, required bool isCropStyleCircle}) {
    return _imageRepository.getImage(
        isSourceCamera: isSourceCamera, isCropStyleCircle: isCropStyleCircle);
  }

  Future<void> uploadImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData,
      required VoidCallback retryOnError}) {
    return _imageRepository.uploadImage(
        image: image,
        uid: uid,
        path: path,
        imageStorageUploadData: imageStorageUploadData,
        retryOnError: retryOnError);
  }

  Future<UploadTask> uploadCategoryImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData}) {
    return _imageRepository.uploadCategoryImage(
      image: image,
      uid: uid,
      path: path,
      imageStorageUploadData: imageStorageUploadData,
    );
  }

  Future<UploadTask> uploadItemImage(
      {required File image,
      required String uid,
      required String path,
      required ImageStorageUploadData imageStorageUploadData}) {
    return _imageRepository.uploadItemImage(
        image: image,
        uid: uid,
        path: path,
        imageStorageUploadData: imageStorageUploadData);
  }
}

final InventoryController inventoryController = InventoryController();

class InventoryController {
  final InventoryRepository _inventoryRepository =
      InventoryRepository(DatabaseService(), Services());

  Stream<InventorySummary> streamInventorySummary(
      {required String uid, required String itemID}) {
    return _inventoryRepository.streamInventorySummary(
        uid: uid, itemID: itemID);
  }

  getStockLevelState(
      {required num stockLevel,
      required num safetyStockLevel,
      required num reorderPoint}) {
    return _inventoryRepository.getStockLevelState(
        stockLevel: stockLevel,
        safetyStockLevel: safetyStockLevel,
        reorderPoint: reorderPoint);
  }

  Stream<List<Inventory>> streamInventoryList({required String uid}) {
    return _inventoryRepository.streamInventoryList(uid: uid);
  }

  Stream<List<Stock>> streamStockList(
      {required String uid, required String itemID}) {
    return _inventoryRepository.streamStockList(uid: uid, itemID: itemID);
  }

  Future<void> addInventoryStock(
      {required String uid,
      required String itemID,
      required Stock stock,
      required Inventory inventory,
      required double newLeadTime}) {
    return _inventoryRepository.addInventoryStock(
        uid: uid,
        itemID: itemID,
        stock: stock,
        inventory: inventory,
        newLeadTime: newLeadTime);
  }

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
    return _inventoryRepository.reviewAndSubmitStock(
        formKey: formKey,
        uid: uid,
        item: item,
        openingStock: openingStock,
        costPrice: costPrice,
        salePrice: salePrice,
        expirationWarning: expirationWarning,
        supplier: supplier,
        stockLocation: stockLocation,
        expirationDate: expirationDate,
        batchNumber: batchNumber,
        purchaseDate: purchaseDate,
        inventory: inventory,
        newLeadTime: newLeadTime);
  }

  Future<void> updateInventoryStatisticsOnStockAdd(
      {required String uid,
      required String itemID,
      required Inventory inventory,
      required double newLeadTime,
      required double stockLevel,
      required double costPrice}) {
    return _inventoryRepository.updateInventoryStatisticsOnStockAdd(
        uid: uid,
        itemID: itemID,
        inventory: inventory,
        newLeadTime: newLeadTime,
        stockLevel: stockLevel,
        costPrice: costPrice);
  }

  Stream<Inventory> streamInventory(String uid, String itemID) {
    return _inventoryRepository.streamInventory(uid: uid, itemID: itemID);
  }

  double getAdjustedStockLevelForMovement(
      {required double currentStockLevel, required double adjustment}) {
    return _inventoryRepository.getAdjustedStockLevelForMovement(
        currentStockLevel: currentStockLevel, adjustment: adjustment);
  }

  Future<void> moveInventoryStock(
      {required String uid,
      required Stock currentStock,
      required Stock movedStock}) {
    return _inventoryRepository.moveInventoryStock(
        uid: uid, currentStock: currentStock, movedStock: movedStock);
  }

  reviewAndMoveInventory(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required StockLocation? newStockLocation,
      required String movedStockLevel,
      required Stock currentStock}) {
    return _inventoryRepository.reviewAndMoveInventory(
        formKey: formKey,
        uid: uid,
        newStockLocation: newStockLocation,
        movedStockLevel: movedStockLevel,
        currentStock: currentStock);
  }

  Stream<List<InventoryTransaction>> streamInventoryTransactionList(
      {required String uid, required Inventory inventory}) {
    return _inventoryRepository.streamInventoryTransactionList(
        uid: uid, inventory: inventory);
  }

  Future<void> inventoryStockLevelAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedStockLevel,
      required String reason}) {
    return _inventoryRepository.inventoryStockLevelAdjustment(
        uid: uid,
        stock: stock,
        adjustedStockLevel: adjustedStockLevel,
        reason: reason);
  }

  Future<void> costPriceAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedCostPrice,
      required String reason}) {
    return _inventoryRepository.costPriceAdjustment(
        uid: uid,
        stock: stock,
        adjustedCostPrice: adjustedCostPrice,
        reason: reason);
  }

  Future<void> salePriceAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedSalePrice,
      required String reason}) {
    return _inventoryRepository.salePriceAdjustment(
        uid: uid,
        stock: stock,
        adjustedSalePrice: adjustedSalePrice,
        reason: reason);
  }

  reviewAndAdjustStockLevel(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedStockLevel,
      required String reason}) {
    return _inventoryRepository.reviewAndAdjustStockLevel(
        formKey: formKey,
        uid: uid,
        stock: stock,
        adjustedStockLevel: adjustedStockLevel,
        reason: reason);
  }

  reviewAndAdjustCostPrice(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedCostPrice,
      required String reason}) {
    return _inventoryRepository.reviewAndAdjustCostPrice(
        formKey: formKey,
        uid: uid,
        stock: stock,
        adjustedCostPrice: adjustedCostPrice,
        reason: reason);
  }

  reviewAndAdjustSalePrice(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedSalePrice,
      required String reason}) {
    return _inventoryRepository.reviewAndAdjustSalePrice(
        formKey: formKey,
        uid: uid,
        stock: stock,
        adjustedSalePrice: adjustedSalePrice,
        reason: reason);
  }
}

final DateTimeController dateTimeController = DateTimeController();

class DateTimeController {
  final DateTimeRepository _dateTimeRepository = DateTimeRepository(Services());

  DateTime timestampToDateTime({required Timestamp timestamp}) {
    return _dateTimeRepository.timestampToDateTime(timestamp: timestamp);
  }

  Timestamp dateTimeToTimestamp({required DateTime dateTime}) {
    return _dateTimeRepository.dateTimeToTimestamp(dateTime: dateTime);
  }

  Future<DateTime?> selectDate(
      {required BuildContext context,
      required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate}) {
    return _dateTimeRepository.selectDate(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);
  }

  String formatDateTimeToYMd({required DateTime dateTime}) {
    return _dateTimeRepository.formatDateTimeToYMd(dateTime: dateTime);
  }

  ExpirationState getExpirationState(
      DateTime expirationDate, double expirationWarning) {
    return _dateTimeRepository.getExpirationState(
        expirationDate: expirationDate, expirationWarning: expirationWarning);
  }

  int getDaysToExpiration({required DateTime expirationDate}) {
    return _dateTimeRepository.getDaysToExpiration(
        expirationDate: expirationDate);
  }

  String formatDateTimeToYMdjm({required DateTime dateTime}) {
    return _dateTimeRepository.formatDateTimeToYMdjm(dateTime: dateTime);
  }
}

final PerishabilityController perishabilityController =
    PerishabilityController();

class PerishabilityController {
  final PerishabilityRepository _perishabilityRepository =
      PerishabilityRepository(Services());

  bool enableExpirationDateInput({required Perishability perishability}) {
    return _perishabilityRepository.enableExpirationDateInput(
        perishability: perishability);
  }

  Perishability getPerishabilityState({required String perishabilityString}) {
    return _perishabilityRepository.getPerishabilityState(
        perishabilityString: perishabilityString);
  }
}

final PluralizationController pluralizationController =
    PluralizationController();

class PluralizationController {
  final PluralizationRepository _pluralizationRepository =
      PluralizationRepository(Services());

  String pluralize({required String noun, required num count}) {
    return _pluralizationRepository.pluralize(noun: noun, count: count);
  }
}

final CurrencyController currencyController = CurrencyController();

class CurrencyController {
  final CurrencyRepository _currencyRepository = CurrencyRepository(Services());

  String formatAsPhilippineCurrency({required num amount}) {
    return _currencyRepository.formatAsPhilippineCurrency(amount: amount);
  }

  String formatAsPhilippineCurrencyWithoutSymbol({required num amount}) {
    return _currencyRepository.formatAsPhilippineCurrencyWithoutSymbol(
        amount: amount);
  }
}

final StatisticsController statisticsController = StatisticsController();

class StatisticsController {
  final StatisticsRepository _statisticsRepository =
      StatisticsRepository(Services());

  double getInventoryValue(
      {required double stockLevel, required double costPrice}) {
    return _statisticsRepository.getInventoryValue(
        stockLevel: stockLevel, costPrice: costPrice);
  }

  double getMaximumLeadTime(
      {required double oldMaximumLeadTime, required double newLeadTime}) {
    return _statisticsRepository.getMaximumLeadTime(
        oldMaximumLeadTime: oldMaximumLeadTime, newLeadTime: newLeadTime);
  }

  double getAverageLeadTime(
      {required double oldAverageLeadTime, required newLeadTime}) {
    return _statisticsRepository.getAverageLeadTime(
        oldAverageLeadTime: oldAverageLeadTime, newLeadTime: newLeadTime);
  }

  double getSafetyStockLevel(
      {required double maximumLeadTime,
      required double maximumDailyDemand,
      required double averageDailyDemand,
      required double averageLeadTime}) {
    return _statisticsRepository.getSafetyStockLevel(
        maximumLeadTime: maximumLeadTime,
        maximumDailyDemand: maximumDailyDemand,
        averageDailyDemand: averageDailyDemand,
        averageLeadTime: averageLeadTime);
  }

  double getReorderPoint(
      {required double averageLeadTime,
      required double averageDailyDemand,
      required double safetyStockLevel}) {
    return _statisticsRepository.getReorderPoint(
        averageLeadTime: averageLeadTime,
        averageDailyDemand: averageDailyDemand,
        safetyStockLevel: safetyStockLevel);
  }

  Map<String, dynamic> getInventoryStatisticsOnStockAdd(
      {required Inventory inventory,
      required double newLeadTime,
      required double stockLevel,
      required double costPrice}) {
    return _statisticsRepository.getInventoryStatisticsOnStockAdd(
        inventory: inventory,
        newLeadTime: newLeadTime,
        stockLevel: stockLevel,
        costPrice: costPrice);
  }
}

final ValidatorController validatorController = ValidatorController();

class ValidatorController {
  final ValidatorRepository _validatorRepository =
      ValidatorRepository(Services());

  bool isPositiveDoubleBelowOrEqualToCount(
      {required String input, required double maxCount}) {
    return _validatorRepository.isPositiveDoubleBelowOrEqualToCount(
        input: input, maxCount: maxCount);
  }
}

final PurchaseOrderController purchaseOrderController =
    PurchaseOrderController();

class PurchaseOrderController {
  final PurchaseOrderRepository _purchaseOrderRepository =
      PurchaseOrderRepository(Services(), DatabaseService());

  String createPurchaseOrderNumber({required int a}) {
    return _purchaseOrderRepository.createPurchaseOrderNumber(a: a);
  }

  Future<void> addPurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder}) {
    return _purchaseOrderRepository.addPurchaseOrder(
        uid: uid, purchaseOrder: purchaseOrder);
  }

  reviewAndSubmitPurchaseOrder(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Supplier? supplier,
      required String? deliveryAddress,
      required DateTime? expectedDeliveryDate,
      required List<PurchaseOrderItem>? purchaseOrderItemList}) {
    return _purchaseOrderRepository.reviewAndSubmitPurchaseOrder(
        formKey: formKey,
        uid: uid,
        supplier: supplier,
        deliveryAddress: deliveryAddress,
        expectedDeliveryDate: expectedDeliveryDate,
        purchaseOrderItemList: purchaseOrderItemList);
  }

  Stream<List<PurchaseOrder>> streamIncomingInventoryList(
      {required String uid}) {
    return _purchaseOrderRepository.streamIncomingInventoryList(uid: uid);
  }

  getIncomingInventoryState(
      {required bool orderPlaced, required bool orderConfirmed}) {
    return _purchaseOrderRepository.getIncomingInventoryState(
        orderPlaced: orderPlaced, orderConfirmed: orderConfirmed);
  }

  Stream<PurchaseOrder> streamPurchaseOrder(
      {required String uid, required String purchaseOrderID}){
    return _purchaseOrderRepository.streamPurchaseOrder(uid: uid, purchaseOrderID: purchaseOrderID);
  }
}
