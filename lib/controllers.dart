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

  navigateToEditPurchaseOrder({required PurchaseOrder purchaseOrder}) {
    return _navigationRepository.navigateToEditPurchaseOrder(
        purchaseOrder: purchaseOrder);
  }

  navigateToIncomingInventoryManagement(
      {required PurchaseOrder purchaseOrder}) {
    return _navigationRepository.navigateToIncomingInventoryManagement(
        purchaseOrder: purchaseOrder);
  }

  navigateToNewInventoryStockFromPurchaseOrder(
      {required PurchaseOrderItem purchaseOrderItem,
      required PurchaseOrder purchaseOrder}) {
    return _navigationRepository.navigateToNewInventoryStockFromPurchaseOrder(
        purchaseOrderItem: purchaseOrderItem, purchaseOrder: purchaseOrder);
  }

  navigateToProcessSalesOrder() {
    return _navigationRepository.navigateToProcessSalesOrder();
  }

  navigateToCustomerAccountDetails({required Customer customer}) {
    return _navigationRepository.navigateToCustomerAccountDetails(
        customer: customer);
  }

  navigateToSalesOrderDetails({required String salesOrderID}) {
    return _navigationRepository.navigateToSalesOrderDetails(
        salesOrderID: salesOrderID);
  }

  navigateToSalesReportDetails({required String dateInYYYYMMDD}) {
    return _navigationRepository.navigateToSalesReportDetails(dateInYYYYMMDD: dateInYYYYMMDD);
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

  placeOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced}) {
    return _dialogRepository.placeOrderDialog(
        context: context,
        uid: uid,
        purchaseOrder: purchaseOrder,
        orderPlaced: orderPlaced);
  }

  cancelOrderPlacementDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced}) {
    return _dialogRepository.cancelOrderPlacementDialog(
        context: context,
        uid: uid,
        purchaseOrder: purchaseOrder,
        orderPlaced: orderPlaced);
  }

  orderConfirmationDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed}) {
    return _dialogRepository.orderConfirmationDialog(
        context: context,
        uid: uid,
        purchaseOrder: purchaseOrder,
        orderConfirmed: orderConfirmed);
  }

  cancelOrderConfirmationDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed}) {
    return _dialogRepository.cancelOrderConfirmationDialog(
        context: context,
        uid: uid,
        purchaseOrder: purchaseOrder,
        orderConfirmed: orderConfirmed);
  }

  cancelPurchaseOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder}) {
    return _dialogRepository.cancelPurchaseOrderDialog(
        context: context, uid: uid, purchaseOrder: purchaseOrder);
  }

  receivePurchaseOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder}) {
    return _dialogRepository.receivePurchaseOrderDialog(
        context: context, uid: uid, purchaseOrder: purchaseOrder);
  }

  processSetAsRetailStock(
      {required String uid, required String itemID, required Stock stock}) {
    return _dialogRepository.processSetAsRetailStock(
        uid: uid, itemID: itemID, stock: stock);
  }

  setAsRetailStockDialog(
      {required BuildContext context,
      required String uid,
      required String itemID,
      required Stock stock}) {
    return _dialogRepository.setAsRetailStockDialog(
        context: context, uid: uid, itemID: itemID, stock: stock);
  }

  processRemoveFromRetailStock(
      {required String uid, required String itemID, required Stock stock}) {
    return _dialogRepository.processRemoveFromRetailStock(
        uid: uid, itemID: itemID, stock: stock);
  }

  removeFromRetailStockDialog(
      {required BuildContext context,
      required String uid,
      required String itemID,
      required Stock stock}) {
    return _dialogRepository.removeFromRetailStockDialog(
        context: context, uid: uid, itemID: itemID, stock: stock);
  }

  addCustomItemOrderDialog(
      {required BuildContext context,
      required WidgetRef ref,
      required RetailItem retailItem}) {
    return _dialogRepository.addCustomItemOrderDialog(
        context: context, ref: ref, retailItem: retailItem);
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

  Stream<CustomerAccount> streamCustomerAccount(
      {required String uid, required String customerID}) {
    return _customerRepository.streamCustomerAccount(
        uid: uid, customerID: customerID);
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

  Future<void> streamBarcodes({required WidgetRef ref}) {
    return _scannerRepository.streamBarcodes(ref: ref);
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

  Stream<List<Stock>> streamRetailStockList(
      {required String uid, required String itemID}) {
    return _inventoryRepository.streamRetailStockList(uid: uid, itemID: itemID);
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

  Future<void> addStockToRetailStock(
      {required String uid, required String itemID, required Stock stock}) {
    return _inventoryRepository.addStockToRetailStock(
        uid: uid, itemID: itemID, stock: stock);
  }

  Future<void> removeStockFromRetailStock(
      {required String uid, required String itemID, required Stock stock}) {
    return _inventoryRepository.removeStockFromRetailStock(
        uid: uid, itemID: itemID, stock: stock);
  }

  Future<void> adjustRetailStockFromSalesOrder(
      {required String uid,
      required String itemID,
      required Stock adjustedStock,
      required String reason}) {
    return _inventoryRepository.adjustRetailStockFromSalesOrder(
        uid: uid, itemID: itemID, adjustedStock: adjustedStock, reason: reason);
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

  double leadTimeFromPO(
      {required DateTime orderPlacedOn, required DateTime orderDeliveredOn}) {
    return _dateTimeRepository.leadTimeFromPO(
        orderPlacedOn: orderPlacedOn, orderDeliveredOn: orderDeliveredOn);
  }

  String formatDateTimeToYYYYMMDD({required DateTime date}) {
    return _dateTimeRepository.formatDateTimeToYYYYMMDD(date: date);
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

  String getAveragePrice({required double quantity, required double total}) {
    return _currencyRepository.getAveragePrice(
        quantity: quantity, total: total);
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
      {required bool orderPlaced,
      required bool orderConfirmed,
      required bool orderDelivered}) {
    return _purchaseOrderRepository.getIncomingInventoryState(
        orderPlaced: orderPlaced,
        orderConfirmed: orderConfirmed,
        orderDelivered: orderDelivered);
  }

  Stream<PurchaseOrder> streamPurchaseOrder(
      {required String uid, required String purchaseOrderID}) {
    return _purchaseOrderRepository.streamPurchaseOrder(
        uid: uid, purchaseOrderID: purchaseOrderID);
  }

  Future<void> updateOrderPlacedStatus(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced}) {
    return _purchaseOrderRepository.updateOrderPlacedStatus(
        uid: uid, purchaseOrder: purchaseOrder, orderPlaced: orderPlaced);
  }

  Future<void> updateOrderConfirmedStatus(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed}) {
    return _purchaseOrderRepository.updateOrderConfirmedStatus(
        uid: uid, purchaseOrder: purchaseOrder, orderConfirmed: orderConfirmed);
  }

  Future<void> cancelPurchaseOrder(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required String reason}) {
    return _purchaseOrderRepository.cancelPurchaseOrder(
        uid: uid, purchaseOrder: purchaseOrder, reason: reason);
  }

  checkIfPurchaseOrderChanged(
      {required PurchaseOrder originalPurchaseOrder,
      required PurchaseOrder newPurchaseOrder}) {
    return _purchaseOrderRepository.checkIfPurchaseOrderChanged(
        originalPurchaseOrder: originalPurchaseOrder,
        newPurchaseOrder: newPurchaseOrder);
  }

  Future<void> updatePurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder}) {
    return _purchaseOrderRepository.updatePurchaseOrder(
        uid: uid, purchaseOrder: purchaseOrder);
  }

  processEditPurchaseOrder(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required PurchaseOrder originalPurchaseOrder,
      required PurchaseOrder newPurchaseOrder}) {
    return _purchaseOrderRepository.processEditPurchaseOrder(
        formKey: formKey,
        uid: uid,
        originalPurchaseOrder: originalPurchaseOrder,
        newPurchaseOrder: newPurchaseOrder);
  }

  Future<void> receivePurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder}) {
    return _purchaseOrderRepository.receivePurchaseOrder(
        uid: uid, purchaseOrder: purchaseOrder);
  }

  Future<void> addInventoryStockFromPO(
      {required String uid,
      required String itemID,
      required Stock stock,
      required Inventory inventory,
      required double newLeadTime,
      required PurchaseOrder purchaseOrder}) {
    return _purchaseOrderRepository.addInventoryStockFromPO(
        uid: uid,
        itemID: itemID,
        stock: stock,
        inventory: inventory,
        newLeadTime: newLeadTime,
        purchaseOrder: purchaseOrder);
  }

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
    return _purchaseOrderRepository.reviewAndSubmitStockFromPO(
        formKey: formKey,
        uid: uid,
        item: item,
        stockLevel: stockLevel,
        costPrice: costPrice,
        salePrice: salePrice,
        expirationWarning: expirationWarning,
        supplier: supplier,
        stockLocation: stockLocation,
        expirationDate: expirationDate,
        batchNumber: batchNumber,
        purchaseDate: purchaseDate,
        inventory: inventory,
        purchaseOrder: purchaseOrder);
  }

  Future<void> completeInventoryAndPurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder}) {
    return _purchaseOrderRepository.completeInventoryAndPurchaseOrder(
        uid: uid, purchaseOrder: purchaseOrder);
  }
}

