import 'dart:async';
import 'dart:io';
import 'package:accustox/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers.dart';
import 'default_values.dart';
import 'enumerated_values.dart';

class UserProfile {
  final String businessName;
  final String ownerName;
  final String email;
  final String contactNumber;
  final String address;
  final String uid;

  UserProfile({
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.contactNumber,
    required this.address,
    required this.uid,
  });

  // Create a UserProfile instance from a Firestore document snapshot
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      businessName: data['businessName'] ?? '',
      ownerName: data['ownerName'] ?? '',
      email: data['email'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      uid: data['uid'] ?? '',
    );
  }

  // Convert UserProfile instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'businessName': businessName,
      'ownerName': ownerName,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'uid': uid,
    };
  }

  // Create a UserProfile instance from a map
  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      businessName: data['businessName'] ?? '',
      ownerName: data['ownerName'] ?? '',
      email: data['email'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      uid: data['uid'] ?? '',
    );
  }

  // Convert UserProfile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'ownerName': ownerName,
      'email': email,
      'contactNumber': contactNumber,
      'address': address,
      'uid': uid,
    };
  }
}

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      state = user;
    });
  }

  void setUser(User? user) {
    state = user;
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);
}

class DashboardData {
  final String label;
  final String content;

  DashboardData(this.label, this.content);
}

Map<ReportingPeriod, DateRange> reportingPeriodDateRanges = {
  ReportingPeriod.today: DateRange(DateTime.now(), DateTime.now()),
  ReportingPeriod.weekToDate: DateRange(
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      DateTime.now()),
  ReportingPeriod.lastWeek: DateRange(
      DateTime.now().subtract(Duration(days: 7 + DateTime.now().weekday - 1)),
      DateTime.now().subtract(Duration(days: DateTime.now().weekday))),
  ReportingPeriod.monthToDate: DateRange(
      DateTime(DateTime.now().year, DateTime.now().month, 1), DateTime.now()),
  ReportingPeriod.lastMonth: DateRange(
      DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
      DateTime(DateTime.now().year, DateTime.now().month, 1)
          .subtract(const Duration(days: 1))),
  ReportingPeriod.yearToDate:
      DateRange(DateTime(DateTime.now().year, 1, 1), DateTime.now()),
  ReportingPeriod.lastYear: DateRange(DateTime(DateTime.now().year - 1, 1, 1),
      DateTime(DateTime.now().year, 1, 1).subtract(const Duration(days: 1))),
};

class CurrentInventoryItemData {
  final String itemName;
  final String sku;
  final double stockLevel;
  final StockLevelState stockLevelState;

  CurrentInventoryItemData(
      this.itemName, this.sku, this.stockLevel, this.stockLevelState);
}

class ItemDetailsData {
  final String imageURL;
  final String itemName;
  final String sku;
  final String ean;
  final String productID;
  final String manufacturer;
  final String brand;
  final String country;
  final String productType;
  final String unitOfMeasurement;
  final String manufacturerPartNumber;

  ItemDetailsData(
      this.imageURL,
      this.itemName,
      this.sku,
      this.ean,
      this.productID,
      this.manufacturer,
      this.brand,
      this.country,
      this.productType,
      this.unitOfMeasurement,
      this.manufacturerPartNumber);
}

class ItemInventoryData {
  final String stockLevel;
  final String stockLocation;
  final String expirationDate;
  final String batchNumber;
  final String costPrice;
  final String salePrice;
  final String purchaseDate;
  final String supplierName;
  final String stockID;

  ItemInventoryData(
      this.stockLevel,
      this.stockLocation,
      this.expirationDate,
      this.batchNumber,
      this.costPrice,
      this.salePrice,
      this.purchaseDate,
      this.supplierName,
      this.stockID);
}

class ItemSupplierData {
  final String supplierName;
  final String contactNumber;
  final String contactPerson;
  final String email;
  final String address;
  final String minimumOrderQuantity;

  ItemSupplierData(this.supplierName, this.contactNumber, this.contactPerson,
      this.email, this.address, this.minimumOrderQuantity);
}

class PurchaseOrderItemListTileData {
  final String itemName;
  final String sku;
  final String quantity;
  final String estimatedPrice;
  final String subtotal;

  PurchaseOrderItemListTileData(this.itemName, this.sku, this.quantity,
      this.estimatedPrice, this.subtotal);
}

class SalesOrderItemListTileData {
  final String itemName;
  final String sku;
  final String quantity;
  final String price;
  final String subtotal;

  SalesOrderItemListTileData(
      this.itemName, this.sku, this.quantity, this.price, this.subtotal);
}

class OutgoingInventoryCardData {
  final String customerName;
  final String totalCost;
  final String salesOrderNumber;
  final List<SalesOrderItemListTileData> salesOrderItemList;

  OutgoingInventoryCardData(this.customerName, this.totalCost,
      this.salesOrderNumber, this.salesOrderItemList);
}

class IncomingInventoryCardData {
  final String supplierName;
  final String purchaseOrderNumber;
  final String estimatedTotalCost;
  final String deliveryAddress;
  final String expectedDeliveryDate;
  final List<PurchaseOrderItemListTileData> purchaseOrderItemList;
  final IncomingInventoryState incomingInventoryState;

  IncomingInventoryCardData(
      this.supplierName,
      this.purchaseOrderNumber,
      this.estimatedTotalCost,
      this.deliveryAddress,
      this.expectedDeliveryDate,
      this.purchaseOrderItemList,
      this.incomingInventoryState);
}

class Supplier {
  final String supplierName;
  final String contactNumber;
  final String contactPerson;
  final String email;
  final String address;
  final String supplierID;

  Supplier({
    required this.supplierName,
    required this.contactNumber,
    required this.contactPerson,
    required this.email,
    required this.address,
    required this.supplierID,
  });

