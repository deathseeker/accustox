import 'dart:io';
import 'dart:ui';
import 'color_scheme.dart';
import 'controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'models.dart';
import 'services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class DatabaseService {
  static final DatabaseService _db = DatabaseService._privateConstructor();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final Services _services = Services();
  final ImagePicker imagePicker = ImagePicker();
  final ImageCropper imageCropper = ImageCropper();

  DatabaseService._privateConstructor();

  factory DatabaseService() {
    return _db;
  }

  Future<bool> userCheck(String uid) async {
    DocumentSnapshot snap = await _firestore.collection('Users').doc(uid).get();
    return (snap.exists == true);
  }

  Future<void> createNewUser(String uid, UserProfile userProfile) async {
    final DocumentReference merchantRef =
        _firestore.collection('Users').doc(uid);
    final DocumentReference categoriesRef =
        merchantRef.collection('InventoryData').doc('Categories');
    final DocumentReference itemsRef =
        merchantRef.collection('InventoryData').doc('Items');
    final DocumentReference salespersonRef =
        merchantRef.collection('BusinessData').doc('Salespersons');
    final DocumentReference locationsRef =
        merchantRef.collection('InventoryData').doc('Locations');
    final DocumentReference suppliersRef =
        merchantRef.collection('InventoryData').doc('Suppliers');
    final DocumentReference customersRef =
        merchantRef.collection('BusinessData').doc('Customers');
    final DocumentReference purchaseOrderNumberRef =
        merchantRef.collection('BusinessData').doc('PurchaseOrderNumber');
    final DocumentReference salesOrderNumberRef =
        merchantRef.collection('BusinessData').doc('SalesOrderNumber');

    await _firestore.runTransaction((transaction) async {
      transaction.set(merchantRef, userProfile.toFirestore());
      transaction.set(categoriesRef, {'categoryList': []});
      transaction.set(itemsRef, {'itemList': []});
      transaction.set(salespersonRef, {'salespersonList': []});
      transaction.set(locationsRef, {'stockLocationList': []});
      transaction.set(suppliersRef, {'suppliersList': []});
      transaction.set(customersRef, {'customerList': []});
      transaction.set(purchaseOrderNumberRef, {'purchaseOrderNumber': 0});
      transaction.set(salesOrderNumberRef, {'salesOrderNumber': 0});
    });
  }

  Future<bool> checkNewUser() async {
    User user = _auth.currentUser!;
    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(user.uid).get();

    bool docExists = userDoc.exists;

    return docExists;
  }

  Future<void> updateProfile(UserProfile userProfile) async {
    User user = _auth.currentUser!;
    final DocumentReference documentReference =
        _firestore.collection('Users').doc(user.uid);

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, userProfile.toFirestore());
    });
  }

  Stream<User?> streamAuthStateChanges() {
    return _auth.authStateChanges();
  }

  Stream<UserProfile> streamUserProfile(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .snapshots()
        .map((doc) => UserProfile.fromFirestore(doc));
  }

  Future<void> addSalesperson(String uid, Salesperson salesperson) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('BusinessData')
        .doc('Salespersons');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'salespersonList': FieldValue.arrayUnion([salesperson.toFirestore()])
      });
    });
  }

  Future<void> removeSalesperson(String uid, Salesperson salesperson) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('BusinessData')
        .doc('Salespersons');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'salespersonList': FieldValue.arrayRemove([salesperson.toFirestore()]),
      });
    });
  }

  Stream<SalespersonDocument> streamSalespersonDocument(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('BusinessData')
        .doc('Salespersons')
        .snapshots()
        .map((doc) => SalespersonDocument.fromFirestore(doc));
  }

  Stream<List<Salesperson>> streamSalespersonList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('BusinessData')
        .doc('Salespersons')
        .snapshots()
        .map((doc) => SalespersonDocument.fromFirestore(doc))
        .map((salespersonDocument) => salespersonDocument.salespersonList!
            .map((e) => Salesperson.fromMap(e))
            .toList());
  }

  Future<void> addCategory(String uid, Category category) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'categoryList': FieldValue.arrayUnion([category.toFirestore()])
      });
    });
  }

  Future<void> addSupplier(String uid, Supplier supplier) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Suppliers');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'supplierList': FieldValue.arrayUnion([supplier.toFirestore()])
      });
    });
  }

  Future<void> removeSupplier(String uid, Supplier supplier) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Suppliers');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'supplierList': FieldValue.arrayRemove([supplier.toFirestore()])
      });
    });
  }

  Future<void> editSupplier(
      String uid, Supplier oldSupplier, Supplier newSupplier) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Suppliers');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'supplierList': FieldValue.arrayRemove([oldSupplier.toFirestore()]),
      });
      transaction.update(documentReference, {
        'supplierList': FieldValue.arrayUnion([newSupplier.toFirestore()])
      });
    });
  }

  Future<void> editCategory(
      String uid, Category oldCategory, Category newCategory) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'categoryList': FieldValue.arrayRemove([oldCategory.toFirestore()]),
      });
      transaction.update(documentReference, {
        'categoryList': FieldValue.arrayUnion([newCategory.toFirestore()])
      });
    });
  }

  Future<void> removeCategory(String uid, Category category) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'categoryList': FieldValue.arrayRemove([category.toFirestore()]),
      });
    });
  }

  Stream<CategoryDocument> streamCategoryDocument(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories')
        .snapshots()
        .map((doc) => CategoryDocument.fromFirestore(doc));
  }

  Stream<List<CategorySelectionData>> streamCategorySelectionDataList(
      String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories')
        .snapshots()
        .map((doc) => CategoryDocument.fromFirestore(doc))
        .map((categoryDocument) => categoryDocument.categoryList!
            .map((e) => CategorySelectionData.fromMap(e))
            .toList());
  }

  Stream<List<Category>> streamCategoryDataList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories')
        .snapshots()
        .map((doc) => CategoryDocument.fromFirestore(doc))
        .map((categoryDocument) => categoryDocument.categoryList!
            .map((e) => Category.fromMap(e))
            .toList());
  }

  Future<List<CategorySelectionData>> getCategoryListWithSelection(
      String uid) async {
    var snapshot = await _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories')
        .get();

    var data = CategoryDocument.fromFirestore(snapshot);

    return data.categoryList!
        .map((e) => CategorySelectionData.fromMap(e))
        .toList();
  }

  Future<List<Category>> getCategoryList(String uid) async {
    var snapshot = await _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories')
        .get();

    var data = CategoryDocument.fromFirestore(snapshot);

    return data.categoryList!.map((e) => Category.fromMap(e)).toList();
  }

  Future<List<CategoryFilter>> getCategoryFilterList(String uid) async {
    var snapshot = await _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories')
        .get();

    var data = CategoryDocument.fromFirestore(snapshot);

    return data.categoryList!
        .map((e) => CategoryFilter().fromCategory(Category.fromMap(e)))
        .toList();
  }

  Stream<List<CategoryFilter>> getCategoryFilterListStream(String uid) async* {
    var snapshots = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories')
        .snapshots();

    await for (var snapshot in snapshots) {
      var data = CategoryDocument.fromFirestore(snapshot);

      yield data.categoryList!
          .map((e) => CategoryFilter().fromCategory(Category.fromMap(e)))
          .toList();
    }
  }

  Future<void> removeItemFromCategory(
      String uid, String categoryID, Item item) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items');

    await _firestore.runTransaction((transaction) async {
      var doc = await documentReference.get();

      var itemDocument = ItemDocument.fromFirestore(doc);
      var itemList = itemDocument.itemList ?? [];
      var items = itemList.map((e) => Item.fromMap(e)).toList();
      var itemIndex =
          itemList.indexWhere((element) => element['itemID'] == item.itemID);
      var oldItemReference = items[itemIndex];
      var oldItemCategoryTags = oldItemReference.categoryTags;
      oldItemCategoryTags
          ?.removeWhere((element) => element['categoryID'] == categoryID);
      var newItemCategoryTags = oldItemCategoryTags;

      Item newItem = item.copyWith(categoryTags: newItemCategoryTags);

      transaction.update(documentReference, {
        'itemList': FieldValue.arrayRemove([item.toFirestore()]),
      });
      transaction.update(documentReference, {
        'itemList': FieldValue.arrayUnion([newItem.toFirestore()])
      });
    });
  }

  Future<List<Category?>> getCategoryListForItem(
      String uid, String itemID) async {
    final itemDoc = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items');
    final itemData = await itemDoc.get();
    final itemList = itemData['itemList'] as List<dynamic>;

    final categoryIDs = itemList
        .where((item) => item['itemID'] == itemID)
        .expand((item) => item['categoryTags'] as List<dynamic>)
        .map((tag) => tag['categoryID'] as String)
        .toSet();

    final categoryDoc = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Categories');
    final categoryData = await categoryDoc.get();
    final categoryList = categoryData['categoryList'] as List<dynamic>;

    final categoryMap = {
      for (final category in categoryList)
        if (categoryIDs.contains(category['categoryID']))
          category['categoryID'] as String: Category.fromMap(category),
    };

    final categories = categoryIDs
        .map((categoryID) => categoryMap[categoryID])
        .where((category) => category != null)
        .toList();

    return categories;
  }

  Future<void> addInventoryStock(String uid, String itemID, Stock stock,
      Inventory inventory, double newLeadTime) async {
    DocumentReference inventoryReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(itemID);

    DocumentReference stockReference =
        inventoryReference.collection('Stocks').doc(stock.stockID);

    var inventoryTransactionID = itemController.getItemID();

    InventoryTransaction inventoryTransaction = InventoryTransaction(
        inventoryTransactionID: inventoryTransactionID,
        transactionType: 'Added Stock',
        quantityChange: stock.stockLevel!,
        transactionMadeOn: DateTime.now(),
        reason: '--',
        stock: stock.toFirestore());

    DocumentReference inventoryTransactionReference =
        inventoryReference.collection('History').doc(inventoryTransactionID);

    Map<String, dynamic> data =
        statisticsController.getInventoryStatisticsOnStockAdd(
            inventory: inventory,
            newLeadTime: newLeadTime,
            stockLevel: stock.stockLevel!,
            costPrice: stock.costPrice!);

    await _firestore.runTransaction((transaction) async {
      transaction.set(stockReference, stock.toFirestore());
      transaction.update(inventoryReference, data);
      transaction.set(
          inventoryTransactionReference, inventoryTransaction.toFirestore());
    });
  }

  Future<void> addItem(
      String uid, Item item, Stock stock, Inventory inventory) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items');

    DocumentReference inventoryReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(item.itemID);

    DocumentReference stockReference =
        inventoryReference.collection('Stocks').doc(stock.stockID);

    var inventoryTransactionID = itemController.getItemID();

    DocumentReference inventoryHistoryReference =
        inventoryReference.collection('History').doc(inventoryTransactionID);

    InventoryTransaction inventoryTransaction = InventoryTransaction(
        inventoryTransactionID: inventoryTransactionID,
        transactionType: 'Added New Item',
        quantityChange: stock.stockLevel!,
        transactionMadeOn: DateTime.now(),
        reason: '--',
        stock: stock.toFirestore());

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'itemList': FieldValue.arrayUnion([item.toFirestore()])
      });

      transaction.set(inventoryReference, inventory.toFirestore());

      transaction.set(stockReference, stock.toFirestore());

      transaction.set(
          inventoryHistoryReference, inventoryTransaction.toFirestore());
    });
  }

  Future<void> updateItem(String uid, Item oldItem, Item newItem) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'itemList': FieldValue.arrayRemove([oldItem.toFirestore()])
      });

      transaction.update(documentReference, {
        'itemList': FieldValue.arrayUnion([newItem.toFirestore()])
      });
    });
  }

  Future<void> removeItem(String uid, Item item) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'itemList': FieldValue.arrayRemove([item.toFirestore()])
      });
    });
  }

  Future<void> updateItemAvailability(
      String uid, Item item, bool isItemAvailable) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items');

    var updatedItem = item.copyWith(isItemAvailable: isItemAvailable);

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'itemList': FieldValue.arrayRemove([item.toFirestore()])
      });
      transaction.update(documentReference, {
        'itemList': FieldValue.arrayUnion([updatedItem.toFirestore()])
      });
    });
  }

  Stream<List<Item>> streamItemDataList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items')
        .snapshots()
        .map((doc) => ItemDocument.fromFirestore(doc))
        .map((itemDocument) =>
            itemDocument.itemList!.map((e) => Item.fromMap(e)).toList());
  }

  Stream<List<Stock>> streamStockList(String uid, String itemID) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(itemID)
        .collection('Stocks')
        .orderBy('inventoryCreatedOn', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Stock.fromFirestore(doc)).toList());
  }

  Stream<List<Item>> getFilteredItemsStreamByCategory(
      String uid, String categoryID) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items')
        .snapshots()
        .map((doc) => ItemDocument.fromFirestore(doc))
        .map((itemDocument) => itemDocument.itemList ?? [])
        .map((itemList) {
      try {
        return itemList
            .map((e) => Item.fromMap(e))
            .where((item) =>
                item.categoryTags != null &&
                (item.categoryTags as List<Map<dynamic, dynamic>>)
                    .any((category) => category['categoryID'] == categoryID))
            .toList();
      } catch (e) {
        return <Item>[];
      }
    });
  }

  Future<void> addParentLocation(
      String uid, StockLocation stockLocation) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Locations');

    DocumentReference stockLocationReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Locations')
        .doc(stockLocation.locationID);

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'stockLocationList':
            FieldValue.arrayUnion([stockLocation.toFirestore()])
      });

      transaction.set(stockLocationReference, stockLocation.toFirestore());
    });
  }

  Future<void> removeParentLocation(
      String uid, StockLocation stockLocation) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Locations');

    DocumentReference stockLocationReference =
        _firestore.doc(stockLocation.documentPath!);

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'stockLocationList':
            FieldValue.arrayRemove([stockLocation.toFirestore()])
      });

      transaction.delete(stockLocationReference);
    });
  }

  Stream<List<StockLocation>> streamParentLocationDataList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Locations')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StockLocation.fromFirestore(doc))
            .toList());
  }

  Stream<List<StockLocation>> streamSubLocationDataList(String path) {
    return _firestore.doc(path).collection('SubLocations').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => StockLocation.fromFirestore(doc))
            .toList());
  }

  Future<void> addSubLocation(String uid, StockLocation parentLocation,
      StockLocation subLocation) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Locations');

    DocumentReference stockLocationReference = _firestore
        .doc(parentLocation.documentPath!)
        .collection('SubLocations')
        .doc(subLocation.locationID);

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'stockLocationList': FieldValue.arrayUnion([subLocation.toFirestore()])
      });

      transaction.set(stockLocationReference, subLocation.toFirestore());
    });
  }

  Stream<List<Supplier>> streamSupplierDataList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Suppliers')
        .snapshots()
        .map((doc) => SupplierDocument.fromFirestore(doc))
        .map((supplierDocument) => supplierDocument.supplierList!
            .map((e) => Supplier.fromMap(e))
            .toList());
  }

  Stream<List<Customer>> streamCustomerDataList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('BusinessData')
        .doc('Customers')
        .snapshots()
        .map((doc) => CustomerDocument.fromFirestore(doc))
        .map((customerDocument) => customerDocument.customerList!
            .map((e) => Customer.fromMap(e))
            .toList());
  }

  Future<void> addCustomer(String uid, Customer customer) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('BusinessData')
        .doc('Customers');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'customerList': FieldValue.arrayUnion([customer.toFirestore()])
      });
    });
  }

  Future<File> getImage(
      {required bool isSourceCamera, required bool isCropStyleCircle}) async {
    XFile? xFile = await imagePicker.pickImage(
        source: isSourceCamera ? ImageSource.camera : ImageSource.gallery);
    CroppedFile? croppedFile = await cropImage(xFile!, isCropStyleCircle);
    File file = File(croppedFile.path);
    return file;
  }

  Future<void> uploadImage(
      File image,
      String uid,
      String path,
      ImageStorageUploadData imageStorageUploadData,
      VoidCallback retryOnError) async {
    final Reference storageRef = _firebaseStorage.ref();
    String fileName = _services.nameImage(uid);

    Reference pathRef = storageRef.child('$path/$fileName');

    UploadTask uploadTask = pathRef.putFile(image);

    uploadTask.snapshotEvents.listen((
      TaskSnapshot taskSnapshot,
    ) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          snackBarController
              .showSnackBar("Image upload is $progress% complete.");
          break;
        case TaskState.paused:
          snackBarController.showSnackBar("Upload is paused.");
          break;
        case TaskState.canceled:
          snackBarController.showSnackBar("Upload is canceled.");
          break;
        case TaskState.error:
          snackBarController.showSnackBarErrorWithRetry(
              "Something went wrong with the upload. Retry?", retryOnError);
          break;
        case TaskState.success:
          String url = await taskSnapshot.ref.getDownloadURL();
          imageStorageUploadData.newImageUrl = url;
          snackBarController.showSnackBar("Upload is successful.");
          break;
      }
    });
  }

  Future<UploadTask> uploadCategoryImage(File image, String uid, String path,
      ImageStorageUploadData imageStorageUploadData) async {
    final Reference storageRef = _firebaseStorage.ref();
    String fileName = _services.nameImage(uid);

    Reference pathRef = storageRef.child('$path/$fileName');

    UploadTask uploadTask = pathRef.putFile(image);
    return uploadTask;
  }

  Future<UploadTask> uploadItemImage(File image, String uid, String path,
      ImageStorageUploadData imageStorageUploadData) async {
    final Reference storageRef = _firebaseStorage.ref();
    String fileName = _services.nameImage(uid);

    Reference pathRef = storageRef.child('$path/$fileName');

    UploadTask uploadTask = pathRef.putFile(image);
    return uploadTask;
  }

  Future<CroppedFile> cropImage(XFile xFile, isCropStyleCircle) async {
    CroppedFile? croppedFile = await imageCropper.cropImage(
        sourcePath: xFile.path,
        maxWidth: 300,
        maxHeight: 300,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 100,
        cropStyle: isCropStyleCircle ? CropStyle.circle : CropStyle.rectangle,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: lightColorScheme.surface,
            toolbarWidgetColor: lightColorScheme.onSurface,
            backgroundColor: lightColorScheme.background,
            activeControlsWidgetColor: lightColorScheme.primary,
          )
        ]);
    return croppedFile!;
  }

  Stream<List<Item>> streamCurrentItemList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  }

  Stream<InventorySummary> streamInventorySummary(String uid, String itemID) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(itemID)
        .collection('Data')
        .doc('InventorySummary')
        .snapshots()
        .map((doc) => InventorySummary.fromFirestore(doc));
  }

  Stream<Inventory> streamInventory(String uid, String itemID) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(itemID)
        .snapshots()
        .map((doc) => Inventory.fromFirestore(doc));
  }

  Stream<List<PurchaseOrder>> streamIncomingInventoryList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('PurchaseOrders')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PurchaseOrder.fromFirestore(doc))
            .toList());
  }

  Stream<List<Inventory>> streamInventoryList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Inventory.fromFirestore(doc)).toList());
  }

  Stream<List<StockLocation>> streamLocationDataList(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Locations')
        .snapshots()
        .map((doc) => StockLocationDocument.fromFirestore(doc))
        .map((stockLocationDocument) => stockLocationDocument.stockLocationList!
            .map((e) => StockLocation.fromMap(e))
            .toList());
  }

  Future<void> updateInventoryStatisticsOnStockAdd(
      String uid,
      String itemID,
      Inventory inventory,
      double newLeadTime,
      double stockLevel,
      double costPrice) async {
    var oldMaximumLeadTime = inventory.maximumLeadTime;
    var oldAverageLeadTime = inventory.averageLeadTime;
    var maximumDailyDemand = inventory.maximumLeadTime;
    var averageDailyDemand = inventory.averageDailyDemand;

    double? maximumLeadTime = statisticsController.getMaximumLeadTime(
        oldMaximumLeadTime: oldMaximumLeadTime!, newLeadTime: newLeadTime);
    double? averageLeadTime = statisticsController.getAverageLeadTime(
        oldAverageLeadTime: oldAverageLeadTime!, newLeadTime: newLeadTime);
    double? newInventory = statisticsController.getInventoryValue(
        stockLevel: stockLevel, costPrice: costPrice);
    double? newStockLevel = stockLevel;
    double? safetyStockLevel = statisticsController.getSafetyStockLevel(
        maximumLeadTime: maximumLeadTime,
        maximumDailyDemand: maximumDailyDemand!,
        averageDailyDemand: averageDailyDemand!,
        averageLeadTime: averageLeadTime);
    double? reorderPoint = statisticsController.getReorderPoint(
        averageLeadTime: averageLeadTime,
        averageDailyDemand: averageDailyDemand,
        safetyStockLevel: safetyStockLevel);

    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(itemID);

    Map<String, dynamic> data = {
      'maximumLeadTime': maximumLeadTime,
      'averageLeadTime': averageLeadTime,
      'currentInventory': FieldValue.increment(newInventory),
      'stockLevel': FieldValue.increment(newStockLevel),
      'safetyStockLevel': safetyStockLevel,
      'reorderPoint': reorderPoint,
    };

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, data);
    });
  }

  Future<void> moveInventoryStock(
      String uid, Stock currentStock, Stock movedStock) async {
    DocumentReference currentStockReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(currentStock.item?['itemID'])
        .collection('Stocks')
        .doc(currentStock.stockID);

    DocumentReference movedStockReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(currentStock.item?['itemID'])
        .collection('Stocks')
        .doc(movedStock.stockID);

    var currentStockTransactionID = itemController.getItemID();
    var movedStockTransactionID = itemController.getItemID();

    InventoryTransaction currentStockTransaction = InventoryTransaction(
        inventoryTransactionID: currentStockTransactionID,
        transactionType: 'Inventory Adjusted',
        quantityChange: -movedStock.stockLevel!,
        transactionMadeOn: DateTime.now(),
        reason:
            'Moved Stock From ${currentStock.stockLocation?['locationAddress']} To ${movedStock.stockLocation?['locationAddress']}',
        stock: currentStock.toMap());

    InventoryTransaction movedStockTransaction = InventoryTransaction(
        inventoryTransactionID: movedStockTransactionID,
        transactionType: 'Inventory Moved',
        quantityChange: movedStock.stockLevel!,
        transactionMadeOn: DateTime.now(),
        reason: 'Stock From ${currentStock.stockLocation?['locationAddress']}',
        stock: movedStock.toMap());

    InventoryTransaction removedStockTransaction = InventoryTransaction(
        inventoryTransactionID: currentStockTransactionID,
        transactionType: 'Inventory Removed',
        quantityChange: -movedStock.stockLevel!,
        transactionMadeOn: DateTime.now(),
        reason:
            'Moved Stock From ${currentStock.stockLocation?['locationAddress']} To ${movedStock.stockLocation?['locationAddress']}',
        stock: currentStock.toMap());

    DocumentReference currentStockTransactionReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(currentStock.item?['itemID'])
        .collection('History')
        .doc(currentStockTransactionID);

    DocumentReference movedStockTransactionReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(currentStock.item?['itemID'])
        .collection('History')
        .doc(movedStockTransactionID);

    if (currentStock.stockLevel == movedStock.stockLevel) {
      await _firestore.runTransaction((transaction) async {
        transaction.set(movedStockReference, movedStock.toFirestore());
        transaction.delete(currentStockReference);
        transaction.set(movedStockTransactionReference,
            movedStockTransaction.toFirestore());
        transaction.set(currentStockTransactionReference,
            removedStockTransaction.toFirestore());
      });
    } else {
      var stockLevel = currentStock.stockLevel! - movedStock.stockLevel!;
      await _firestore.runTransaction((transaction) async {
        transaction.set(movedStockReference, movedStock.toFirestore());
        transaction.update(currentStockReference, {'stockLevel': stockLevel});
        transaction.set(currentStockTransactionReference,
            currentStockTransaction.toFirestore());
        transaction.set(movedStockTransactionReference,
            movedStockTransaction.toFirestore());
      });
    }
  }

  Stream<List<InventoryTransaction>> streamInventoryTransactionList(
      String uid, Inventory inventory) {
    Item item = Item.fromMap(inventory.item!);

    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(item.itemID)
        .collection('History')
        .orderBy('transactionMadeOn', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryTransaction.fromFirestore(doc))
            .toList());
  }

  Future<void> inventoryStockLevelAdjustment(
      String uid, Stock stock, double adjustedStockLevel, String reason) async {
    DocumentReference inventoryReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(stock.item?['itemID']);

    DocumentReference stockReference =
        inventoryReference.collection('Stocks').doc(stock.stockID);

    var transactionID = itemController.getItemID();

    DocumentReference transactionReference =
        inventoryReference.collection('History').doc(transactionID);

    var currentStockValue = stock.stockLevel! * stock.costPrice!;
    var adjustedStockValue = adjustedStockLevel * stock.costPrice!;
    var adjustedInventoryValue = adjustedStockValue - currentStockValue;
    var stockLevelIncrement = adjustedStockLevel - stock.stockLevel!;

    InventoryTransaction inventoryTransaction = InventoryTransaction(
        inventoryTransactionID: transactionID,
        transactionType: 'Stock Level Adjustment',
        quantityChange: stockLevelIncrement,
        transactionMadeOn: DateTime.now(),
        reason: reason,
        stock: stock.toFirestore());

    if (adjustedStockLevel == 0) {
      await _firestore.runTransaction((transaction) async {
        transaction.delete(stockReference);
        transaction.update(inventoryReference, {
          'stockLevel': FieldValue.increment(stockLevelIncrement),
          'currentInventory': FieldValue.increment(adjustedInventoryValue)
        });
        transaction.set(
            transactionReference, inventoryTransaction.toFirestore());
      });
    } else {
      await _firestore.runTransaction((transaction) async {
        transaction.update(stockReference, {'stockLevel': adjustedStockLevel});
        transaction.update(inventoryReference, {
          'stockLevel': FieldValue.increment(stockLevelIncrement),
          'currentInventory': FieldValue.increment(adjustedInventoryValue)
        });
        transaction.set(
            transactionReference, inventoryTransaction.toFirestore());
      });
    }
  }

  Future<void> costPriceAdjustment(
      String uid, Stock stock, double adjustedCostPrice, String reason) async {
    DocumentReference inventoryReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(stock.item?['itemID']);

    DocumentReference stockReference =
        inventoryReference.collection('Stocks').doc(stock.stockID);

    var transactionID = itemController.getItemID();

    DocumentReference transactionReference =
        inventoryReference.collection('History').doc(transactionID);

    var currentStockValue = stock.stockLevel! * stock.costPrice!;
    var adjustedStockValue = stock.stockLevel! * adjustedCostPrice;
    var adjustedInventoryValue = adjustedStockValue - currentStockValue;

    InventoryTransaction inventoryTransaction = InventoryTransaction(
        inventoryTransactionID: transactionID,
        transactionType: 'Cost Price Adjustment',
        quantityChange: 0,
        transactionMadeOn: DateTime.now(),
        reason: reason,
        stock: stock.toFirestore());

    await _firestore.runTransaction((transaction) async {
      transaction.update(stockReference, {'costPrice': adjustedCostPrice});
      transaction.update(inventoryReference,
          {'currentInventory': FieldValue.increment(adjustedInventoryValue)});
      transaction.set(transactionReference, inventoryTransaction.toFirestore());
    });
  }

  Future<void> salePriceAdjustment(
      String uid, Stock stock, double adjustedSalePrice, String reason) async {
    DocumentReference inventoryReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .doc(stock.item?['itemID']);

    DocumentReference stockReference =
        inventoryReference.collection('Stocks').doc(stock.stockID);

    var transactionID = itemController.getItemID();

    DocumentReference transactionReference =
        inventoryReference.collection('History').doc(transactionID);

    InventoryTransaction inventoryTransaction = InventoryTransaction(
        inventoryTransactionID: transactionID,
        transactionType: 'Sale Price Adjustment',
        quantityChange: 0,
        transactionMadeOn: DateTime.now(),
        reason: reason,
        stock: stock.toFirestore());

    await _firestore.runTransaction((transaction) async {
      transaction.update(stockReference, {'salePrice': adjustedSalePrice});
      transaction.set(transactionReference, inventoryTransaction.toFirestore());
    });
  }

  Future<void> addPurchaseOrder(String uid, PurchaseOrder purchaseOrder) async {
    DocumentReference purchaseOrderReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('PurchaseOrders')
        .doc(purchaseOrder.purchaseOrderID);

    DocumentReference purchaseOrderIDReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('BusinessData')
        .doc('PurchaseOrderNumber');

    await _firestore.runTransaction((transaction) async {
      var purchaseOrderIDDoc = await transaction.get(purchaseOrderIDReference);

      int purchaseOrderNumber =
          purchaseOrderIDDoc.get('purchaseOrderNumber') + 1;

      String purchaseOrderNumberToFirestore = purchaseOrderController
          .createPurchaseOrderNumber(a: purchaseOrderNumber);

      purchaseOrder.update(purchaseOrderNumber: purchaseOrderNumberToFirestore);

      transaction.update(purchaseOrderIDReference,
          {'purchaseOrderNumber': FieldValue.increment(1)});

      transaction.set(purchaseOrderReference, purchaseOrder.toFirestore());
    });
  }

  Stream<PurchaseOrder> streamPurchaseOrder(
      String uid, String purchaseOrderID) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('PurchaseOrders')
        .doc(purchaseOrderID)
        .snapshots()
        .map((doc) => PurchaseOrder.fromFirestore(doc));
  }

  Future<void> updateOrderPlacedStatus(
      String uid, PurchaseOrder purchaseOrder, bool orderPlaced) async {
    DocumentReference purchaseOrderReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('PurchaseOrders')
        .doc(purchaseOrder.purchaseOrderID);

    await _firestore.runTransaction((transaction) async {
      transaction.update(purchaseOrderReference, {'orderPlaced': orderPlaced});
    });
  }

  Future<void> updateOrderConfirmedStatus(
      String uid, PurchaseOrder purchaseOrder, bool orderConfirmed) async {
    DocumentReference purchaseOrderReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('PurchaseOrders')
        .doc(purchaseOrder.purchaseOrderID);

    await _firestore.runTransaction((transaction) async {
      transaction
          .update(purchaseOrderReference, {'orderConfirmed': orderConfirmed});
    });
  }
}