final SalesOrderController salesOrderController = SalesOrderController();

class SalesOrderController {
  final SalesOrderRepository _salesOrderRepository =
      SalesOrderRepository(Services(), DatabaseService());

  Stream<List<RetailItem>> streamRetailItemDataList({required String uid}) {
    return _salesOrderRepository.streamRetailItemDataList(uid: uid);
  }

  SalesOrderItem getSalesOrderItem(
      {required RetailItem retailItem, required double quantity}) {
    return _salesOrderRepository.getSalesOrderItem(
        retailItem: retailItem, quantity: quantity);
  }

  List<Stock> getAdjustedStocksFromSO(
      {required RetailItem retailItem, required double quantity}) {
    return _salesOrderRepository.getAdjustedStocksFromSO(
        retailItem: retailItem, quantity: quantity);
  }

  addSalesOrderItem(
      {required WidgetRef ref,
      required RetailItem retailItem,
      required double stockLimit,
      required double count}) {
    return _salesOrderRepository.addSalesOrderItem(
        ref: ref, retailItem: retailItem, stockLimit: stockLimit, count: count);
  }

  addCustomSalesOrderItem(
      {required WidgetRef ref,
      required RetailItem retailItem,
      required double stockLimit,
      required double quantity}) {
    return _salesOrderRepository.addCustomSalesOrderItem(
        ref: ref,
        retailItem: retailItem,
        stockLimit: stockLimit,
        quantity: quantity);
  }

