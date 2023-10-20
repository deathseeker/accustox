import 'package:accustox/enumerated_values.dart';
import 'package:accustox/widget_components.dart';
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

final streamCustomerAccountProvider = StreamProvider.autoDispose
    .family<CustomerAccount, String>((ref, customerID) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return customerController.streamCustomerAccount(
      uid: uid, customerID: customerID);
});

StreamProvider<List<Salesperson>> salespersonListStreamProvider =
    StreamProvider((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return userController.streamSalespersonList(uid: uid);
});

final streamSalesOrderProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return salesOrderController.streamSalesOrders(uid: uid);
});

final streamCurrentSalesOrderProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return salesOrderController.streamCurrentSalesOrders(uid: uid);
});

final asyncCategoryFilterListProvider = AsyncNotifierProvider<
    AsyncCategoryFilterListNotifier, List<CategoryFilter>>(() {
  return AsyncCategoryFilterListNotifier();
});

final asyncCurrentInventoryDataListProvider = AutoDisposeAsyncNotifierProvider<
    AsyncCurrentInventoryDataListNotifier, List<CurrentInventoryData>>(() {
  return AsyncCurrentInventoryDataListNotifier();
});

final asyncIncomingInventoryDataListProvider = AutoDisposeAsyncNotifierProvider<
    AsyncIncomingInventoryDataListNotifier, List<IncomingInventoryData>>(() {
  return AsyncIncomingInventoryDataListNotifier();
});

final asyncNewSalesOrderItemCardListProvider = AutoDisposeAsyncNotifierProvider<
    AsyncNewSalesOrderItemCardListNotifier, List<NewSalesOrderItemCard>>(() {
  return AsyncNewSalesOrderItemCardListNotifier();
});

final asyncRetailItemListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    AsyncRetailItemListNotifier, List<RetailItem>>(() {
  return AsyncRetailItemListNotifier();
});
final categoryIDProvider = StateNotifierProvider<CategoryIDNotifier, String?>(
  (ref) => CategoryIDNotifier(),
);

final streamItemListProvider = StreamProvider.autoDispose<List<Item>>((ref) {
  final user = ref.watch(userProfileProvider);
  String? uid = user.asData!.value.uid;

  return itemController.streamItemDataList(uid: uid);
});

final streamItemsListByCategoryFilterProvider =
    StreamProvider.autoDispose<List<Item>>((ref) {
  ref.watch(_userProvider);
  final user = ref.watch(userProfileProvider);
  String? uid = user.asData!.value.uid;
  var categoryID = ref.watch(categoryIDProvider);

  if (categoryID == 'All') {
    // Return the unfiltered list of items
    var list = itemController.streamItemDataList(uid: uid);
    return list;
  } else {
    // Return the filtered list of items by categoryID
    var list = itemController.getFilteredItemsStreamByCategory(
        uid: uid, categoryID: categoryID!);
    return list;
  }
});

StreamProvider<List<Category>> streamCategoryListProvider =
    StreamProvider((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return categoryController.streamCategoryDataList(uid: uid);
});

final streamLocationDataListProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return stockLocationController.streamLocationDataList(uid: uid);
});

final inventoryLocationTypeProvider = StateProvider<InventoryLocationType>(
  (ref) => InventoryLocationType.warehouse,
);

final customerTypeProvider = StateProvider<CustomerType>(
  (ref) => CustomerType.individual,
);

final saleTypeProvider = StateProvider<SaleType>(
  (ref) => SaleType.retail,
);

final paymentTermsProvider = StateProvider<PaymentTerm>(
  (ref) => PaymentTerm.cash,
);

StreamProvider<List<StockLocation>> streamLocationListProvider =
    StreamProvider((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return stockLocationController.streamParentLocationDataList(uid: uid);
});

final streamSubLocationListProvider =
    StreamProvider.autoDispose.family<List<StockLocation>, String>((ref, path) {
  return stockLocationController.streamSubLocationDataList(path: path);
});

final streamStockListProvider =
    StreamProvider.autoDispose.family<List<Stock>, String>((ref, itemID) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return inventoryController.streamStockList(uid: uid, itemID: itemID);
});

final streamRetailStockListProvider =
    StreamProvider.autoDispose.family<List<Stock>, String>((ref, itemID) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return inventoryController.streamRetailStockList(uid: uid, itemID: itemID);
});

final purchaseOrderCartNotifierProvider = StateNotifierProvider.autoDispose<
    PurchaseOrderCartNotifier,
    List<PurchaseOrderItem>>((ref) => PurchaseOrderCartNotifier());

final salesOrderCartNotifierProvider = StateNotifierProvider.autoDispose<
    SalesOrderCartNotifier,
    List<SalesOrderItem>>((ref) => SalesOrderCartNotifier());

final adjustedStockListNotifierProvider =
    StateNotifierProvider.autoDispose<AdjustedStockListNotifier, List<Stock>>(
        (ref) => AdjustedStockListNotifier());

