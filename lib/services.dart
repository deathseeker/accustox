import 'package:accustox/edit_item.dart';
import 'package:accustox/enumerated_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'edit_supplier.dart';
import 'providers.dart';
import 'widget_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'color_scheme.dart';
import 'models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'controllers.dart';
import 'database.dart';
import 'login_splash.dart';
import 'main.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final DatabaseService _db = DatabaseService();
final ScaffoldMessengerState _scaffoldMessengerState =
    scaffoldKey.currentState!;
const Uuid uuid = Uuid();

class Services {
  static final Services _services = Services._privateConstructor();

  Services._privateConstructor();

  factory Services() {
    return _services;
  }

  Future<String> getInitialRoute() async {
    User? user = auth.currentUser;

    if (user != null) {
      bool userHasProfile = await _db.userCheck(user.uid);
      if (userHasProfile) {
        return '/';
      } else {
        return 'createProfile';
      }
    } else {
      return 'signIn';
    }
  }

  loginSplash() {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => const LoginSplash(), fullscreenDialog: true));
  }

  Future<bool> handleSignInWithGoogle() async {
    UserCredential userCredential = await signInWithGoogle();
    User user = userCredential.user!;
    bool userExists = await _db.userCheck(user.uid);
    return userExists;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  showSnackBarError(String errorMessage) {
    _scaffoldMessengerState.showSnackBar(SnackBar(
      backgroundColor: lightColorScheme.error,
      content: Text(
        errorMessage,
        style: TextStyle(color: lightColorScheme.onError),
      ),
    ));
  }

  showSnackBarErrorWithRetry(String errorMessage, VoidCallback retryOnError) {
    _scaffoldMessengerState.showSnackBar(SnackBar(
      backgroundColor: lightColorScheme.error,
      content: Text(
        errorMessage,
        style: TextStyle(color: lightColorScheme.onError),
      ),
      action: SnackBarAction(label: 'Retry?', onPressed: retryOnError),
    ));
  }

  showSnackBar(String message) {
    _scaffoldMessengerState.showSnackBar(SnackBar(
      content: Text(
        message,
      ),
    ));
  }

  hideCurrentSnackBar() {
    _scaffoldMessengerState.hideCurrentSnackBar();
  }

  showLoadingSnackBar(String message) {
    _scaffoldMessengerState.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16.0),
            Text(message),
          ],
        ),
        duration: const Duration(minutes: 1), // Adjust the duration as needed
      ),
    );
  }

  reviewAndSubmitProfile(
      {required GlobalKey<FormState> formKey,
      required String businessName,
      required String ownerName,
      required String email,
      required String contactNumber,
      required String address,
      required String uid}) {
    bool isValid = formKey.currentState!.validate();

    if (!isValid) {
      snackBarController.showSnackBarError('Please provide valid information.');
    } else {
      var userProfile = UserProfile(
          businessName: businessName,
          ownerName: ownerName,
          email: email,
          contactNumber: contactNumber,
          address: address,
          uid: uid);

      snackBarController.showSnackBar('Creating profile...');
      userController
          .createNewUser(uid: uid, userProfile: userProfile)
          .whenComplete(() async {
        bool userExists = await userController.checkNewUser();
        if (userExists) {
          navigationController.navigateToHome();
        } else {
          snackBarController.showSnackBarErrorWithRetry(
              'Something went wrong while creating your profile...',
              reviewAndSubmitProfile(
                  formKey: formKey,
                  businessName: businessName,
                  ownerName: ownerName,
                  email: email,
                  contactNumber: contactNumber,
                  address: address,
                  uid: uid));
        }
      });
    }
  }

  Future<bool> handleSystemBackButton() async {
    // Close the app if we're at the top of the navigation stack
    return !(navigatorKey.currentState?.canPop() ?? false);
  }

  popUntilHome() {
    return navigatorKey.currentState?.popUntil(ModalRoute.withName('home'));
  }

  navigateToPreviousPage() {
    return navigatorKey.currentState?.pop();
  }

  navigateToHome() {
    return navigatorKey.currentState?.pushReplacementNamed('home');
  }

  navigateToSignIn() {
    return navigatorKey.currentState?.pushReplacementNamed('signIn');
  }

  navigateToEditProfile() {
    return navigatorKey.currentState?.pushNamed('editProfile');
  }

  navigateToNewSupplier() {
    return navigatorKey.currentState?.pushNamed('newSupplier');
  }

  navigateToEditSupplier(Supplier supplier) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => EditSupplier(supplier: supplier)));
  }

  navigateToEditItem(Item item) {
    return navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => EditItem(item: item)));
  }

  navigateToNewCustomerAccount() {
    return navigatorKey.currentState?.pushNamed('newCustomerAccount');
  }

  navigateToNewItem() {
    return navigatorKey.currentState?.pushNamed('newItem');
  }

  bool hasProfileChanged(
      UserProfile originalProfile, UserProfileChangeNotifier notifier) {
    if (notifier.ownerName != originalProfile.ownerName ||
        notifier.businessName != originalProfile.businessName ||
        notifier.contactNumber != originalProfile.contactNumber ||
        notifier.address != originalProfile.address ||
        notifier.email != originalProfile.email ||
        notifier.uid != originalProfile.uid) {
      return true;
    }

    return false;
  }

  bool hasSupplierChanged(
      Supplier originalSupplier, SupplierChangeNotifier notifier) {
    if (notifier.supplierName != originalSupplier.supplierName ||
        notifier.contactPerson != originalSupplier.contactPerson ||
        notifier.contactNumber != originalSupplier.contactNumber ||
        notifier.address != originalSupplier.address ||
        notifier.email != originalSupplier.email ||
        notifier.supplierID != originalSupplier.supplierID) {
      return true;
    }

    return false;
  }

  reviewAndSubmitProfileUpdate(
      {required GlobalKey<FormState> formKey,
      required UserProfile originalProfile,
      required UserProfileChangeNotifier notifier}) {
    bool isValid = formKey.currentState!.validate();
    bool hasChanged = userController.hasProfileChanged(
        originalProfile: originalProfile, notifier: notifier);

    if (!isValid) {
      snackBarController.showSnackBarError('Please provide valid information.');
    } else if (!hasChanged) {
      snackBarController
          .showSnackBar('You have made no changes to your profile...');
    } else {
      var userProfile = UserProfile(
          businessName: notifier.businessName!,
          ownerName: notifier.ownerName!,
          email: notifier.email!,
          contactNumber: notifier.contactNumber!,
          address: notifier.address!,
          uid: notifier.uid!);

      snackBarController.showSnackBar('Updating profile...');
      userController.updateProfile(userProfile: userProfile).whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        navigateToPreviousPage();
      }).onError((error, stackTrace) => snackBarController.showSnackBarError(
          'Something went wrong with the process, try again later...'));
    }
  }

  addNewSalespersonDialog(BuildContext context, String uid) {
    final TextEditingController nameController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Salesperson'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: nameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Name'),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the salesperson's name";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {
                        var isValid = formKey.currentState!.validate();

                        !isValid
                            ? null
                            : dialogController.processAddSalesperson(
                                uid: uid,
                                salesperson: Salesperson(
                                    salespersonName: nameController.text));
                      },
                      child: const Text('Confirm'))
                ],
              )
            ],
          );
        });
  }

  removeSalespersonDialog(
      BuildContext context, String uid, Salesperson salesperson) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Remove Salesperson'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to remove ${salesperson.salespersonName} from your list of salespersons?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () =>
                          dialogController.processRemoveSalesperson(
                              uid: uid, salesperson: salesperson),
                      child: const Text('Confirm'))
                ],
              )
            ],
          );
        });
  }

  processAddSalesperson(String uid, Salesperson salesperson) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(
        message: 'Adding new salesperson...');
    userController
        .addSalesperson(uid: uid, salesperson: salesperson)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('New salesperson successfully added...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  processRemoveSalesperson(String uid, Salesperson salesperson) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(
        message:
            'Removing ${salesperson.salespersonName} from list of salespersons...');
    userController
        .removeSalesperson(uid: uid, salesperson: salesperson)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('Process successful...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  addNewCategoryDialog(BuildContext context, String uid) {
    final TextEditingController categoryNameController =
        TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Category'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: categoryNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Category'),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter category";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {
                        var isValid = formKey.currentState!.validate();
                        var categoryID = categoryController.getCategoryID();
                        !isValid
                            ? null
                            : dialogController.processAddCategory(
                                uid: uid,
                                category: Category(
                                    categoryName: categoryNameController.text,
                                    categoryID: categoryID,
                                    uid: uid));
                      },
                      child: const Text('Confirm'))
                ],
              )
            ],
          );
        });
  }

  processAddCategory(String uid, Category category) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(message: 'Adding new category...');
    categoryController
        .addCategory(uid: uid, category: category)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('New category successfully added...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  removeCategoryDialog(BuildContext context, String uid, Category category) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Remove Category'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to remove ${category.categoryName} from your list of categories?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => dialogController.processRemoveCategory(
                          uid: uid, category: category),
                      child: const Text('Confirm'))
                ],
              )
            ],
          );
        });
  }

  processRemoveCategory(String uid, Category category) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(
        message:
            'Removing ${category.categoryName} from list of categories...');
    categoryController
        .removeCategory(uid: uid, category: category)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('Process successful...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  String getCategoryID() {
    String id = uuid.v4();
    return id;
  }

  String getItemID() {
    String id = uuid.v4();
    return id;
  }

  String getLocationID() {
    String id = uuid.v4();
    return id;
  }

  String getSupplierID() {
    String id = uuid.v4();
    return id;
  }

  String getCustomerID() {
    String id = uuid.v4();
    return id;
  }

  addStockLocationDialog(BuildContext context, String uid) {
    final TextEditingController locationNameController =
        TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Location'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LocationTypeDropDownMenu(),
                      const Padding(padding: EdgeInsets.only(top: 8.0)),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: locationNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Stock Location Name'),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter stock location's name";
                          }
                          return null;
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8.0)),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: descriptionController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Location Description (Optional)'),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  Consumer(builder: (context, ref, child) {
                    var type = ref.watch(inventoryLocationTypeProvider);
                    return FilledButton(
                        onPressed: () {
                          var isValid = formKey.currentState!.validate();
                          var locationID =
                              stockLocationController.getLocationID();

                          !isValid
                              ? null
                              : dialogController.processAddParentLocation(
                                  uid: uid,
                                  stockLocation: StockLocation(
                                      locationID: locationID,
                                      locationName: locationNameController.text,
                                      description: descriptionController.text,
                                      type: type.label,
                                      parentLocationID: 'Parent',
                                      locationAddress:
                                          locationNameController.text));
                        },
                        child: const Text('Confirm'));
                  })
                ],
              )
            ],
          );
        });
  }

  processAddParentLocation(String uid, StockLocation stockLocation) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(message: 'Adding new location...');
    stockLocationController
        .addParentLocation(uid: uid, stockLocation: stockLocation)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('New location successfully added...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  removeLocationDialog(
      BuildContext context, String uid, StockLocation stockLocation) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Remove Location'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to remove ${stockLocation.locationName} from your list of locations?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => dialogController.processRemoveLocation(
                          uid: uid, stockLocation: stockLocation),
                      child: const Text('Confirm'))
                ],
              )
            ],
          );
        });
  }

  processRemoveLocation(String uid, StockLocation stockLocation) {
    navigationController.navigateToPreviousPage();
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(
        message:
            'Removing ${stockLocation.locationName} from list of locations...');
    stockLocationController
        .removeParentLocation(uid: uid, stockLocation: stockLocation)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('Process successful...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  addStockSubLocationDialog(
      BuildContext context, String uid, StockLocation parentLocation) {
    final TextEditingController locationNameController =
        TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Location'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LocationTypeDropDownMenu(),
                      const Padding(padding: EdgeInsets.only(top: 8.0)),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: locationNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Stock Location Name'),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter stock location's name";
                          }
                          return null;
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8.0)),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: descriptionController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Location Description (Optional)'),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  Consumer(builder: (context, ref, child) {
                    var type = ref.watch(inventoryLocationTypeProvider);
                    return FilledButton(
                        onPressed: () {
                          var isValid = formKey.currentState!.validate();
                          var locationID =
                              stockLocationController.getLocationID();

                          !isValid
                              ? null
                              : dialogController.processAddSubLocation(
                                  uid: uid,
                                  parentLocation: parentLocation,
                                  subLocation: StockLocation(
                                      locationID: locationID,
                                      locationName: locationNameController.text,
                                      description: descriptionController.text,
                                      type: type.label,
                                      parentLocationID:
                                          parentLocation.locationID,
                                      locationAddress:
                                          '${locationNameController.text}, ${parentLocation.locationAddress}'));
                        },
                        child: const Text('Confirm'));
                  })
                ],
              )
            ],
          );
        });
  }

  processAddSubLocation(
      String uid, StockLocation parentLocation, StockLocation subLocation) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(message: 'Adding new location...');
    stockLocationController
        .addSubLocation(
            uid: uid, parentLocation: parentLocation, subLocation: subLocation)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('New location successfully added...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  reviewAndSubmitSupplierProfile(
      {required GlobalKey<FormState> formKey,
      required String supplierName,
      required String contactPerson,
      required String email,
      required String contactNumber,
      required String address,
      required String uid}) {
    bool isValid = formKey.currentState!.validate();
    var supplierID = supplierController.getSupplierID();

    if (!isValid) {
      snackBarController.showSnackBarError('Please provide valid information.');
    } else {
      var supplier = Supplier(
          supplierName: supplierName,
          contactNumber: contactNumber,
          contactPerson: contactPerson,
          email: email,
          address: address,
          supplierID: supplierID);

      snackBarController.showLoadingSnackBar(
          message: 'Creating supplier profile...');
      supplierController
          .addSupplier(uid: uid, supplier: supplier)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar('New supplier successfully added...');
        navigationController.navigateToPreviousPage();
      }).onError((error, stackTrace) => snackBarController.showSnackBarError(
              'Something went wrong while creating supplier profile...'));
    }
  }

  removeSupplierDialog(BuildContext context, String uid, Supplier supplier) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Remove Supplier'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to remove ${supplier.supplierName} from your list of suppliers?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => dialogController.processRemoveSupplier(
                          uid: uid, supplier: supplier),
                      child: const Text('Confirm'))
                ],
              )
            ],
          );
        });
  }

  processRemoveSupplier(String uid, Supplier supplier) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(
        message: 'Removing ${supplier.supplierName} from list of suppliers...');
    supplierController
        .removeSupplier(uid: uid, supplier: supplier)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('Process successful...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  reviewAndSubmitSupplierUpdate(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Supplier originalSupplier,
      required SupplierChangeNotifier notifier}) {
    bool isValid = formKey.currentState!.validate();
    bool hasChanged = supplierController.hasSupplierChanged(
        originalSupplier: originalSupplier, notifier: notifier);

    if (!isValid) {
      snackBarController.showSnackBarError('Please provide valid information.');
    } else if (!hasChanged) {
      snackBarController
          .showSnackBar('You have made no changes to the supplier profile...');
    } else {
      var newSupplier = Supplier(
          supplierName: notifier.supplierName!,
          contactNumber: notifier.contactNumber!,
          contactPerson: notifier.contactPerson!,
          email: notifier.email!,
          address: notifier.address!,
          supplierID: notifier.supplierID!);

      snackBarController.showSnackBar('Updating profile...');
      supplierController
          .editSupplier(
              uid: uid, oldSupplier: originalSupplier, newSupplier: newSupplier)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar('Supplier successfully updated...');
        navigateToPreviousPage();
      }).onError((error, stackTrace) => snackBarController.showSnackBarError(
              'Something went wrong with the process, try again later...'));
    }
  }

  reviewAndSubmitCustomerProfile(
      {required GlobalKey<FormState> formKey,
      required String customerName,
      required String contactPerson,
      required String email,
      required String contactNumber,
      required String address,
      required String customerType,
      required String uid}) {
    bool isValid = formKey.currentState!.validate();
    var customerID = customerController.getCustomerID();

    if (!isValid) {
      snackBarController.showSnackBarError('Please provide valid information.');
    } else {
      var customer = Customer(
          customerID: customerID,
          customerName: customerName,
          customerType: customerType,
          contactPerson: contactPerson,
          contactNumber: contactNumber,
          email: email,
          address: address);

      snackBarController.showLoadingSnackBar(
          message: 'Creating customer profile...');
      customerController
          .addCustomer(uid: uid, customer: customer)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar('New customer successfully added...');
        navigationController.navigateToPreviousPage();
      }).onError((error, stackTrace) => snackBarController.showSnackBarError(
              'Something went wrong while creating supplier profile...'));
    }
  }

  Future<String> scanBarcode() async {
    String barcodeData = await FlutterBarcodeScanner.scanBarcode(
        '#FFB7211D', 'Cancel', false, ScanMode.BARCODE);

    return barcodeData;
  }

  Future<String> scanQRCode() async {
    String qrCodeData = await FlutterBarcodeScanner.scanBarcode(
        '#FFB7211D', 'Cancel', false, ScanMode.QR);

    return qrCodeData;
  }

  String nameImage(String uid) {
    String strUuid = uuid.v4();
    String fileName = '${uid}_$strUuid';
    return fileName;
  }

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
  }) async {
    final ImageDataController imageDataController = ImageDataController();

    bool isValid = formKey.currentState!.validate();
    if (imageFile.file == null) {
      snackBarController
          .showSnackBarError("Please add the item image to continue");
    } else if (stockLocation == null) {
      snackBarController
          .showSnackBarError("Please add the stock location to continue");
    } else if (supplier == null) {
      snackBarController
          .showSnackBarError("Please add the supplier to continue");
    } else if (isValid == false) {
      snackBarController
          .showSnackBarError("Kindly review the item information");
    } else {
      snackBarController.showLoadingSnackBar(message: "Adding new item...");

      var uploadTask = await imageDataController.uploadItemImage(
          image: imageFile.file!,
          uid: uid,
          path: 'Users/$uid/Images/Items',
          imageStorageUploadData: imageStorageUploadData);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            snackBarController.hideCurrentSnackBar();
            snackBarController.showLoadingSnackBar(
                message: "Image upload is $progress% complete...");

            break;
          case TaskState.paused:
            snackBarController.showSnackBar("Upload is paused...");
            break;
          case TaskState.canceled:
            snackBarController.showSnackBar("Upload is canceled...");
            break;
          case TaskState.error:
            snackBarController
                .showSnackBarError("Something went wrong with the upload...");
            break;
          case TaskState.success:
            String url = await taskSnapshot.ref.getDownloadURL();
            imageStorageUploadData.newImageUrl = url;
            debugPrint('UploadURL: ${imageStorageUploadData.imageUrl}');
            snackBarController.showSnackBar("Upload is successful...");
            var imageURL = imageStorageUploadData.imageUrl;
            debugPrint(imageURL);

            item.update(imageURL: imageURL);
            var stockID = itemController.getItemID();
            var stockLevel = double.tryParse(openingStock);

            var costPriceDouble = double.tryParse(costPrice);
            var salePriceDouble = double.tryParse(salePrice);
            var expirationWarningDouble = double.tryParse(expirationWarning);
            var beginningInventory = costPriceDouble! * stockLevel!;
            var currentInventory = beginningInventory;
            var averageDailyDemandDouble = double.tryParse(averageDailyDemand);
            var maximumDailyDemandDouble = double.tryParse(maximumDailyDemand);
            var averageLeadTimeDouble = double.tryParse(averageLeadTime);
            var maximumLeadTimeDouble = double.tryParse(maximumLeadTime);
            var safetyStockLevel =
                (maximumLeadTimeDouble! * maximumDailyDemandDouble!) -
                    (averageDailyDemandDouble! * averageLeadTimeDouble!);
            var reorderPoint =
                (averageLeadTimeDouble * averageDailyDemandDouble) +
                    safetyStockLevel;

            Stock stock = Stock(
                item: item.toFirestore(),
                supplier: supplier.toFirestore(),
                stockLevel: stockLevel,
                stockLocation: stockLocation.toFirestore(),
                expirationDate: expirationDate,
                batchNumber: batchNumber,
                costPrice: costPriceDouble,
                salePrice: salePriceDouble,
                purchaseDate: purchaseDate,
                inventoryCreatedOn: DateTime.now(),
                expirationWarning: expirationWarningDouble,
                stockID: stockID);

            Inventory inventory = Inventory(
                item: item.toFirestore(),
                beginningInventory: beginningInventory,
                maximumDailyDemand: maximumDailyDemandDouble,
                maximumLeadTime: maximumLeadTimeDouble,
                averageDailyDemand: averageDailyDemandDouble,
                averageLeadTime: averageLeadTimeDouble,
                currentInventory: currentInventory,
                backOrder: 0,
                stockLevel: stockLevel,
                safetyStockLevel: safetyStockLevel,
                reorderPoint: reorderPoint);

            itemController
                .addItem(
                    uid: uid, item: item, stock: stock, inventory: inventory)
                .whenComplete(() {
              snackBarController.hideCurrentSnackBar();
              snackBarController.showSnackBar("Item successfully added...");

              ref
                  .read(asyncCategorySelectionDataProvider.notifier)
                  .resetState();
              ref.read(categorySelectionProvider.notifier).resetState();

              navigationController.navigateToPreviousPage();
            });
            break;
        }
      });
    }
  }

  reviewAndSubmitItemUpdate(
      {required GlobalKey<FormState> formKey,
      required WidgetRef ref,
      required ItemChangeNotifier itemChangeNotifier,
      required Item oldItem,
      required ImageFile imageFile,
      required uid,
      required ImageStorageUploadData imageStorageUploadData}) async {
    bool isValid = formKey.currentState!.validate();
    List<Map>? categoryTags =
        ref.read(categorySelectionProvider).map((e) => e.toMap()).toList();
    itemChangeNotifier.update(categoryTags: categoryTags);

    if (isValid) {
      if (imageFile.file != null) {
        await processItemUpdateWithImageUpload(imageFile, uid,
            imageStorageUploadData, itemChangeNotifier, oldItem, ref);
      } else {
        var hasItemChanged = checkIfItemChanged(oldItem, itemChangeNotifier);

        hasItemChanged
            ? await processItemUpdate(itemChangeNotifier, uid, oldItem, ref)
            : snackBarController
                .showSnackBarError("You have made no changes to the Item...");
        // Process item data only
        // code to process item data only
      }
    } else {
      snackBarController.showSnackBar("Kindly review the item information");
    }
  }

  processItemUpdateWithImageUpload(
      ImageFile imageFile,
      String uid,
      ImageStorageUploadData imageStorageUploadData,
      ItemChangeNotifier itemChangeNotifier,
      Item oldItem,
      WidgetRef ref) async {
    final ImageDataController imageDataController = ImageDataController();

    snackBarController.showLoadingSnackBar(message: "Updating item...");

    var uploadTask = await imageDataController.uploadItemImage(
        image: imageFile.file!,
        uid: uid,
        path: 'Users/$uid/Images/Item',
        imageStorageUploadData: imageStorageUploadData);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          snackBarController
              .showSnackBar("Image upload is $progress% complete...");
          break;
        case TaskState.paused:
          snackBarController.showSnackBar("Upload is paused...");
          break;
        case TaskState.canceled:
          snackBarController.showSnackBar("Upload is canceled...");
          break;
        case TaskState.error:
          snackBarController
              .showSnackBarError("Something went wrong with the upload...");

          break;
        case TaskState.success:
          String url = await taskSnapshot.ref.getDownloadURL();
          imageStorageUploadData.newImageUrl = url;
          debugPrint('UploadURL: ${imageStorageUploadData.imageUrl}');
          snackBarController.showSnackBar("Upload is successful...");
          var imageURL = imageStorageUploadData.imageUrl;
          itemChangeNotifier.update(imageURL: imageURL);
          debugPrint(imageURL);

          Item newItem = Item();

          newItem.copyFromChangeNotifier(itemChangeNotifier);

          itemController
              .updateItem(uid: uid, oldItem: oldItem, newItem: newItem)
              .whenComplete(() {
            snackBarController.showSnackBar("Item successfully updated...");

            ref.read(asyncCategorySelectionDataProvider.notifier).resetState();
            ref.read(categorySelectionProvider.notifier).resetState();

            navigationController.navigateToPreviousPage();
          });
          break;
      }
    });
  }

  processItemUpdate(ItemChangeNotifier itemChangeNotifier, String uid,
      Item oldItem, WidgetRef ref) async {
    snackBarController.showSnackBar("Updating item...");

    Item newItem = Item();

    newItem.copyFromChangeNotifier(itemChangeNotifier);

    itemController
        .updateItem(uid: uid, oldItem: oldItem, newItem: newItem)
        .whenComplete(() {
      ref.read(asyncCategorySelectionDataProvider.notifier).resetState();
      ref.read(categorySelectionProvider.notifier).resetState();
      snackBarController.showSnackBar("Item successfully updated...");
      navigationController.navigateToPreviousPage();
    });
  }

  bool checkIfItemChanged(Item originalItem, ItemChangeNotifier notifier) {
    if (notifier.itemName != originalItem.itemName ||
        notifier.manufacturer != originalItem.manufacturer ||
        notifier.manufacturerPartNumber !=
            originalItem.manufacturerPartNumber ||
        notifier.productType != originalItem.productType ||
        notifier.unitOfMeasurement != originalItem.unitOfMeasurement ||
        notifier.size != originalItem.size ||
        notifier.brand != originalItem.brand ||
        notifier.color != originalItem.color ||
        notifier.sku != originalItem.sku ||
        notifier.ean != originalItem.ean ||
        notifier.length != originalItem.length ||
        notifier.width != originalItem.width ||
        notifier.height != originalItem.height ||
        notifier.itemDescription != originalItem.itemDescription ||
        notifier.imageURL != originalItem.imageURL) {
      return true;
    }

    bool compareListMap(
        List<Map<dynamic, dynamic>> list1, List<Map<dynamic, dynamic>> list2) {
      var listEquality = const DeepCollectionEquality();

      return listEquality.equals(list1, list2);
    }

    if (notifier.categoryTags?.length != originalItem.categoryTags?.length ||
        !compareListMap(
            notifier.categoryTags ?? [], originalItem.categoryTags ?? [])) {
      debugPrint(
          'categoryTags changed from ${originalItem.categoryTags} to ${notifier.categoryTags}');
      debugPrint("Category tags changed");
      return true;
    }

    return false;
  }

  getStockLevelState(num stockLevel, num safetyStockLevel, num reorderPoint) {
    if (stockLevel > reorderPoint) {
      return StockLevelState.inStock;
    } else if (stockLevel <= reorderPoint && stockLevel > safetyStockLevel) {
      return StockLevelState.reorder;
    } else if (stockLevel <= safetyStockLevel && stockLevel > 0) {
      return StockLevelState.lowStock;
    } else {
      return StockLevelState.outOfStock;
    }
  }

  DateTime timestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  Future<DateTime?> selectDate(BuildContext context, DateTime initialDate,
      DateTime firstDate, DateTime lastDate) {
    return showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);
  }

  bool enableExpirationDateInput(Perishability perishability) {
    bool enable;
    switch (perishability) {
      case Perishability.durableGoods:
        enable = false;
        break;
      case Perishability.nonPerishableGoods:
        enable = true;
        break;
      case Perishability.perishableGoods:
        enable = true;
        break;
    }
    return enable;
  }

  String pluralize(String noun, num count) {
    if (count == 1) {
      return noun; // Singular form
    } else {
      // Basic pluralization rule: Add "s" to the noun
      return "${noun}s"; // Plural form
    }
  }
}
