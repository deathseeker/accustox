import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'models.dart';
import 'services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class DatabaseService {
  static final DatabaseService _db = DatabaseService._privateConstructor();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final Services _services = Services();

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

    await _firestore.runTransaction((transaction) async {
      transaction.set(merchantRef, userProfile.toFirestore());
      transaction.set(categoriesRef, {'categoryList': []});
      transaction.set(itemsRef, {'itemList': []});
      transaction.set(salespersonRef, {'salespersonList': []});
    });
    return _firestore
        .collection('Users')
        .doc(uid)
        .set(userProfile.toFirestore());
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

  Future<void> addItem(String uid, Item item) async {
    DocumentReference documentReference = _firestore
        .collection('Users')
        .doc(uid)
        .collection('InventoryData')
        .doc('Items');

    await _firestore.runTransaction((transaction) async {
      transaction.update(documentReference, {
        'itemList': FieldValue.arrayUnion([item.toFirestore()])
      });
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
}