StreamProvider<List<Supplier>> streamSupplierListProvider =
    StreamProvider((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return supplierController.streamSupplierDataList(uid: uid);
});

StreamProvider<List<Customer>> streamCustomerListProvider =
    StreamProvider((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return customerController.streamCustomerDataList(uid: uid);
});

final streamCurrentItemListProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return itemController.streamCurrentItemList(uid: uid);
});

final streamInventoryListProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return inventoryController.streamInventoryList(uid: uid);
});

final streamRetailItemListProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return salesOrderController.streamRetailItemDataList(uid: uid);
});

final streamIncomingInventoryListProvider = StreamProvider.autoDispose((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return purchaseOrderController.streamIncomingInventoryList(uid: uid);
});

final streamInventoryProvider =
    StreamProvider.autoDispose.family<Inventory, String>((ref, itemID) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return inventoryController.streamInventory(uid, itemID);
});

final streamInventorySummaryProvider =
    StreamProvider.autoDispose.family<InventorySummary, String>((ref, itemID) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;
  return inventoryController.streamInventorySummary(uid: uid, itemID: itemID);
});

final streamTransactionListProvider = StreamProvider.autoDispose
    .family<List<InventoryTransaction>, Inventory>((ref, inventory) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;

  return inventoryController.streamInventoryTransactionList(
      uid: uid, inventory: inventory);
});

final streamPurchaseOrderProvider = StreamProvider.autoDispose
    .family<PurchaseOrder, String>((ref, purchaseOrderID) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;

  return purchaseOrderController.streamPurchaseOrder(
      uid: uid, purchaseOrderID: purchaseOrderID);
});

final asyncCategorySelectionDataProvider = AsyncNotifierProvider<
    AsyncCategorySelectionDataNotifier, List<CategorySelectionData>>(() {
  return AsyncCategorySelectionDataNotifier();
});

Provider<ItemCategorySelection> itemCategorySelectionProvider =
    Provider<ItemCategorySelection>((ref) => ItemCategorySelection());

final categorySelectionProvider =
    NotifierProvider<CategoriesNotifier, List<Category>>(() {
  return CategoriesNotifier();
});

final getSelectionListForItemCategoryProvider = FutureProvider.autoDispose
    .family<List<CategorySelectionData>, List<Map<dynamic, dynamic>>>(
        (ref, list) async {
  var categoryList = ref.watch(asyncCategorySelectionDataProvider);
  List<CategorySelectionData> categories = [];
  categoryList.whenData((value) => categories = value);

  void updateSelection(List<CategorySelectionData> listToUpdate,
      List<Map<dynamic, dynamic>> categoryIDsToSelect) {
    for (var category in listToUpdate) {
      var isSelected = categoryIDsToSelect
          .any((item) => item['categoryID'] == category.categoryID);
      category.isSelected = isSelected;
    }
  }

  List<Map<dynamic, dynamic>> categoryIDsToSelect = list;
  updateSelection(categories, categoryIDsToSelect);

  categories.sort((a, b) =>
      a.categoryName!.toLowerCase().compareTo(b.categoryName!.toLowerCase()));

  return categories;
});

final locationSelectionProvider = StateNotifierProvider.autoDispose<
    StockLocationSelectionNotifier,
    StockLocation?>((ref) => StockLocationSelectionNotifier(null));

final perishabilityProvider = StateProvider<Perishability>(
  (ref) => Perishability.nonPerishableGoods,
);

final currentInventoryFilterSelectionProvider =
    StateProvider<CurrentInventoryFilter>((ref) => CurrentInventoryFilter.all);

final incomingInventoryFilterSelectionProvider =
    StateProvider<IncomingInventoryFilter>(
        (ref) => IncomingInventoryFilter.all);

final supplierSelectionProvider =
    StateNotifierProvider.autoDispose<SupplierSelectionNotifier, Supplier?>(
        (ref) => SupplierSelectionNotifier(null));

final customerSelectionProvider =
    StateNotifierProvider.autoDispose<CustomerSelectionNotifier, Customer?>(
        (ref) => CustomerSelectionNotifier(null));

final salesOrderProvider =
    FutureProvider.family<SalesOrder, String>((ref, salesOrderID) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;

  return salesOrderController.fetchSalesOrder(
      uid: uid, salesOrderID: salesOrderID);
});

final salesReportMasterListProvider = FutureProvider.autoDispose((ref) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;

  return reportsController.fetchSalesReportMasterList(uid: uid);
});

final dailySalesReportProvider = FutureProvider.autoDispose
    .family<DailySalesReport, String>((ref, dateInYYYYMMDD) {
  final user = ref.watch(_userProvider);
  String uid = user.asData!.value!.uid;

  return reportsController.fetchDailySalesReport(
      uid: uid, dateInYYYYMMDD: dateInYYYYMMDD);
});

final asyncItemSalesSummaryProvider = AutoDisposeAsyncNotifierProviderFamily<
    AsyncItemSalesSummaryList,
    List<ItemSalesSummary>,
    DailySalesReport>(() => AsyncItemSalesSummaryList());