  factory Supplier.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Supplier(
      supplierName: data['supplierName'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      contactPerson: data['contactPerson'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      supplierID: data['supplierID'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'supplierName': supplierName,
      'contactNumber': contactNumber,
      'contactPerson': contactPerson,
      'email': email,
      'address': address,
      'supplierID': supplierID
    };
  }

  factory Supplier.fromMap(Map? data) {
    return Supplier(
      supplierName: data?['supplierName'] ?? '',
      contactNumber: data?['contactNumber'] ?? '',
      contactPerson: data?['contactPerson'] ?? '',
      email: data?['email'] ?? '',
      address: data?['address'] ?? '',
      supplierID: data?['supplierID'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supplierName': supplierName,
      'contactNumber': contactNumber,
      'contactPerson': contactPerson,
      'email': email,
      'address': address,
      'supplierID': supplierID
    };
  }
}

class SupplierCardData {
  final String supplierName;
  final String contactNumber;
  final String contactPerson;
  final String email;
  final String address;
  final String paymentTerms;

  SupplierCardData(this.supplierName, this.contactNumber, this.contactPerson,
      this.email, this.address, this.paymentTerms);
}

class NewSalesOrderItemCardData {
  final String imageURL;
  final String itemName;

  NewSalesOrderItemCardData(this.imageURL, this.itemName);
}

class OrderSummaryListTileData {
  final String itemName;
  final String subTotal;
  final String itemCount;

  OrderSummaryListTileData(this.itemName, this.subTotal, this.itemCount);
}

class Customer {
  final String customerID;
  final String customerName;
  final String customerType;
  final String contactPerson;
  final String contactNumber;
  final String email;
  final String address;

  Customer({
    required this.customerID,
    required this.customerName,
    required this.customerType,
    required this.contactPerson,
    required this.contactNumber,
    required this.email,
    required this.address,
  });

  factory Customer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Customer(
      customerID: data['customerID'] ?? '',
      customerName: data['customerName'] ?? '',
      customerType: data['customerType'] ?? '',
      contactPerson: data['contactPerson'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerID': customerID,
      'customerName': customerName,
      'customerType': customerType,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
    };
  }

  factory Customer.fromMap(Map? map) {
    return Customer(
      customerID: map?['customerID'] ?? '',
      customerName: map?['customerName'] ?? '',
      customerType: map?['customerType'] ?? '',
      contactPerson: map?['contactPerson'] ?? '',
      contactNumber: map?['contactNumber'] ?? '',
      email: map?['email'] ?? '',
      address: map?['address'] ?? '',
    );
  }

  // Convert a Customer object to a map
  Map<String, dynamic> toMap() {
    return {
      'customerID': customerID,
      'customerName': customerName,
      'customerType': customerType,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
    };
  }
}

class Salesperson {
  final String? salespersonName;

  Salesperson({required this.salespersonName});

  factory Salesperson.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    var category = Salesperson(
      salespersonName: data?['salespersonName'],
    );

    return category;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (salespersonName != null) 'salespersonName': salespersonName!,
    };
  }

  factory Salesperson.fromMap(Map? data) {
    return Salesperson(
      salespersonName: data?['salespersonName'] ?? '',
    );
  }
}

class SalespersonDocument {
  List<Map>? salespersonList;

  SalespersonDocument({this.salespersonList});

  factory SalespersonDocument.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return SalespersonDocument(
      salespersonList: data['salespersonList'] is Iterable
          ? List.from(data['salespersonList'])
          : [],
    );
  }
}

class Employee {
  final String? employeeName;
  final String? employeeID;
  final String? employeePin;

  Employee(
      {required this.employeeName,
      required this.employeeID,
      required this.employeePin});

  factory Employee.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    var employee = Employee(
        employeeName: data?['employeeName'],
        employeeID: data?['employeeID'],
        employeePin: data?['employeePin']);

    return employee;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (employeeName != null) 'employeeName': employeeName!,
      if (employeeID != null) 'employeeID': employeeID!,
      if (employeePin != null) 'employeePin': employeePin!,
    };
  }

  factory Employee.fromMap(Map? data) {
    return Employee(
      employeeName: data?['employeeName'] ?? '',
      employeeID: data?['employeeID'] ?? '',
      employeePin: data?['employeePin'] ?? '',
    );
  }
}

class EmployeeDocument {
  List<Map>? employeeList;

  EmployeeDocument({this.employeeList});

  factory EmployeeDocument.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return EmployeeDocument(
      employeeList: data['employeeList'] is Iterable
          ? List.from(data['employeeList'])
          : [],
    );
  }
}

class ItemCardData {
  final String itemName;
  final String sku;
  final String imageURL;

  ItemCardData(this.itemName, this.sku, this.imageURL);
}

class UserProfileChangeNotifier extends ChangeNotifier {
  String? businessName;
  String? ownerName;
  String? email;
  String? contactNumber;
  String? address;
  String? uid;

  // Constructor to create a UserProfileChangeNotifier from an existing UserProfile
  UserProfileChangeNotifier.fromUserProfile(UserProfile userProfile) {
    businessName = userProfile.businessName;
    ownerName = userProfile.ownerName;
    email = userProfile.email;
    contactNumber = userProfile.contactNumber;
    address = userProfile.address;
    uid = userProfile.uid;

    notifyListeners();
  }

  // Method to update the user profile
  void update({
    String? businessName,
    String? ownerName,
    String? email,
    String? contactNumber,
    String? address,
  }) {
    if (ownerName != null) {
      this.ownerName = ownerName;
    }
    if (businessName != null) {
      this.businessName = businessName;
    }
    if (contactNumber != null) {
      this.contactNumber = contactNumber;
    }
    if (address != null) {
      this.address = address;
    }
    if (email != null) {
      this.email = email;
    }

    // Notify listeners that the user profile has been updated
    notifyListeners();
  }
}

class AsyncCurrentInventoryItemDataNotifier
    extends AutoDisposeAsyncNotifier<List<CurrentInventoryItemData>> {
  @override
  FutureOr<List<CurrentInventoryItemData>> build() {
    var data = ref.watch(streamCurrentItemListProvider);
    List<CurrentInventoryItemData> list = [];

    data.whenData((itemList) {
      for (var item in itemList) {
        var inventorySummaryData =
            ref.watch(streamInventorySummaryProvider(item.itemID!));

        var inventorySummary = inventorySummaryData.value!;

        var stockLevelState = inventoryController.getStockLevelState(
            stockLevel: inventorySummary.stockLevel!,
            safetyStockLevel: inventorySummary.safetyStock!,
            reorderPoint: inventorySummary.reorderPoint!);

        list.add(CurrentInventoryItemData(item.itemName!, item.sku!,
            inventorySummary.stockLevel!, stockLevelState));
      }
    });

    return list;
  }
}

class AsyncCurrentInventoryDataListNotifier
    extends AutoDisposeAsyncNotifier<List<CurrentInventoryData>> {
  @override
  FutureOr<List<CurrentInventoryData>> build() {
    var asyncCurrentInventoryList = ref.watch(streamInventoryListProvider);
    var currentInventoryFilter =
        ref.watch(currentInventoryFilterSelectionProvider);
    List<CurrentInventoryData> currentInventoryDataList = [];
    List<CurrentInventoryData> finalList = [];

    asyncCurrentInventoryList.whenData((inventoryList) {
      for (var inventory in inventoryList) {
        var stockLevelState = inventoryController.getStockLevelState(
            stockLevel: inventory.stockLevel!,
            safetyStockLevel: inventory.safetyStockLevel!,
            reorderPoint: inventory.reorderPoint!);
        currentInventoryDataList.add(CurrentInventoryData(
            inventory: inventory, stockLevelState: stockLevelState));
      }
    });
    currentInventoryFilter == CurrentInventoryFilter.all
        ? finalList = currentInventoryDataList
        : finalList = currentInventoryDataList
            .where((currentInventoryData) =>
                currentInventoryData.stockLevelState.label ==
                currentInventoryFilter.label)
            .toList();

    finalList.sort((a, b) => a.inventory.item?['itemName']!
        .toLowerCase()
        .compareTo(b.inventory.item?['itemName']!.toLowerCase()));

    return finalList;
  }

  Future<void> resetState() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return build();
    });
  }
}