  String createSalesOrderNumber({required int a}) {
    return _salesOrderRepository.createSalesOrderNumber(a: a);
  }

  Future<void> addSalesOrder(
      {required String uid,
      required SalesOrder salesOrder,
      required List<Stock> adjustedStockList}) {
    return _salesOrderRepository.addSalesOrder(
        uid: uid, salesOrder: salesOrder, adjustedStockList: adjustedStockList);
  }

  Future<void> incrementSaleToDailyDemand(
      {required String uid, required String itemID, required double sales}) {
    return _salesOrderRepository.incrementSaleToDailyDemand(
        uid: uid, itemID: itemID, sales: sales);
  }

  submitRetailSalesOrder(
      {required String uid,
      required List<SalesOrderItem> salesOrderItemList,
      required String? paymentTerms,
      required String? orderTotal,
      required List<Stock> stockList}) {
    return _salesOrderRepository.submitRetailSalesOrder(
        uid: uid,
        salesOrderItemList: salesOrderItemList,
        paymentTerms: paymentTerms,
        orderTotal: orderTotal,
        stockList: stockList);
  }

  Future<void> updateInventoryStatisticsOnSale(
      {required String uid, required String itemID}) {
    return _salesOrderRepository.updateInventoryStatisticsOnSale(
        uid: uid, itemID: itemID);
  }

  Future<void> addAccountSalesOrder(
      {required String uid,
      required SalesOrder salesOrder,
      required List<Stock> adjustedStockList}) {
    return _salesOrderRepository.addAccountSalesOrder(
        uid: uid, salesOrder: salesOrder, adjustedStockList: adjustedStockList);
  }

  reviewAndSubmitAccountSalesOrder(
      {required String uid,
      required List<SalesOrderItem> salesOrderItemList,
      required Customer? customer,
      required String? paymentTerms,
      required String? orderTotal,
      required List<Stock> stockList}) {
    return _salesOrderRepository.reviewAndSubmitAccountSalesOrder(
        uid: uid,
        salesOrderItemList: salesOrderItemList,
        customer: customer,
        paymentTerms: paymentTerms,
        orderTotal: orderTotal,
        stockList: stockList);
  }

  Future<SalesOrder> fetchSalesOrder(
      {required String uid, required String salesOrderID}) {
    return _salesOrderRepository.fetchSalesOrder(
        uid: uid, salesOrderID: salesOrderID);
  }

  Stream<List<SalesOrder>> streamSalesOrders({required String uid}) {
    return _salesOrderRepository.streamSalesOrders(uid: uid);
  }

  Stream<List<SalesOrder>> streamCurrentSalesOrders({required String uid}) {
    return _salesOrderRepository.streamCurrentSalesOrders(uid: uid);
  }
}

final StringController stringController = StringController();

class StringController {
  final StringRepository _stringRepository = StringRepository(Services());

  String removeTrailingZeros({required double value}) {
    return _stringRepository.removeTrailingZeros(value: value);
  }
}

final ReportsController reportsController = ReportsController();

class ReportsController {
  final ReportsRepository _reportsRepository =
      ReportsRepository(DatabaseService());

  Future<void> updateDailySalesReport(
      {required String uid, required SalesOrder salesOrder}) {
    return _reportsRepository.updateDailySalesReport(
        uid: uid, salesOrder: salesOrder);
  }

  Future<SalesReports> fetchSalesReportMasterList({required String uid}) {
    return _reportsRepository.fetchSalesReportMasterList(uid: uid);
  }

  Future<DailySalesReport> fetchDailySalesReport(
      {required String uid, required String dateInYYYYMMDD}) {
    return _reportsRepository.fetchDailySalesReport(uid: uid, dateInYYYYMMDD: dateInYYYYMMDD);
  }
}
