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

  navigateToNewPurchaseOrder();

  navigateToEditItem({required Item item});

  navigateToCurrentInventoryDetails(
      {required CurrentInventoryData currentInventoryData});

  navigateToAddInventory({required Inventory inventory});

  navigateToMoveInventory({required Stock stock});

  navigateToAdjustInventory({required Stock stock});

  navigateToAddItemToPurchaseOrder();

  navigateToPurchaseOrderDetails({required PurchaseOrder purchaseOrder});

  navigateToEditPurchaseOrder({required PurchaseOrder purchaseOrder});

  navigateToIncomingInventoryManagement({required PurchaseOrder purchaseOrder});

  navigateToNewInventoryStockFromPurchaseOrder(
      {required PurchaseOrderItem purchaseOrderItem,
      required PurchaseOrder purchaseOrder});

  navigateToProcessSalesOrder();

  navigateToCustomerAccountDetails({required Customer customer});

  navigateToSalesOrderDetails({required String salesOrderID});

  navigateToSalesReportDetails({required String dateInYYYYMMDD});
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

  addPurchaseItemOrderDialog(
      {required BuildContext context,
      required Item item,
      required WidgetRef ref});

  editPurchaseItemOrderDialog(
      {required BuildContext context,
      required PurchaseOrderItem purchaseOrderItem,
      required WidgetRef ref});

  placeOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced});

  cancelOrderPlacementDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced});

  orderConfirmationDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed});

  cancelOrderConfirmationDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed});

  cancelPurchaseOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder});

  receivePurchaseOrderDialog(
      {required BuildContext context,
      required String uid,
      required PurchaseOrder purchaseOrder});

  processSetAsRetailStock(
      {required String uid, required String itemID, required Stock stock});

  setAsRetailStockDialog(
      {required BuildContext context,
      required String uid,
      required String itemID,
      required Stock stock});

  removeFromRetailStockDialog(
      {required BuildContext context,
      required String uid,
      required String itemID,
      required Stock stock});

  processRemoveFromRetailStock(
      {required String uid, required String itemID, required Stock stock});

  addCustomItemOrderDialog(
      {required BuildContext context,
      required WidgetRef ref,
      required RetailItem retailItem});
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

  reviewAndSubmitItem({
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

  Stream<CustomerAccount> streamCustomerAccount(
      {required String uid, required String customerID});
}

abstract class ScannerInterface {
  Future<String> scanBarcode();

  Future<String> scanQRCode();

  Future<void> streamBarcodes({required WidgetRef ref});
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

  Stream<List<Inventory>> streamInventoryList({required String uid});

  Stream<List<Stock>> streamStockList(
      {required String uid, required String itemID});

  Stream<List<Stock>> streamRetailStockList(
      {required String uid, required String itemID});

  Future<void> addInventoryStock(
      {required String uid,
      required String itemID,
      required Stock stock,
      required Inventory inventory,
      required double newLeadTime});

  reviewAndSubmitStock({
    required GlobalKey<FormState> formKey,
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
    required String newLeadTime,
  });

  Future<void> updateInventoryStatisticsOnStockAdd(
      {required String uid,
      required String itemID,
      required Inventory inventory,
      required double newLeadTime,
      required double stockLevel,
      required double costPrice});

  Stream<Inventory> streamInventory(
      {required String uid, required String itemID});

  double getAdjustedStockLevelForMovement(
      {required double currentStockLevel, required double adjustment});

  Future<void> moveInventoryStock(
      {required String uid,
      required Stock currentStock,
      required Stock movedStock});

  reviewAndMoveInventory(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required StockLocation? newStockLocation,
      required String movedStockLevel,
      required Stock currentStock});

  Stream<List<InventoryTransaction>> streamInventoryTransactionList(
      {required String uid, required Inventory inventory});

  Future<void> inventoryStockLevelAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedStockLevel,
      required String reason});

  Future<void> costPriceAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedCostPrice,
      required String reason});

  Future<void> salePriceAdjustment(
      {required String uid,
      required Stock stock,
      required double adjustedSalePrice,
      required String reason});

  reviewAndAdjustStockLevel(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedStockLevel,
      required String reason});

  reviewAndAdjustCostPrice(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedCostPrice,
      required String reason});

  reviewAndAdjustSalePrice(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Stock stock,
      required String adjustedSalePrice,
      required String reason});

  Future<void> addStockToRetailStock(
      {required String uid, required String itemID, required Stock stock});

  Future<void> removeStockFromRetailStock(
      {required String uid, required String itemID, required Stock stock});

  Future<void> adjustRetailStockFromSalesOrder(
      {required String uid,
      required String itemID,
      required Stock adjustedStock,
      required String reason});
}

abstract class DateTimeInterface {
  DateTime timestampToDateTime({required Timestamp timestamp});

  Timestamp dateTimeToTimestamp({required DateTime dateTime});

  Future<DateTime?> selectDate(
      {required BuildContext context,
      required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate});

  String formatDateTimeToYMd({required DateTime dateTime});

  ExpirationState getExpirationState(
      {required DateTime expirationDate, required double expirationWarning});

  int getDaysToExpiration({required DateTime expirationDate});

  String formatDateTimeToYMdjm({required DateTime dateTime});

  double leadTimeFromPO(
      {required DateTime orderPlacedOn, required DateTime orderDeliveredOn});

  String formatDateTimeToYYYYMMDD({required DateTime date});
}