class AsyncCategoryFilterListNotifier
    extends AsyncNotifier<List<CategoryFilter>> {
  @override
  FutureOr<List<CategoryFilter>> build() {
    final user = ref.watch(userProfileProvider);
    String? uid = user.asData!.value.uid;

    var data = categoryController.getCategoryFilterList(uid: uid);

    Future<List<CategoryFilter>> _list = data.then((list) {
      // Insert a new CategoryFilter with categoryName: 'All'
      list.insert(
          0,
          CategoryFilter(
            categoryName: 'All',
            categoryID: 'All',
            uid: uid,
            isSelected: false,
          ));

      // Sort the list by categoryName in alphabetical order, treating 'All' as a special case
      list.sort((a, b) {
        if (a.categoryID == 'All') {
          return -1; // 'All' comes before everything else
        } else if (b.categoryID == 'All') {
          return 1; // Everything else comes after 'All'
        } else {
          return a.categoryName!.compareTo(
              b.categoryName!); // Sort alphabetically by categoryName
        }
      });

      return list;
    });

    return _list;
  }

  Future<void> resetState() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return build();
    });
  }
}

class CategoryFilter {
  final String? categoryName;
  final String? uid;
  final String? categoryID;
  bool? isSelected;

  CategoryFilter(
      {this.categoryName, this.uid, this.categoryID, this.isSelected});

  factory CategoryFilter.fromMap(Map data) {
    return CategoryFilter(
        categoryName: data['categoryName'],
        categoryID: data['categoryID'],
        uid: data['uid'],
        isSelected: data['isSelected']);
  }

  CategoryFilter fromCategory(Category category) {
    return CategoryFilter(
      categoryName: category.categoryName,
      uid: category.uid,
      categoryID: category.categoryID,
      isSelected: true,
    );
  }
}

class CategoryDocument {
  List<Map>? categoryList;

  CategoryDocument({this.categoryList});

  factory CategoryDocument.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return CategoryDocument(
      categoryList: data['categoryList'] is Iterable
          ? List.from(data['categoryList'])
          : [],
    );
  }
}

class SupplierDocument {
  List<Map>? supplierList;

  SupplierDocument({this.supplierList});

  factory SupplierDocument.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return SupplierDocument(
      supplierList: data['supplierList'] is Iterable
          ? List.from(data['supplierList'])
          : [],
    );
  }
}

class CustomerDocument {
  List<Map>? customerList;

  CustomerDocument({this.customerList});

  factory CustomerDocument.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return CustomerDocument(
      customerList: data['customerList'] is Iterable
          ? List.from(data['customerList'])
          : [],
    );
  }
}

class Category {
  final String? categoryName;
  final String? uid;
  final String? categoryID;

  Category({
    this.categoryName,
    this.categoryID,
    this.uid,
  });

  factory Category.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    var category = Category(
      categoryName: data?['categoryName'],
      categoryID: data?['categoryID'],
      uid: data?['uid'],
    );

    return category;
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (categoryName != null) 'categoryName': categoryName!,
      if (categoryID != null) 'categoryID': categoryID!,
      if (uid != null) 'uid': uid!,
    };
  }

  factory Category.fromMap(Map? data) {
    return Category(
      categoryName: data?['categoryName'],
      categoryID: data?['categoryID'],
      uid: data?['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (categoryName != null) 'categoryName': categoryName!,
      if (categoryID != null) 'categoryID': categoryID!,
      if (uid != null) 'uid': uid!,
    };
  }

  Category copyWith(
      {String? categoryName,
      String? categoryID,
      String? uid,
      String? imageURL}) {
    return Category(
      categoryName: categoryName ?? this.categoryName,
      categoryID: categoryID ?? this.categoryID,
      uid: uid ?? this.uid,
    );
  }
}

class CategorySelectionData {
  final String? categoryName;
  final String? uid;
  final String? categoryID;
  bool? isSelected;

  CategorySelectionData(
      {this.categoryName, this.categoryID, this.uid, this.isSelected});

  factory CategorySelectionData.fromMap(Map data) {
    return CategorySelectionData(
        categoryName: data['categoryName'],
        categoryID: data['categoryID'],
        uid: data['uid'],
        isSelected: false);
  }

  CategorySelectionData copyWith(
      {String? categoryName,
      String? imageURL,
      String? uid,
      String? categoryID,
      bool? isSelected}) {
    return CategorySelectionData(
        categoryName: categoryName ?? this.categoryName,
        uid: uid ?? this.uid,
        categoryID: categoryID ?? this.categoryID,
        isSelected: isSelected ?? this.isSelected);
  }
}

class ItemDocument {
  List<Map>? itemList;

  ItemDocument({this.itemList});

  factory ItemDocument.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return ItemDocument(
      itemList: data['itemList'] is Iterable ? List.from(data['itemList']) : [],
    );
  }
}

class Item with ChangeNotifier {
  String? itemName;
  String? manufacturer;
  String? sku;
  String? ean;
  String? brand;
  String? productType;
  String? unitOfMeasurement;
  String? manufacturerPartNumber;
  String? itemDescription;
  String? imageURL;
  List<Map>? categoryTags;
  String? itemID;
  String? uid;
  bool? isItemAvailable;
  String? size;
  String? color;
  String? length;
  String? width;
  String? height;
  String? perishability;

  Item(
      {this.itemName,
      this.manufacturer,
      this.sku,
      this.ean,
      this.brand,
      this.productType,
      this.unitOfMeasurement,
      this.manufacturerPartNumber,
      this.itemDescription,
      this.imageURL,
      this.categoryTags,
      this.itemID,
      this.uid,
      this.isItemAvailable,
      this.size,
      this.color,
      this.length,
      this.width,
      this.height,
      this.perishability});

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    var item = Item(
        itemName: data?['itemName'],
        manufacturer: data?['manufacturer'],
        sku: data?['sku'],
        ean: data?['ean'],
        brand: data?['brand'],
        productType: data?['productType'],
        unitOfMeasurement: data?['unitOfMeasurement'],
        manufacturerPartNumber: data?['manufacturerPartNumber'],
        itemDescription: data?['itemDescription'],
        imageURL: data?['imageURL'],
        categoryTags: data?['categoryTags'] is Iterable
            ? List<Map>.from(data?['categoryTags'] ?? [])
            : [],
        itemID: data?['itemID'],
        uid: data?['uid'],
        isItemAvailable: data?['isItemAvailable'] ?? '',
        size: data?['size'],
        color: data?['color'],
        length: data?['length'],
        width: data?['width'],
        height: data?['height'],
        perishability: data?['perishability']);

