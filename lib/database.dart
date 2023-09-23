import 'dart:io';
import 'dart:ui';
import 'package:accustox/color_scheme.dart';
import 'package:accustox/controllers.dart';
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

    await _firestore.runTransaction((transaction) async {
      transaction.set(merchantRef, userProfile.toFirestore());
      transaction.set(categoriesRef, {'categoryList': []});
      transaction.set(itemsRef, {'itemList': []});
      transaction.set(salespersonRef, {'salespersonList': []});
      transaction.set(locationsRef, {'stockLocationList': []});
      transaction.set(suppliersRef, {'suppliersList': []});
      transaction.set(customersRef, {'customerList': []});
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

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'itemList': FieldValue.arrayUnion([item.toFirestore()])
      });

      transaction.set(inventoryReference, inventory.toFirestore());

      transaction.set(stockReference, stock.toFirestore());
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
      } catch (e, st) {
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
    final bytes = file.readAsBytesSync().lengthInBytes;
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

  Stream<List<Inventory>> streamInventory(String uid) {
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
}