abstract class PerishabilityInterface {
  bool enableExpirationDateInput({required Perishability perishability});

  Perishability getPerishabilityState({required String perishabilityString});
}

abstract class PluralizationInterface {
  String pluralize({required String noun, required num count});
}

abstract class CurrencyInterface {
  String formatAsPhilippineCurrency({required num amount});

  String formatAsPhilippineCurrencyWithoutSymbol({required num amount});

  String getAveragePrice({required double quantity, required double total});
}

abstract class StatisticsInterface {
  double getInventoryValue(
      {required double stockLevel, required double costPrice});

  double getMaximumLeadTime(
      {required double oldMaximumLeadTime, required double newLeadTime});

  double getAverageLeadTime(
      {required double oldAverageLeadTime, required newLeadTime});

  double getSafetyStockLevel(
      {required double maximumLeadTime,
      required double maximumDailyDemand,
      required double averageDailyDemand,
      required double averageLeadTime});

  double getReorderPoint(
      {required double averageLeadTime,
      required double averageDailyDemand,
      required double safetyStockLevel});

  Map<String, dynamic> getInventoryStatisticsOnStockAdd(
      {required Inventory inventory,
      required double newLeadTime,
      required double stockLevel,
      required double costPrice});
}

abstract class ValidatorInterface {
  bool isPositiveDoubleBelowOrEqualToCount(
      {required String input, required double maxCount});
}

abstract class PurchaseOrderInterface {
  String createPurchaseOrderNumber({required int a});

  Future<void> addPurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder});

  reviewAndSubmitPurchaseOrder(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Supplier? supplier,
      required String? deliveryAddress,
      required DateTime? expectedDeliveryDate,
      required List<PurchaseOrderItem>? purchaseOrderItemList});

  Stream<List<PurchaseOrder>> streamIncomingInventoryList(
      {required String uid});

  getIncomingInventoryState(
      {required bool orderPlaced,
      required bool orderConfirmed,
      required bool orderDelivered});

  Stream<PurchaseOrder> streamPurchaseOrder(
      {required String uid, required String purchaseOrderID});

  Future<void> updateOrderPlacedStatus(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderPlaced});

  Future<void> updateOrderConfirmedStatus(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required bool orderConfirmed});

  Future<void> cancelPurchaseOrder(
      {required String uid,
      required PurchaseOrder purchaseOrder,
      required String reason});

  checkIfPurchaseOrderChanged(
      {required PurchaseOrder originalPurchaseOrder,
      required PurchaseOrder newPurchaseOrder});

  Future<void> updatePurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder});

  processEditPurchaseOrder(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required PurchaseOrder originalPurchaseOrder,
      required PurchaseOrder newPurchaseOrder});

  Future<void> receivePurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder});

  Future<void> addInventoryStockFromPO(
      {required String uid,
      required String itemID,
      required Stock stock,
      required Inventory inventory,
      required double newLeadTime,
      required PurchaseOrder purchaseOrder});

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
      required PurchaseOrder purchaseOrder});

  Future<void> completeInventoryAndPurchaseOrder(
      {required String uid, required PurchaseOrder purchaseOrder});
}

abstract class SalesOrderInterface {
  Stream<List<RetailItem>> streamRetailItemDataList({required String uid});

  SalesOrderItem getSalesOrderItem(
      {required RetailItem retailItem, required double quantity});

  List<Stock> getAdjustedStocksFromSO(
      {required RetailItem retailItem, required double quantity});

  addSalesOrderItem(
      {required WidgetRef ref,
      required RetailItem retailItem,
      required double stockLimit,
      required double count});

  addCustomSalesOrderItem(
      {required WidgetRef ref,
      required RetailItem retailItem,
      required double stockLimit,
      required double quantity});

  String createSalesOrderNumber({required int a});

  Future<void> addSalesOrder(
      {required String uid,
      required SalesOrder salesOrder,
      required List<Stock> adjustedStockList});

  Future<void> incrementSaleToDailyDemand(
      {required String uid, required String itemID, required double sales});

  submitRetailSalesOrder(
      {required String uid,
      required List<SalesOrderItem> salesOrderItemList,
      required String? paymentTerms,
      required String? orderTotal,
      required List<Stock> stockList});

  Future<void> updateInventoryStatisticsOnSale(
      {required String uid, required String itemID});

  Future<void> addAccountSalesOrder(
      {required String uid,
      required SalesOrder salesOrder,
      required List<Stock> adjustedStockList});

  reviewAndSubmitAccountSalesOrder(
      {required String uid,
      required List<SalesOrderItem> salesOrderItemList,
      required Customer? customer,
      required String? paymentTerms,
      required String? orderTotal,
      required List<Stock> stockList});

  Future<SalesOrder> fetchSalesOrder(
      {required String uid, required String salesOrderID});

  Stream<List<SalesOrder>> streamSalesOrders({required String uid});

  Stream<List<SalesOrder>> streamCurrentSalesOrders({required String uid});
}

abstract class StringInterface {
  String removeTrailingZeros({required double value});
}

abstract class ReportsInterface {
  Future<void> updateDailySalesReport(
      {required String uid, required SalesOrder salesOrder});

  Future<SalesReports> fetchSalesReportMasterList({required String uid});

  Future<DailySalesReport> fetchDailySalesReport(
      {required String uid, required String dateInYYYYMMDD});
}