    return item;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'manufacturer': manufacturer,
      'sku': sku,
      'ean': ean,
      'brand': brand,
      'productType': productType,
      'unitOfMeasurement': unitOfMeasurement,
      'manufacturerPartNumber': manufacturerPartNumber,
      'itemDescription': itemDescription,
      'imageURL': imageURL,
      'categoryTags': categoryTags,
      'itemID': itemID,
      'uid': uid,
      'isItemAvailable': isItemAvailable,
      'size': size,
      'color': color,
      'length': length,
      'width': width,
      'height': height,
      'perishability': perishability,
    };
  }

  factory Item.fromMap(Map data) {
    return Item(
        itemName: data['itemName'] ?? '',
        manufacturer: data['manufacturer'] ?? '',
        sku: data['sku'] ?? '',
        ean: data['ean'] ?? '',
        brand: data['brand'] ?? '',
        productType: data['productType'] ?? '',
        unitOfMeasurement: data['unitOfMeasurement'] ?? '',
        manufacturerPartNumber: data['manufacturerPartNumber'] ?? '',
        itemDescription: data['itemDescription'] ?? '',
        imageURL: data['imageURL'] ?? defaultMerchantImageUrl,
        categoryTags: List<Map>.from(data['categoryTags'] ?? []),
        itemID: data['itemID'] ?? '',
        uid: data['uid'] ?? '',
        isItemAvailable: data['isItemAvailable'] ?? false,
        size: data['size'] ?? '',
        color: data['color'] ?? '',
        length: data['length'] ?? '',
        width: data['width'] ?? '',
        height: data['height'] ?? '',
        perishability: data['perishability'] ?? '');
  }

  Item.fromJson(Map<String, dynamic> json)
      : itemName = json['itemName'],
        manufacturer = json['manufacturer'],
        sku = json['sku'],
        ean = json['ean'],
        brand = json['brand'],
        productType = json['productType'],
        unitOfMeasurement = json['unitOfMeasurement'],
        manufacturerPartNumber = json['manufacturerPartNumber'],
        itemDescription = json['itemDescription'],
        imageURL = json['imageURL'],
        categoryTags = json['categoryTags'],
        itemID = json['itemID'],
        uid = json['uid'],
        isItemAvailable = json['isItemAvailable'];

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'manufacturer': manufacturer,
      'sku': sku,
      'ean': ean,
      'brand': brand,
      'productType': productType,
      'unitOfMeasurement': unitOfMeasurement,
      'manufacturerPartNumber': manufacturerPartNumber,
      'itemDescription': itemDescription,
      'imageURL': imageURL,
      'categoryTags': categoryTags,
      'itemID': itemID,
      'uid': uid,
      'isItemAvailable': isItemAvailable,
    };
  }

  Item copyWith({
    String? itemName,
    String? manufacturer,
    String? unit,
    String? sku,
    String? ean,
    String? brand,
    String? country,
    String? productType,
    String? unitOfMeasurement,
    String? manufacturerPartNumber,
    double? price,
    String? itemDescription,
    String? imageURL,
    List<Map>? categoryTags,
    String? itemID,
    String? uid,
    bool? isItemAvailable,
    String? size,
    String? color,
    String? length,
    String? width,
    String? height,
    String? perishability,
  }) {
    return Item(
        itemName: itemName ?? this.itemName,
        manufacturer: manufacturer ?? this.manufacturer,
        sku: sku ?? this.sku,
        ean: ean ?? this.ean,
        brand: brand ?? this.brand,
        productType: productType ?? this.productType,
        unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
        manufacturerPartNumber:
            manufacturerPartNumber ?? this.manufacturerPartNumber,
        itemDescription: itemDescription ?? this.itemDescription,
        imageURL: imageURL ?? this.imageURL,
        categoryTags: categoryTags ?? this.categoryTags,
        itemID: itemID ?? this.itemID,
        uid: uid ?? this.uid,
        isItemAvailable: isItemAvailable ?? this.isItemAvailable,
        size: size ?? this.size,
        color: color ?? this.color,
        length: length ?? this.length,
        width: width ?? this.width,
        height: height ?? this.height,
        perishability: perishability ?? this.perishability);
  }

  void copyFromChangeNotifier(ItemChangeNotifier notifier) {
    itemName = notifier.itemName;
    manufacturer = notifier.manufacturer;
    sku = notifier.sku;
    ean = notifier.ean;
    brand = notifier.brand;
    productType = notifier.productType;
    unitOfMeasurement = notifier.unitOfMeasurement;
    manufacturerPartNumber = notifier.manufacturerPartNumber;
    itemDescription = notifier.itemDescription;
    imageURL = notifier.imageURL;
    categoryTags = notifier.categoryTags;
    itemID = notifier.itemID;
    uid = notifier.uid;
    isItemAvailable = notifier.isItemAvailable;
    size = notifier.size;
    color = notifier.color;
    length = notifier.length;
    width = notifier.width;
    height = notifier.height;
    perishability = notifier.perishability;
  }

  void update({
    String? itemName,
    String? manufacturer,
    String? sku,
    String? ean,
    String? brand,
    String? productType,
    String? unitOfMeasurement,
    String? manufacturerPartNumber,
    String? itemDescription,
    String? imageURL,
    List<Map>? categoryTags,
    String? itemID,
    String? uid,
    bool? isItemAvailable,
    String? size,
    String? color,
    String? length,
    String? width,
    String? height,
    String? perishability,
  }) {
    if (itemName != null) {
      this.itemName = itemName;
    }
    if (manufacturer != null) {
      this.manufacturer = manufacturer;
    }
    if (sku != null) {
      this.sku = sku;
    }
    if (ean != null) {
      this.ean = ean;
    }
    if (brand != null) {
      this.brand = brand;
    }
    if (productType != null) {
      this.productType = productType;
    }
    if (unitOfMeasurement != null) {
      this.unitOfMeasurement = unitOfMeasurement;
    }
    if (manufacturerPartNumber != null) {
      this.manufacturerPartNumber = manufacturerPartNumber;
    }
    if (itemDescription != null) {
      this.itemDescription = itemDescription;
    }
    if (imageURL != null) {
      this.imageURL = imageURL;
    }
    if (categoryTags != null) {
      this.categoryTags = categoryTags;
    }
    if (itemID != null) {
      this.itemID = itemID;
    }
    if (uid != null) {
      this.uid = uid;
    }
    if (isItemAvailable != null) {
      this.isItemAvailable = isItemAvailable;
    }
    if (size != null) {
      this.size = size;
    }
    if (color != null) {
      this.color = color;
    }
    if (length != null) {
      this.length = length;
    }
    if (width != null) {
      this.width = width;
    }
    if (height != null) {
      this.height = height;
    }
    if (perishability != null) {
      this.perishability = perishability;
    }
    // Notify listeners that the item has been updated
    notifyListeners();
  }
}

