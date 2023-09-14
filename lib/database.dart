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

    await _firestore.runTransaction((transaction) async {
      transaction.set(merchantRef, userProfile.toFirestore());
      transaction.set(categoriesRef, {'categoryList': []});
      transaction.set(itemsRef, {'itemList': []});
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
}
