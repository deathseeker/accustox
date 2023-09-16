import 'dart:async';

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
  final String paymentTerms;

  Supplier(this.supplierName, this.contactNumber, this.contactPerson,
      this.email, this.address, this.paymentTerms);
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
  final String customerName;
  final String customerType;
  final String contactPerson;
  final String contactNumber;
  final String email;
  final String address;

  Customer(this.customerName, this.customerType, this.contactPerson,
      this.contactNumber, this.email, this.address);
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
        uid: uid ?? this.uid,);
  }
}

class CategorySelectionData {
  final String? categoryName;
  final String? uid;
  final String? categoryID;
  bool? isSelected;

  CategorySelectionData(
      {this.categoryName,
      this.categoryID,
      this.uid,
      this.isSelected});

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

class Item {
  String? itemName;
  String? manufacturer;
  String? unit;
  String? sku;
  String? ean;
  String? productID;
  String? brand;
  String? country;
  String? productType;
  String? unitOfMeasurement;
  String? manufacturerPartNumber;
  String? itemDescription;
  String? imageURL;
  List<Map>? categoryTags;
  String? itemID;
  String? uid;
  bool? isItemAvailable;


  Item({
    this.itemName,
    this.manufacturer,
    this.unit,
    this.sku,
    this.ean,
    this.productID,
    this.brand,
    this.country,
    this.productType,
    this.unitOfMeasurement,
    this.manufacturerPartNumber,
    this.itemDescription,
    this.imageURL,
    this.categoryTags,
    this.itemID,
    this.uid,
    this.isItemAvailable,
  });

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    var item = Item(
      itemName: data?['itemName'],
      manufacturer: data?['manufacturer'],
      unit: data?['unit'],
      sku: data?['sku'],
      ean: data?['ean'],
      productID: data?['productID'],
      brand: data?['brand'],
      country: data?['country'],
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
      isItemAvailable: data?['isItemAvailable'],
    );

    return item;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'manufacturer': manufacturer,
      'unit': unit,
      'sku': sku,
      'ean': ean,
      'productID': productID,
      'brand': brand,
      'country': country,
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

  factory Item.fromMap(Map data) {
    return Item(
      itemName: data['itemName'] ?? '',
      manufacturer: data['manufacturer'] ?? '',
      unit: data['unit'] ?? '',
      sku: data['sku'] ?? '',
      ean: data['ean'] ?? '',
      productID: data['productID'] ?? '',
      brand: data['brand'] ?? '',
      country: data['country'] ?? '',
      productType: data['productType'] ?? '',
      unitOfMeasurement: data['unitOfMeasurement'] ?? '',
      manufacturerPartNumber: data['manufacturerPartNumber'] ?? '',
      itemDescription: data['itemDescription'] ?? '',
      imageURL: data['imageURL'] ?? defaultMerchantImageUrl,
      categoryTags: List<Map>.from(data['categoryTags'] ?? []),
      itemID: data['itemID'] ?? '',
      uid: data['uid'] ?? '',
      isItemAvailable: data['isItemAvailable'] ?? false,
    );
  }

  Item.fromJson(Map<String, dynamic> json)
      : itemName = json['itemName'],
        manufacturer = json['manufacturer'],
        unit = json['unit'],
        sku = json['sku'],
        ean = json['ean'],
        productID = json['productID'],
        brand = json['brand'],
        country = json['country'],
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
      'unit': unit,
      'sku': sku,
      'ean': ean,
      'productID': productID,
      'brand': brand,
      'country': country,
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
  }) {
    return Item(
      itemName: itemName ?? this.itemName,
      manufacturer: manufacturer ?? this.manufacturer,
      unit: unit ?? this.unit,
      sku: sku ?? this.sku,
      ean: ean ?? this.ean,
      productID: productID ?? this.productID,
      brand: brand ?? this.brand,
      country: country ?? this.country,
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
    );
  }

  void copyFromChangeNotifier(ItemChangeNotifier notifier) {
    itemName = notifier.itemName;
    manufacturer = notifier.manufacturer;
    unit = notifier.unit;
    sku = notifier.sku;
    ean = notifier.ean;
    productID = notifier.productID;
    brand = notifier.brand;
    country = notifier.country;
    productType = notifier.productType;
    unitOfMeasurement = notifier.unitOfMeasurement;
    manufacturerPartNumber = notifier.manufacturerPartNumber;
    itemDescription = notifier.itemDescription;
    imageURL = notifier.imageURL;
    categoryTags = notifier.categoryTags;
    itemID = notifier.itemID;
    uid = notifier.uid;
    isItemAvailable = notifier.isItemAvailable;
  }
}

class ItemChangeNotifier with ChangeNotifier {
  String? itemName;
  String? manufacturer;
  String? unit;
  String? sku;
  String? ean;
  String? productID;
  String? brand;
  String? country;
  String? productType;
  String? unitOfMeasurement;
  String? manufacturerPartNumber;
  String? itemDescription;
  String? imageURL;
  List<Map>? categoryTags;
  String? itemID;
  String? uid;
  bool? isItemAvailable;

  ItemChangeNotifier({
    this.itemName,
    this.manufacturer,
    this.unit,
    this.sku,
    this.ean,
    this.productID,
    this.brand,
    this.country,
    this.productType,
    this.unitOfMeasurement,
    this.manufacturerPartNumber,
    this.itemDescription,
    this.imageURL,
    this.categoryTags,
    this.itemID,
    this.uid,
    this.isItemAvailable,
  });

  void update({
    String? itemName,
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
  }) {
    this.itemName = itemName ?? this.itemName;
    this.manufacturer = manufacturer ?? this.manufacturer;
    this.unit = unit ?? this.unit;
    this.sku = sku ?? this.sku;
    this.ean = ean ?? this.ean;
    this.productID = productID ?? this.productID;
    this.brand = brand ?? this.brand;
    this.country = country ?? this.country;
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

    notifyListeners();
  }

  ItemChangeNotifier.fromItem(Item item) {
    itemName = item.itemName;
    manufacturer = item.manufacturer;
    unit = item.unit;
    sku = item.sku;
    ean = item.ean;
    productID = item.productID;
    brand = item.brand;
    country = item.country;
    productType = item.productType;
    unitOfMeasurement = item.unitOfMeasurement;
    manufacturerPartNumber = item.manufacturerPartNumber;
    itemDescription = item.itemDescription;
    imageURL = item.imageURL;
    categoryTags = item.categoryTags;
    itemID = item.itemID;
    uid = item.uid;
    isItemAvailable = item.isItemAvailable;
  }
}

class CategoryIDNotifier extends StateNotifier<String?> {
  CategoryIDNotifier() : super(null);

  void setCategoryID(String? id) {
    state = id;
  }
}