class ItemChangeNotifier with ChangeNotifier {
  String? itemName;
  String? manufacturer;
  String? sku;
  String? ean;
  String? brand;
  String? productType;
  String? unitOfMeasurement;
  String? manufacturerPartNumber;
  String? itemDescription;
  String? imageURL;
  List<Map>? categoryTags;
  String? itemID;
  String? uid;
  bool? isItemAvailable;
  String? size;
  String? color;
  String? length;
  String? width;
  String? height;
  String? perishability;

  ItemChangeNotifier(
      {this.itemName,
      this.manufacturer,
      this.sku,
      this.ean,
      this.brand,
      this.productType,
      this.unitOfMeasurement,
      this.manufacturerPartNumber,
      this.itemDescription,
      this.imageURL,
      this.categoryTags,
      this.itemID,
      this.uid,
      this.isItemAvailable,
      this.size,
      this.color,
      this.length,
      this.width,
      this.height,
      this.perishability});

  void update(
      {String? itemName,
      String? manufacturer,
      String? unit,
      String? sku,
      String? ean,
      String? productID,
      String? brand,
      String? country,
      String? productType,
      String? unitOfMeasurement,
      String? manufacturerPartNumber,
      double? price,
      String? itemDescription,
      String? imageURL,
      List<Map>? categoryTags,
      String? itemID,
      String? uid,
      bool? isItemAvailable,
      String? size,
      String? color,
      String? length,
      String? width,
      String? height,
      String? perishability}) {
    this.itemName = itemName ?? this.itemName;
    this.manufacturer = manufacturer ?? this.manufacturer;
    this.sku = sku ?? this.sku;
    this.ean = ean ?? this.ean;
    this.brand = brand ?? this.brand;
    this.productType = productType ?? this.productType;
    this.unitOfMeasurement = unitOfMeasurement ?? this.unitOfMeasurement;
    this.manufacturerPartNumber =
        manufacturerPartNumber ?? this.manufacturerPartNumber;
    this.itemDescription = itemDescription ?? this.itemDescription;
    this.imageURL = imageURL ?? this.imageURL;
    this.categoryTags = categoryTags ?? this.categoryTags;
    this.itemID = itemID ?? this.itemID;
    this.uid = uid ?? this.uid;
    this.isItemAvailable = isItemAvailable ?? this.isItemAvailable;
    this.size = size ?? this.size;
    this.color = color ?? this.color;
    this.length = length ?? this.length;
    this.width = width ?? this.width;
    this.height = height ?? this.height;
    this.perishability = perishability ?? this.perishability;
    notifyListeners();
  }

  ItemChangeNotifier.fromItem(Item item) {
    itemName = item.itemName;
    manufacturer = item.manufacturer;
    sku = item.sku;
    ean = item.ean;
    brand = item.brand;
    productType = item.productType;
    unitOfMeasurement = item.unitOfMeasurement;
    manufacturerPartNumber = item.manufacturerPartNumber;
    itemDescription = item.itemDescription;
    imageURL = item.imageURL;
    categoryTags = item.categoryTags;
    itemID = item.itemID;
    uid = item.uid;
    isItemAvailable = item.isItemAvailable;
    size = item.size;
    color = item.color;
    length = item.length;
    width = item.width;
    height = item.height;
    perishability = item.perishability;
  }
}

class CategoryIDNotifier extends StateNotifier<String?> {
  CategoryIDNotifier() : super(null);

  void setCategoryID(String? id) {
    state = id;
  }
}

class StockLocation {
  String locationID;
  String locationName;
  String description;
  String type;
  String parentLocationID;
  String? documentPath; // Firestore document path
  String locationAddress;

  StockLocation({
    required this.locationID,
    required this.locationName,
    required this.description,
    required this.type,
    required this.parentLocationID,
    required this.locationAddress,
    this.documentPath,
  });

  // Factory constructor to create a Location object from Firestore data
  factory StockLocation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StockLocation(
      locationID: data['locationID'] ?? '',
      locationName: data['locationName'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      parentLocationID: data['parentLocationID'] ?? '',
      locationAddress: data['locationAddress'] ?? '',
      documentPath: doc.reference.path, // Store the Firestore document path
    );
  }

  // Convert Location object to a map for Firestore operations
  Map<String, dynamic> toFirestore() {
    return {
      'locationID': locationID,
      'locationName': locationName,
      'description': description,
      'type': type,
      'parentLocationID': parentLocationID,
      'locationAddress': locationAddress,
    };
  }

  factory StockLocation.fromMap(Map? map) {
    return StockLocation(
      locationID: map?['locationID'] ?? '',
      locationName: map?['locationName'] ?? '',
      description: map?['description'] ?? '',
      type: map?['type'] ?? '',
      parentLocationID: map?['parentLocationID'] ?? '',
      locationAddress: map?['locationAddress'] ?? '',
      documentPath: map?['documentPath'] ?? '',
    );
  }

  // Convert Location object to a map
  Map<String, dynamic> toMap() {
    return {
      'locationID': locationID,
      'locationName': locationName,
      'description': description,
      'type': type,
      'parentLocationID': parentLocationID,
      'locationAddress': locationAddress,
      'documentPath': documentPath,
    };
  }
}

class StockLocationDocument {
  List<Map>? stockLocationList;

  StockLocationDocument({this.stockLocationList});

  factory StockLocationDocument.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return StockLocationDocument(
      stockLocationList: data['stockLocationList'] is Iterable
          ? List.from(data['stockLocationList'])
          : [],
    );
  }
}

class SupplierChangeNotifier extends ChangeNotifier {
  String? supplierName;
  String? contactNumber;
  String? contactPerson;
  String? email;
  String? address;
  String? supplierID;

  SupplierChangeNotifier.fromSupplier(Supplier supplier) {
    supplierName = supplier.supplierName;
    contactPerson = supplier.contactPerson;
    email = supplier.email;
    contactNumber = supplier.contactNumber;
    address = supplier.address;
    supplierID = supplier.supplierID;

    notifyListeners();
  }

