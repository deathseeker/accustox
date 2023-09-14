import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final String salespersonName;

  Salesperson(this.salespersonName);
}

class ItemCardData {
  final String itemName;
  final String sku;
  final String imageURL;

  ItemCardData(this.itemName, this.sku, this.imageURL);
}
