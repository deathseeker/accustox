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
  String? unit;
  String? sku;
  String? ean;
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
  String? size;
  String? color;
  String? length;
  String? width;
  String? height;

  Item(
      {this.itemName,
      this.manufacturer,
      this.unit,
      this.sku,
      this.ean,
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
      this.size,
      this.color,
      this.length,
      this.width,
      this.height});

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    var item = Item(
        itemName: data?['itemName'],
        manufacturer: data?['manufacturer'],
        unit: data?['unit'],
        sku: data?['sku'],
        ean: data?['ean'],
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
        size: data?['size'],
        color: data?['color'],
        length: data?['length'],
        width: data?['width'],
        height: data?['height']);

    return item;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'manufacturer': manufacturer,
      'unit': unit,
      'sku': sku,
      'ean': ean,
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
      'size': size,
      'color': color,
      'length': length,
      'width': width,
      'height': height
    };
  }

  factory Item.fromMap(Map data) {
    return Item(
        itemName: data['itemName'] ?? '',
        manufacturer: data['manufacturer'] ?? '',
        unit: data['unit'] ?? '',
        sku: data['sku'] ?? '',
        ean: data['ean'] ?? '',
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
        size: data['size'] ?? '',
        color: data['color'] ?? '',
        length: data['length'] ?? '',
        width: data['width'] ?? '',
        height: data['height'] ?? '');
  }

  Item.fromJson(Map<String, dynamic> json)
      : itemName = json['itemName'],
        manufacturer = json['manufacturer'],
        unit = json['unit'],
        sku = json['sku'],
        ean = json['ean'],
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

  Item copyWith(
      {String? itemName,
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
      String? height}) {
    return Item(
        itemName: itemName ?? this.itemName,
        manufacturer: manufacturer ?? this.manufacturer,
        unit: unit ?? this.unit,
        sku: sku ?? this.sku,
        ean: ean ?? this.ean,
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
        size: size ?? this.size,
        color: color ?? this.color,
        length: length ?? this.length,
        width: width ?? this.width,
        height: height ?? this.height);
  }

  void copyFromChangeNotifier(ItemChangeNotifier notifier) {
    itemName = notifier.itemName;
    manufacturer = notifier.manufacturer;
    unit = notifier.unit;
    sku = notifier.sku;
    ean = notifier.ean;
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
    size = notifier.size;
    color = notifier.color;
    length = notifier.length;
    width = notifier.width;
    height = notifier.height;
  }

  void update({
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
  }) {
    if (itemName != null) {
      this.itemName = itemName;
    }
    if (manufacturer != null) {
      this.manufacturer = manufacturer;
    }
    if (unit != null) {
      this.unit = unit;
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
    if (country != null) {
      this.country = country;
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

    // Notify listeners that the item has been updated
    notifyListeners();
  }

}

class ItemChangeNotifier with ChangeNotifier {
  String? itemName;
  String? manufacturer;
  String? unit;
  String? sku;
  String? ean;
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
  String? size;
  String? color;
  String? length;
  String? width;
  String? height;

  ItemChangeNotifier(
      {this.itemName,
      this.manufacturer,
      this.unit,
      this.sku,
      this.ean,
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
      this.size,
      this.color,
      this.length,
      this.width,
      this.height});

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
      String? height}) {
    this.itemName = itemName ?? this.itemName;
    this.manufacturer = manufacturer ?? this.manufacturer;
    this.unit = unit ?? this.unit;
    this.sku = sku ?? this.sku;
    this.ean = ean ?? this.ean;
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
    this.size = size ?? this.size;
    this.color = color ?? this.color;
    this.length = length ?? this.length;
    this.width = width ?? this.width;
    this.height = height ?? this.height;
    notifyListeners();
  }

  ItemChangeNotifier.fromItem(Item item) {
    itemName = item.itemName;
    manufacturer = item.manufacturer;
    unit = item.unit;
    sku = item.sku;
    ean = item.ean;
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
    size = item.size;
    color = item.color;
    length = item.length;
    width = item.width;
    height = item.height;
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
    Future<List<CategorySelectionData>> _list = data;
    return _list;
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