  // Method to update the user profile
  void update({
    String? supplierName,
    String? contactNumber,
    String? contactPerson,
    String? email,
    String? address,
    String? supplierID,
  }) {
    if (supplierName != null) {
      this.supplierName = supplierName;
    }
    if (contactPerson != null) {
      this.contactPerson = contactPerson;
    }
    if (contactNumber != null) {
      this.contactNumber = contactNumber;
    }
    if (address != null) {
      this.address = address;
    }
    if (email != null) {
      this.email = email;
    }

    // Notify listeners that the user profile has been updated
    notifyListeners();
  }
}

class ImageFile with ChangeNotifier {
  File? _file;

  File? get file => _file;

  set file(File? imageFile) {
    _file = imageFile;
    notifyListeners();
  }
}

class ImageStorageUploadData extends ChangeNotifier {
  String? _imageUrl;

  String? get imageUrl => _imageUrl;

  set newImageUrl(String? newImageUrl) {
    _imageUrl = newImageUrl;
    notifyListeners();
  }
}

class AsyncCategorySelectionDataNotifier
    extends AsyncNotifier<List<CategorySelectionData>> {
  @override
  Future<List<CategorySelectionData>> build() {
    final user = ref.watch(userProfileProvider);
    String? uid = user.asData!.value.uid;

    var data = categoryController.getCategoryListWithSelection(uid: uid);
    Future<List<CategorySelectionData>> list = data;
    return list;
  }

  Future<void> resetState() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.watch(userProfileProvider);
      String? uid = user.asData!.value.uid;
      var data = categoryController.getCategoryListWithSelection(uid: uid);
      Future<List<CategorySelectionData>> _list = data;
      return _list;
    });
  }
}

class ItemCategorySelection extends ChangeNotifier {
  List<Category> _categoryList = [];

  List<Category>? get categoryList => _categoryList;

  set newCategoryList(List<Category> newCategoryList) {
    _categoryList = newCategoryList;
    notifyListeners();
  }
}

class CategoriesNotifier extends Notifier<List<Category>> {
  @override
  List<Category> build() {
    return [];
  }

  void addCategory(Category category) {
    state = [...state, category];
  }

  void removeCategory(String categoryID) {
    state = [
      for (final category in state)
        if (category.categoryID != categoryID) category
    ];
  }

  void resetState() {
    state = [];
  }

  Future<void> updateCategories(
      List<Map<dynamic, dynamic>> categoryIDsToSelect, String uid) async {
    try {
      final categories = categoryIDsToSelect
          .map((categoryID) =>
              Category(categoryID: categoryID['categoryID'], uid: uid))
          .toList();
      state = [...state, ...categories];
    } catch (e) {
      // Handle exception
      debugPrint('Error updating categories: $e');
    }
  }
}

class InventorySummary {
  final double? inventoryValue;
  final double? stockLevel;
  final double? reservedStock;
  final double? backOrderStock;
  final double? safetyStock;
  final double? leadTime;
  final double? reorderPoint;
  final String? itemID;

  InventorySummary(
      {required this.inventoryValue,
      required this.stockLevel,
      required this.reservedStock,
      required this.backOrderStock,
      required this.safetyStock,
      required this.leadTime,
      required this.reorderPoint,
      required this.itemID});

  // Create an instance of InventorySummary from Firestore document snapshot
  factory InventorySummary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InventorySummary(
        inventoryValue: data['inventoryValue'],
        stockLevel: data['stockLevel'],
        reservedStock: data['reservedStock'],
        backOrderStock: data['backOrderStock'],
        safetyStock: data['safetyStock'],
        leadTime: data['leadTime'],
        reorderPoint: data['reorderPoint'],
        itemID: data['itemID']);
  }

  // Convert InventorySummary to a map that can be stored in Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'inventoryValue': inventoryValue,
      'stockLevel': stockLevel,
      'reservedStock': reservedStock,
      'backOrderStock': backOrderStock,
      'safetyStock': safetyStock,
      'leadTime': leadTime,
      'reorderPoint': reorderPoint,
      'itemID': itemID,
    };
  }

  // Convert InventorySummary to a map for general purposes (not Firestore-specific)
  Map<String, dynamic> toMap() {
    return {
      'inventoryValue': inventoryValue,
      'stockLevel': stockLevel,
      'reservedStock': reservedStock,
      'backOrderStock': backOrderStock,
      'safetyStock': safetyStock,
      'leadTime': leadTime,
      'reorderPoint': reorderPoint,
      'itemID': itemID
    };
  }

  // Create an instance of InventorySummary from a map
  factory InventorySummary.fromMap(Map? map) {
    return InventorySummary(
        inventoryValue: map?['inventoryValue'],
        stockLevel: map?['stockLevel'],
        reservedStock: map?['reservedStock'],
        backOrderStock: map?['backOrderStock'],
        safetyStock: map?['safetyStock'],
        leadTime: map?['leadTime'],
        reorderPoint: map?['reorderPoint'],
        itemID: map?['itemID']);
  }
}

class Inventory with ChangeNotifier {
  Map? item;
  final double? beginningInventory;
  final double? maximumDailyDemand;
  final double? maximumLeadTime;
  final double? averageDailyDemand;
  final double? averageLeadTime;
  final double? currentInventory;
  final double? backOrder;
  final double? stockLevel;
  final double? safetyStockLevel;
  final double? reorderPoint;

  Inventory({
    required this.item,
    required this.beginningInventory,
    required this.maximumDailyDemand,
    required this.maximumLeadTime,
    required this.averageDailyDemand,
    required this.averageLeadTime,
    required this.currentInventory,
    required this.backOrder,
    required this.stockLevel,
    required this.safetyStockLevel,
    required this.reorderPoint,
  });

  factory Inventory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Inventory(
      item: data['item'],
      beginningInventory: data['beginningInventory'],
      maximumDailyDemand: data['maximumDailyDemand'],
      maximumLeadTime: data['maximumLeadTime'],
      averageDailyDemand: data['averageDailyDemand'],
      averageLeadTime: data['averageLeadTime'],
      currentInventory: data['currentInventory'],
      backOrder: data['backOrder'],
      stockLevel: data['stockLevel'],
      safetyStockLevel: data['safetyStockLevel'],
      reorderPoint: data['reorderPoint'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'beginningInventory': beginningInventory,
      'maximumDailyDemand': maximumDailyDemand,
      'maximumLeadTime': maximumLeadTime,
      'averageDailyDemand': averageDailyDemand,
      'averageLeadTime': averageLeadTime,
      'currentInventory': currentInventory,
      'backOrder': backOrder,
      'stockLevel': stockLevel,
      'safetyStockLevel': safetyStockLevel,
      'reorderPoint': reorderPoint,
    };
  }

  factory Inventory.fromMap(Map? map) {
    return Inventory(
      item: map?['item'],
      beginningInventory: map?['beginningInventory'],
      maximumDailyDemand: map?['maximumDailyDemand'],
      maximumLeadTime: map?['maximumLeadTime'],
      averageDailyDemand: map?['averageDailyDemand'],
      averageLeadTime: map?['averageLeadTime'],
      currentInventory: map?['currentInventory'],
      backOrder: map?['backOrder'],
      stockLevel: map?['stockLevel'],
      safetyStockLevel: map?['safetyStockLevel'],
      reorderPoint: map?['reorderPoint'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'item': item,
      'beginningInventory': beginningInventory,
      'maximumDailyDemand': maximumDailyDemand,
      'maximumLeadTime': maximumLeadTime,
      'averageDailyDemand': averageDailyDemand,
      'averageLeadTime': averageLeadTime,
      'currentInventory': currentInventory,
      'backOrder': backOrder,
      'stockLevel': stockLevel,
      'safetyStockLevel': safetyStockLevel,
      'reorderPoint': reorderPoint,
    };
  }

  void update({Map? item}) {
    if (item != null) {
      this.item = item;
    }

    notifyListeners();
  }
}

class Stock with ChangeNotifier {
  Map? item;
  final double? stockLevel;
  final Map? stockLocation;
  final DateTime? expirationDate;
  final String? batchNumber;
  final double? costPrice;
  final double? salePrice;
  final DateTime? purchaseDate;
  final DateTime? inventoryCreatedOn;
  final double? expirationWarning;
  final Map? supplier;
  final String? stockID;

  Stock(
      {required this.item,
      required this.supplier,
      required this.stockLevel,
      required this.stockLocation,
      required this.expirationDate,
      required this.batchNumber,
      required this.costPrice,
      required this.salePrice,
      required this.purchaseDate,
      required this.inventoryCreatedOn,
      required this.expirationWarning,
      required this.stockID});

  factory Stock.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Stock(
        item: data['item'],
        supplier: data['supplier'] ?? {},
        stockLevel: data['stockLevel'] ?? 0.0,
        stockLocation: data['stockLocation'] ?? {},
        expirationDate: dateTimeController.timestampToDateTime(
            timestamp: data['expirationDate']),
        batchNumber: data['batchNumber'] ?? '',
        costPrice: data['costPrice'] ?? 0.0,
        salePrice: data['salePrice'] ?? 0.0,
        purchaseDate: dateTimeController.timestampToDateTime(
            timestamp: data['purchaseDate']),
        inventoryCreatedOn: dateTimeController.timestampToDateTime(
            timestamp: data['inventoryCreatedOn']),
        expirationWarning: data['expirationWarning'] ?? 0.0,
        stockID: data['stockID'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'supplier': supplier,
      'stockLevel': stockLevel,
      'stockLocation': stockLocation,
      'expirationDate': expirationDate,
      'batchNumber': batchNumber,
      'costPrice': costPrice,
      'salePrice': salePrice,
      'purchaseDate': purchaseDate,
      'inventoryCreatedOn': inventoryCreatedOn,
      'expirationWarning': expirationWarning,
      'stockID': stockID,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
        item: map['item'],
        supplier: map['supplier'],
        stockLevel: map['stockLevel'],
        stockLocation: map['stockLocation'],
        expirationDate: map['expirationDate'],
        batchNumber: map['batchNumber'],
        costPrice: map['costPrice'],
        salePrice: map['salePrice'],
        purchaseDate: map['purchaseDate'],
        inventoryCreatedOn: map['inventoryCreatedOn'],
        expirationWarning: map['expirationWarning'],
        stockID: map['stockID']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'item': item,
      'supplier': supplier,
      'stockLevel': stockLevel,
      'stockLocation': stockLocation,
      'expirationDate':
          dateTimeController.dateTimeToTimestamp(dateTime: expirationDate!),
      'batchNumber': batchNumber,
      'costPrice': costPrice,
      'salePrice': salePrice,
      'purchaseDate':
          dateTimeController.dateTimeToTimestamp(dateTime: purchaseDate!),
      'inventoryCreatedOn':
          dateTimeController.dateTimeToTimestamp(dateTime: inventoryCreatedOn!),
      'expirationWarning': expirationWarning,
      'stockID': stockID
    };
  }

  void update({Map? item}) {
    if (item != null) {
      this.item = item;
    }

    notifyListeners();
  }
}

class ItemInventory {
  final String? itemName;
  final String? manufacturer;
  final String? sku;
  final String? ean;
  final String? brand;
  final String? productType;
  final String? unitOfMeasurement;
  final String? manufacturerPartNumber;
  final String? itemDescription;
  final String? imageURL;
  final List<Map>? categoryTags;
  final String? itemID;
  final String? uid;
  final bool? isItemAvailable;
  final String? size;
  final String? color;
  final String? length;
  final String? width;
  final String? height;
  final double? inventoryValue;
  final double? stockLevel;
  final double? reservedStock;
  final double? backOrderStock;
  final double? safetyStock;
  final double? leadTime;
  final double? reorderPoint;

  ItemInventory({
    this.itemName,
    this.manufacturer,
    this.sku,
    this.ean,
    this.brand,
    this.productType,
    this.unitOfMeasurement,
    this.manufacturerPartNumber,
    this.itemDescription,
    this.imageURL,
    this.categoryTags,
    this.itemID,
    this.uid,
    this.isItemAvailable,
    this.size,
    this.color,
    this.length,
    this.width,
    this.height,
    this.inventoryValue,
    this.stockLevel,
    this.reservedStock,
    this.backOrderStock,
    this.safetyStock,
    this.leadTime,
    this.reorderPoint,
  });

  factory ItemInventory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemInventory(
      itemName: data['itemName'],
      manufacturer: data['manufacturer'],
      sku: data['sku'],
      ean: data['ean'],
      brand: data['brand'],
      productType: data['productType'],
      unitOfMeasurement: data['unitOfMeasurement'],
      manufacturerPartNumber: data['manufacturerPartNumber'],
      itemDescription: data['itemDescription'],
      imageURL: data['imageURL'],
      categoryTags: data['categoryTags'] is Iterable
          ? List<Map>.from(data['categoryTags'] ?? [])
          : [],
      itemID: data['itemID'],
      uid: data['uid'],
      isItemAvailable: data['isItemAvailable'],
      size: data['size'],
      color: data['color'],
      length: data['length'],
      width: data['width'],
      height: data['height'],
      inventoryValue: data['inventoryValue'],
      stockLevel: data['stockLevel'],
      reservedStock: data['reservedStock'],
      backOrderStock: data['backOrderStock'],
      safetyStock: data['safetyStock'],
      leadTime: data['leadTime'],
      reorderPoint: data['reorderPoint'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'manufacturer': manufacturer,
      'sku': sku,
      'ean': ean,
      'brand': brand,
      'productType': productType,
      'unitOfMeasurement': unitOfMeasurement,
      'manufacturerPartNumber': manufacturerPartNumber,
      'itemDescription': itemDescription,
      'imageURL': imageURL,
      'categoryTags': categoryTags,
      'itemID': itemID,
      'uid': uid,
      'isItemAvailable': isItemAvailable,
      'size': size,
      'color': color,
      'length': length,
      'width': width,
      'height': height,
      'inventoryValue': inventoryValue,
      'stockLevel': stockLevel,
      'reservedStock': reservedStock,
      'backOrderStock': backOrderStock,
      'safetyStock': safetyStock,
      'leadTime': leadTime,
      'reorderPoint': reorderPoint,
    };
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = {
      'itemName': itemName,
      'manufacturer': manufacturer,
      'sku': sku,
      'ean': ean,
      'brand': brand,
      'productType': productType,
      'unitOfMeasurement': unitOfMeasurement,
      'manufacturerPartNumber': manufacturerPartNumber,
      'itemDescription': itemDescription,
      'imageURL': imageURL,
      'categoryTags': categoryTags,
      'itemID': itemID,
      'uid': uid,
      'isItemAvailable': isItemAvailable,
      'size': size,
      'color': color,
      'length': length,
      'width': width,
      'height': height,
      'inventoryValue': inventoryValue,
      'stockLevel': stockLevel,
      'reservedStock': reservedStock,
      'backOrderStock': backOrderStock,
      'safetyStock': safetyStock,
      'leadTime': leadTime,
      'reorderPoint': reorderPoint,
    };

    return data;
  }

  // Method to convert a Map to an ItemInventory object
  factory ItemInventory.fromMap(Map? data) {
    return ItemInventory(
      itemName: data?['itemName'],
      manufacturer: data?['manufacturer'],
      sku: data?['sku'],
      ean: data?['ean'],
      brand: data?['brand'],
      productType: data?['productType'],
      unitOfMeasurement: data?['unitOfMeasurement'],
      manufacturerPartNumber: data?['manufacturerPartNumber'],
      itemDescription: data?['itemDescription'],
      imageURL: data?['imageURL'],
      categoryTags: List<Map>.from(data?['categoryTags']),
      itemID: data?['itemID'],
      uid: data?['uid'],
      isItemAvailable: data?['isItemAvailable'],
      size: data?['size'],
      color: data?['color'],
      length: data?['length'],
      width: data?['width'],
      height: data?['height'],
      inventoryValue: data?['inventoryValue'],
      stockLevel: data?['stockLevel'],
      reservedStock: data?['reservedStock'],
      backOrderStock: data?['backOrderStock'],
      safetyStock: data?['safetyStock'],
      leadTime: data?['leadTime'],
      reorderPoint: data?['reorderPoint'],
    );
  }
}

class DemandHistory {
  final DateTime timestamp;
  final double demand;
  final String itemID;
  final String transactionID;

  DemandHistory(this.timestamp, this.demand, this.itemID, this.transactionID);
}

class LeadTimeHistory {
  final DateTime timestamp;
  final double leadTime;
  final String itemID;

  LeadTimeHistory(this.timestamp, this.leadTime, this.itemID);
}

class SalesOrder {
  final Map? customer;
  final DateTime transactionMadeOn;
  final String paymentTerms;
  final String transactionProcessedBy;
  final List<Map?> itemOrders;
  final double orderTotal;
  final String salesOrderID;

  SalesOrder(
      {required this.customer,
      required this.transactionMadeOn,
      required this.paymentTerms,
      required this.transactionProcessedBy,
      required this.itemOrders,
      required this.orderTotal,
      required this.salesOrderID});
}

class ItemOrder {
  final String itemId;
  final String itemName;
  final String sku;
  final double quantity;
  final double price;
  final double subTotal;

  ItemOrder(
      {required this.itemId,
      required this.itemName,
      required this.sku,
      required this.quantity,
      required this.price,
      required this.subTotal});
}

class StockLocationSelectionNotifier extends StateNotifier<StockLocation?> {
  StockLocationSelectionNotifier(super.state);

  void setLocation(StockLocation stockLocation) {
    state = stockLocation;
  }
}

class SupplierSelectionNotifier extends StateNotifier<Supplier?> {
  SupplierSelectionNotifier(super.state);

  void setSupplier(Supplier supplier) {
    state = supplier;
  }
}

class CurrentInventoryData {
  final Inventory inventory;
  final StockLevelState stockLevelState;

  CurrentInventoryData(
      {required this.inventory, required this.stockLevelState});
}

class InventoryTransaction {
  final String inventoryTransactionID;
  final String transactionType;
  final double quantityChange;
  final DateTime transactionMadeOn;
  final Map<String, dynamic>? stock;
  final String reason;

  InventoryTransaction({
    required this.inventoryTransactionID,
    required this.transactionType,
    required this.quantityChange,
    required this.transactionMadeOn,
    required this.reason,
    required this.stock,
  });

  factory InventoryTransaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InventoryTransaction(
      inventoryTransactionID: data['inventoryTransactionID'] ?? '',
      transactionType: data['transactionType'] ?? '',
      quantityChange: data['quantityChange'],
      transactionMadeOn: dateTimeController.timestampToDateTime(
          timestamp: data['transactionMadeOn']),
      reason: data['reason'] ?? '',
      stock: data['stock'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'inventoryTransactionId': inventoryTransactionID,
      'transactionType': transactionType,
      'quantityChange': quantityChange,
      'transactionMadeOn': Timestamp.fromDate(transactionMadeOn),
      'reason': reason, // Include reason in Firestore data
      'stock': stock,
    };
  }

  factory InventoryTransaction.fromMap(Map map) {
    return InventoryTransaction(
      inventoryTransactionID: map['inventoryTransactionID'],
      transactionType: map['transactionType'],
      quantityChange: map['quantityChange'],
      transactionMadeOn: map['transactionMadeOn'],
      reason: map['reason'],
      stock: map['stock'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inventoryTransactionID': inventoryTransactionID,
      'transactionType': transactionType,
      'quantityChange': quantityChange,
      'transactionMadeOn': transactionMadeOn,
      'reason': reason, // Include reason in the Map
      'stock': stock,
    };
  }
}
