import 'dart:async';

import 'package:accustox/customer_account_details.dart';
import 'package:accustox/incoming_inventory_management.dart';
import 'package:accustox/new_inventory_stock_from_purchase_order.dart';
import 'package:accustox/sales_order_details.dart';
import 'package:accustox/sales_report_details.dart';
import 'package:audioplayers/audioplayers.dart';

import 'current_inventory_details.dart';
import 'default_values.dart';
import 'edit_item.dart';
import 'edit_purchase_order.dart';
import 'enumerated_values.dart';
import 'move_inventory.dart';
import 'new_adjustment.dart';
import 'new_inventory_stock.dart';
import 'purchase_order_details.dart';
import 'text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
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
import 'package:stream_transform/stream_transform.dart';

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

  navigateToNewPurchaseOrder() {
    return navigatorKey.currentState?.pushNamed('newPurchaseOrder');
  }

  navigateToAddItemToPurchaseOrder() {
    return navigatorKey.currentState?.pushNamed('addItemToPurchaseOrder');
  }

  navigateToCurrentInventoryDetails(CurrentInventoryData currentInventoryData) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => CurrentInventoryDetails(
            currentInventoryData: currentInventoryData)));
  }

  navigateToAddInventory(Inventory inventory) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => NewInventoryStock(inventory: inventory)));
  }

  navigateToMoveInventory(Stock stock) {
    return navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => MoveInventory(stock: stock)));
  }

  navigateToAdjustInventory(Stock stock) {
    return navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => NewAdjustment(stock: stock)));
  }

  navigateToPurchaseOrderDetails(PurchaseOrder purchaseOrder) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) =>
            PurchaseOrderDetails(purchaseOrder: purchaseOrder)));
  }

  navigateToEditPurchaseOrder(PurchaseOrder purchaseOrder) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => EditPurchaseOrder(purchaseOrder)));
  }

  navigateToIncomingInventoryManagement(PurchaseOrder purchaseOrder) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) =>
            IncomingInventoryManagement(purchaseOrder: purchaseOrder)));
  }

  navigateToNewInventoryStockFromPurchaseOrder(
      PurchaseOrderItem purchaseOrderItem, PurchaseOrder purchaseOrder) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => NewInventoryStockFromPurchaseOrder(
              purchaseOrderItem: purchaseOrderItem,
              purchaseOrder: purchaseOrder,
            )));
  }

  navigateToCustomerAccountDetails(Customer customer) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => CustomerAccountDetails(customer: customer)));
  }

  navigateToSalesOrderDetails(String salesOrderID) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => SalesOrderDetails(salesOrderID: salesOrderID)));
  }

  navigateToSalesReportDetails(String dateInYYYYMMDD) {
    return navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => SalesReportDetails(date: dateInYYYYMMDD)));
  }

  navigateToProcessSalesOrder() {
    return navigatorKey.currentState?.pushNamed('processSalesOrder');
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

  addPurchaseItemOrderDialog(BuildContext context, Item item, WidgetRef ref) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController estimatedPriceController =
        TextEditingController();
    final formKey = GlobalKey<FormState>();
    final itemOrderNotifier =
        ref.read(purchaseOrderCartNotifierProvider.notifier);

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Item Order'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          '${item.sku} - ${item.itemName}',
                          style: customTextStyle.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: quantityController,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText:
                                    'Quantity (in ${item.unitOfMeasurement}s)'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter the estimated unit price...";
                              } else if (double.tryParse(value)! <= 0) {
                                return 'Please enter a positive number greater than zero...';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: estimatedPriceController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Estimated Price/Unit (in Php)'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter the estimated unit price...";
                              } else if (double.tryParse(value)! <= 0) {
                                return 'Please enter a positive number greater than zero...';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        ButtonBar(
                          children: [
                            TextButton(
                                onPressed: () => navigationController
                                    .navigateToPreviousPage(),
                                child: const Text('Cancel')),
                            FilledButton(
                                onPressed: () {
                                  var isValid =
                                      formKey.currentState!.validate();

                                  if (isValid) {
                                    var quantity = double.tryParse(
                                        quantityController.text);
                                    var estimatedPrice = double.tryParse(
                                        estimatedPriceController.text);
                                    PurchaseOrderItem purchaseOrderItem =
                                        PurchaseOrderItem.fromItem(item,
                                            quantity: quantity!,
                                            estimatedPrice: estimatedPrice!,
                                            addedToInventory: false);

                                    snackBarController.showLoadingSnackBar(
                                        message:
                                            'Adding item to purchase order...');

                                    itemOrderNotifier
                                        .addItem(purchaseOrderItem);

                                    snackBarController.hideCurrentSnackBar();

                                    snackBarController.showSnackBar(
                                        'Item successfully added...');

                                    navigationController
                                        .navigateToPreviousPage();

                                    navigationController
                                        .navigateToPreviousPage();
                                  } else {
                                    null;
                                  }
                                },
                                child: const Text('Add'))
                          ],
                        )
                      ],
                    )),
              )
            ],
          );
        });
  }

  editPurchaseItemOrderDialog(BuildContext context,
      PurchaseOrderItem purchaseOrderItem, WidgetRef ref) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController estimatedPriceController =
        TextEditingController();
    final formKey = GlobalKey<FormState>();
    final itemOrderNotifier =
        ref.read(purchaseOrderCartNotifierProvider.notifier);

    quantityController.text = purchaseOrderItem.quantity.toString();
    estimatedPriceController.text = purchaseOrderItem.estimatedPrice.toString();

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Edit Item Order'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          '${purchaseOrderItem.sku} - ${purchaseOrderItem.itemName}',
                          style: customTextStyle.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: quantityController,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText:
                                    'Quantity (in ${purchaseOrderItem.unitOfMeasurement}s)'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter item quantity...";
                              } else if (double.tryParse(value)! <= 0) {
                                return 'Please enter a positive number greater than zero...';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: estimatedPriceController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Estimated Price/Unit (in Php)'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter the estimated unit price...";
                              } else if (double.tryParse(value)! <= 0) {
                                return 'Please enter a positive number greater than zero...';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        ButtonBar(
                          children: [
                            TextButton(
                                onPressed: () => navigationController
                                    .navigateToPreviousPage(),
                                child: const Text('Cancel')),
                            FilledButton(
                                onPressed: () {
                                  var isValid =
                                      formKey.currentState!.validate();

                                  if (isValid) {
                                    var updatedQuantity = double.tryParse(
                                        quantityController.text);
                                    var updatedEstimatedPrice = double.tryParse(
                                        estimatedPriceController.text);
                                    var updatedPurchaseOrderItem =
                                        purchaseOrderItem;

                                    updatedPurchaseOrderItem =
                                        purchaseOrderItem.copyWith(
                                            quantity: updatedQuantity,
                                            estimatedPrice:
                                                updatedEstimatedPrice);

                                    debugPrint(
                                        updatedPurchaseOrderItem.itemID!);
                                    debugPrint(updatedPurchaseOrderItem.quantity
                                        .toString());

                                    itemOrderNotifier
                                        .addItem(updatedPurchaseOrderItem);

                                    snackBarController.showSnackBar(
                                        'Item Order successfully changed...');

                                    navigationController
                                        .navigateToPreviousPage();
                                  } else {
                                    null;
                                  }
                                },
                                child: const Text('Edit'))
                          ],
                        )
                      ],
                    )),
              )
            ],
          );
        });
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

  addCustomItemOrderDialog(
      BuildContext context, WidgetRef ref, RetailItem retailItem) {
    final TextEditingController quantityController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final Item item = Item.fromMap(retailItem.item!);
    final stockLimit = retailItem.retailStockLevel;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Custom Item Order'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          '${item.sku} - ${item.itemName}',
                          style: customTextStyle.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: quantityController,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText:
                                    'Quantity (in ${item.unitOfMeasurement}s)'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter item quantity...";
                              } else if (double.tryParse(value)! <= 0) {
                                return 'Please enter a positive number greater than zero...';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        ButtonBar(
                          children: [
                            TextButton(
                                onPressed: () => navigationController
                                    .navigateToPreviousPage(),
                                child: const Text('Cancel')),
                            FilledButton(
                                onPressed: () {
                                  var isValid =
                                      formKey.currentState!.validate();
                                  var quantity =
                                      double.tryParse(quantityController.text);

                                  if (isValid) {
                                    navigationController
                                        .navigateToPreviousPage();
                                    salesOrderController
                                        .addCustomSalesOrderItem(
                                            ref: ref,
                                            retailItem: retailItem,
                                            stockLimit: stockLimit!,
                                            quantity: quantity!);
                                  } else {
                                    null;
                                  }
                                },
                                child: const Text('Confirm'))
                          ],
                        )
                      ],
                    )),
              )
            ],
          );
        });
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

  processSetAsRetailStock(String uid, String itemID, Stock stock) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(
        message: 'Setting stock as available for retail sale...');
    inventoryController
        .addStockToRetailStock(uid: uid, itemID: itemID, stock: stock)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('Process successful...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  processRemoveFromRetailStock(String uid, String itemID, Stock stock) {
    navigationController.navigateToPreviousPage();
    snackBarController.showLoadingSnackBar(
        message: 'Setting stock as unavailable for retail sale...');
    inventoryController
        .removeStockFromRetailStock(uid: uid, itemID: itemID, stock: stock)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('Process successful...');
    }).onError((error, stackTrace) => snackBarController
            .showSnackBarError('Something went wrong. Try again later...'));
  }

  setAsRetailStockDialog(
      BuildContext context, String uid, String itemID, Stock stock) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Set As Retail Stock'),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Do you want set this stock as available for retail sale?',
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
                      onPressed: () => dialogController.processSetAsRetailStock(
                          uid: uid, itemID: itemID, stock: stock),
                      child: const Text('Confirm'))
                ],
              )
            ],
          );
        });
  }

  removeFromRetailStockDialog(
      BuildContext context, String uid, String itemID, Stock stock) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Remove From Retail Stock'),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Do you want remove this stock from availability for retail sale?',
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
                          dialogController.processRemoveFromRetailStock(
                              uid: uid, itemID: itemID, stock: stock),
                      child: const Text('Confirm'))
                ],
              )
            ],
          );
        });
  }

  placeOrderDialog(BuildContext context, String uid,
      PurchaseOrder purchaseOrder, bool orderPlaced) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Place Order'),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Have you placed this order with the supplier?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('No')),
                  FilledButton(
                      onPressed: () => purchaseOrderController
                              .updateOrderPlacedStatus(
                                  uid: uid,
                                  purchaseOrder: purchaseOrder,
                                  orderPlaced: orderPlaced)
                              .whenComplete(() {
                            navigationController.navigateToPreviousPage();
                            snackBarController
                                .showSnackBar('Status successfully updated...');
                          }),
                      child: const Text('Yes'))
                ],
              )
            ],
          );
        });
  }

  cancelOrderPlacementDialog(BuildContext context, String uid,
      PurchaseOrder purchaseOrder, bool orderPlaced) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Cancel Order Placement'),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to cancel the confirmation of order placement with the supplier?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('No')),
                  FilledButton(
                      onPressed: () {
                        if (orderPlaced) {
                          purchaseOrderController
                              .updateOrderPlacedStatus(
                                  uid: uid,
                                  purchaseOrder: purchaseOrder,
                                  orderPlaced: orderPlaced)
                              .whenComplete(() {
                            navigationController.navigateToPreviousPage();
                            snackBarController
                                .showSnackBar('Status successfully updated...');
                          });
                        } else {
                          purchaseOrderController.updateOrderConfirmedStatus(
                              uid: uid,
                              purchaseOrder: purchaseOrder,
                              orderConfirmed: false);
                          purchaseOrderController
                              .updateOrderPlacedStatus(
                                  uid: uid,
                                  purchaseOrder: purchaseOrder,
                                  orderPlaced: orderPlaced)
                              .whenComplete(() {
                            navigationController.navigateToPreviousPage();
                            snackBarController
                                .showSnackBar('Status successfully updated...');
                          });
                        }
                      },
                      child: const Text('Yes'))
                ],
              )
            ],
          );
        });
  }

  orderConfirmationDialog(BuildContext context, String uid,
      PurchaseOrder purchaseOrder, bool orderConfirmed) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Confirm Order'),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to confirm order acceptance by the supplier?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('No')),
                  FilledButton(
                      onPressed: () => purchaseOrderController
                              .updateOrderConfirmedStatus(
                                  uid: uid,
                                  purchaseOrder: purchaseOrder,
                                  orderConfirmed: orderConfirmed)
                              .whenComplete(() {
                            navigationController.navigateToPreviousPage();
                            snackBarController
                                .showSnackBar('Status successfully updated...');
                          }),
                      child: const Text('Yes'))
                ],
              )
            ],
          );
        });
  }

  cancelOrderConfirmationDialog(BuildContext context, String uid,
      PurchaseOrder purchaseOrder, bool orderConfirmed) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Cancel Order Confirmation'),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to cancel order confirmation by the supplier?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('No')),
                  FilledButton(
                      onPressed: () => purchaseOrderController
                              .updateOrderConfirmedStatus(
                                  uid: uid,
                                  purchaseOrder: purchaseOrder,
                                  orderConfirmed: orderConfirmed)
                              .whenComplete(() {
                            navigationController.navigateToPreviousPage();
                            snackBarController
                                .showSnackBar('Status successfully updated...');
                          }),
                      child: const Text('Yes'))
                ],
              )
            ],
          );
        });
  }

  cancelPurchaseOrderDialog(
      BuildContext context, String uid, PurchaseOrder purchaseOrder) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController reasonController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Void Purchase Order'),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to void this purchase order?',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: reasonController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Reason (Required)'),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a reason for the cancellation";
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
                      child: const Text('No')),
                  FilledButton(
                      onPressed: () {
                        bool isValid = formKey.currentState!.validate();
                        if (isValid) {
                          snackBarController.showLoadingSnackBar(
                              message: 'Voiding your purchase order...');
                          navigateToPreviousPage();
                          navigateToPreviousPage();
                          purchaseOrderController
                              .cancelPurchaseOrder(
                                  uid: uid,
                                  purchaseOrder: purchaseOrder,
                                  reason: reasonController.text)
                              .whenComplete(() {
                            snackBarController.hideCurrentSnackBar();
                            snackBarController.showSnackBar(
                                'Purchase order successfully voided...');
                          });
                        } else {
                          null;
                        }
                      },
                      child: const Text('Yes'))
                ],
              )
            ],
          );
        });
  }

  receivePurchaseOrderDialog(
      BuildContext context, String uid, PurchaseOrder purchaseOrder) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Receive Order'),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Do you want to confirm receipt of order from the supplier?',
                  textAlign: TextAlign.center,
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('No')),
                  FilledButton(
                      onPressed: () => purchaseOrderController
                              .receivePurchaseOrder(
                            uid: uid,
                            purchaseOrder: purchaseOrder,
                          )
                              .whenComplete(() {
                            navigationController.navigateToPreviousPage();
                            navigationController.navigateToPreviousPage();
                            snackBarController
                                .showSnackBar('Order received...');
                          }),
                      child: const Text('Yes'))
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

  Future<void> streamBarcodes(WidgetRef ref) async {
    Map<String, DateTime> barcodeMap = {};
    final player = AudioPlayer();
    var futureRetailItemList = ref.watch(streamRetailItemListProvider.future);
    var retailItemList = await futureRetailItemList;
    StreamSubscription subscription;

    Future<RetailItem?> getRetailItem(String barcode) async {
      var item = retailItemList.firstWhereOrNull(
          (retailItem) => Item.fromMap(retailItem.item!).ean == barcode);

      return item;
    }

    Future<void> checkAndAddBarcode(String barcode) async {
      DateTime currentTimestamp = DateTime.now();

      if (barcodeMap.containsKey(barcode)) {
        DateTime previousTimestamp = barcodeMap[barcode]!;
        Duration interval = currentTimestamp.difference(previousTimestamp);
        if (interval.inSeconds < 3) {
          return;
        }
      }

      var retailItem = await getRetailItem(barcode);

      if (retailItem != null) {
        barcodeMap[barcode] = currentTimestamp;
        await player.play(AssetSource('Barcode-scanner-beep-sound.mp3'));
        await addSalesOrderItemViaScan(ref, retailItem);
      }
    }

    var stream = FlutterBarcodeScanner.getBarcodeStreamReceiver(
      '#ff6666',
      'Done',
      true,
      ScanMode.BARCODE,
    );

    subscription = stream!
        .throttle(
            const Duration(
              milliseconds: 500,
            ),
            trailing: false)
        .listen((barcode) async {});

    subscription.onData((barcode) async {
      if (barcode == '-1') {
        subscription.cancel();
      } else {
        await checkAndAddBarcode(barcode);
      }
    });
  }

/*  Future<void> streamBarcodes(WidgetRef ref) async {
    Map<String, DateTime> barcodeMap = {};
    final player = AudioPlayer();
    var futureRetailItemList = ref.watch(streamRetailItemListProvider.future);
    var retailItemList = await futureRetailItemList;
    RetailItem? currentItem = null;

    Future<RetailItem?> getRetailItem(String barcode) async {
      var item = retailItemList.firstWhereOrNull(
          (retailItem) => Item.fromMap(retailItem.item!).ean == barcode);

      return item;
    }

    void checkAndAddBarcode(String barcode) async {
      DateTime currentTimestamp = DateTime.now();

      if (!barcodeMap.containsKey(barcode)) {
        var retailItem = await getRetailItem(barcode);

        if (retailItem != null) {
          barcodeMap[barcode] = DateTime.now();
          currentItem = retailItem;
          await player.play(AssetSource('Barcode-scanner-beep-sound.mp3'));
          await addSalesOrderItemViaScan(ref, retailItem);

        }
      } else {
        DateTime previousTimestamp = barcodeMap[barcode]!;
        Duration interval = currentTimestamp.difference(previousTimestamp);
        var retailItem = currentItem;

        if (retailItem != null && interval.inSeconds >= 3) {
          barcodeMap[barcode] = DateTime.now();
          print('Interval: ${interval.inSeconds}');
          await player.play(AssetSource('Barcode-scanner-beep-sound.mp3'));
          await addSalesOrderItemViaScan(ref, retailItem);

        }
      }
    }

    FlutterBarcodeScanner.getBarcodeStreamReceiver(
      '#ff6666',
      'Done',
      true,
      ScanMode.BARCODE,
    )!
        .listen((barcode) {
      print('Barcode passed: $barcode');
      checkAndAddBarcode(barcode);
    });
  }*/

  String nameImage(String uid) {
    String strUuid = uuid.v4();
    String fileName = '${uid}_$strUuid';
    return fileName;
  }

  reviewAndAdjustStockLevel(GlobalKey<FormState> formKey, String uid,
      Stock stock, String adjustedStockLevel, String reason) {
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      var adjustedStockLevelDouble = double.tryParse(adjustedStockLevel);

      snackBarController.showLoadingSnackBar(message: "Adjusting stock...");

      inventoryController
          .inventoryStockLevelAdjustment(
              uid: uid,
              stock: stock,
              adjustedStockLevel: adjustedStockLevelDouble!,
              reason: reason)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar("Stock successfully adjusted...");

        navigationController.navigateToPreviousPage();
      });
    } else {
      snackBarController
          .showSnackBarError('Kindly review the adjustment information...');
    }
  }

  reviewAndAdjustCostPrice(GlobalKey<FormState> formKey, String uid,
      Stock stock, String adjustedCostPrice, String reason) {
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      var adjustedCostPriceDouble = double.tryParse(adjustedCostPrice);

      snackBarController.showLoadingSnackBar(
          message: "Adjusting cost price...");

      inventoryController
          .costPriceAdjustment(
              uid: uid,
              stock: stock,
              adjustedCostPrice: adjustedCostPriceDouble!,
              reason: reason)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar("Cost price successfully adjusted...");

        navigationController.navigateToPreviousPage();
      });
    } else {
      snackBarController
          .showSnackBarError('Kindly review the adjustment information...');
    }
  }

  reviewAndAdjustSalePrice(GlobalKey<FormState> formKey, String uid,
      Stock stock, String adjustedSalePrice, String reason) {
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      var adjustedSalePriceDouble = double.tryParse(adjustedSalePrice);

      snackBarController.showLoadingSnackBar(
          message: "Adjusting sale price...");

      inventoryController
          .salePriceAdjustment(
              uid: uid,
              stock: stock,
              adjustedSalePrice: adjustedSalePriceDouble!,
              reason: reason)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar("Sale price successfully adjusted...");

        navigationController.navigateToPreviousPage();
      });
    } else {
      snackBarController
          .showSnackBarError('Kindly review the adjustment information...');
    }
  }

  reviewAndMoveInventory(
      GlobalKey<FormState> formKey,
      String uid,
      StockLocation? newStockLocation,
      String movedStockLevel,
      Stock currentStock) {
    bool isValid = formKey.currentState!.validate();

    var movedStockLevelDouble = double.tryParse(movedStockLevel);

    if (newStockLocation == null) {
      snackBarController
          .showSnackBarError("Please add the stock location to continue");
    } else if (!isValid) {
      snackBarController
          .showSnackBarError('Kindly review the movement information...');
    } else {
      var stockID = itemController.getItemID();
      Stock movedStock = Stock(
          item: currentStock.item,
          supplier: currentStock.supplier,
          stockLevel: movedStockLevelDouble,
          stockLocation: newStockLocation.toFirestore(),
          expirationDate: currentStock.expirationDate,
          batchNumber: currentStock.batchNumber,
          costPrice: currentStock.costPrice,
          salePrice: currentStock.salePrice,
          purchaseDate: currentStock.purchaseDate,
          inventoryCreatedOn: currentStock.inventoryCreatedOn,
          expirationWarning: currentStock.expirationWarning,
          stockID: stockID,
          forRetailSale: currentStock.forRetailSale);

      snackBarController.showLoadingSnackBar(message: "Moving stock...");

      inventoryController
          .moveInventoryStock(
              uid: uid, currentStock: currentStock, movedStock: movedStock)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar("Stock successfully moved...");

        navigationController.navigateToPreviousPage();
      });
    }
  }

  reviewAndSubmitStock(
      GlobalKey<FormState> formKey,
      String uid,
      Item item,
      String openingStock,
      String costPrice,
      String salePrice,
      String expirationWarning,
      Supplier? supplier,
      StockLocation? stockLocation,
      DateTime expirationDate,
      String batchNumber,
      DateTime purchaseDate,
      Inventory inventory,
      String newLeadTime) {
    bool isValid = formKey.currentState!.validate();

    if (stockLocation == null) {
      snackBarController
          .showSnackBarError("Please add the stock location to continue");
    } else if (supplier == null) {
      snackBarController
          .showSnackBarError("Please add the supplier to continue");
    } else if (isValid) {
      var stockID = itemController.getItemID();
      var stockLevel = double.tryParse(openingStock);

      var costPriceDouble = double.tryParse(costPrice);
      var salePriceDouble = double.tryParse(salePrice);
      var expirationWarningDouble = double.tryParse(expirationWarning);
      var newLeadTimeDouble = double.tryParse(newLeadTime);

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
          stockID: stockID,
          forRetailSale: false);

      snackBarController.showLoadingSnackBar(message: "Adding stock...");

      inventoryController
          .addInventoryStock(
              uid: uid,
              itemID: item.itemID!,
              stock: stock,
              inventory: inventory,
              newLeadTime: newLeadTimeDouble!)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar("Item successfully added...");

        navigationController.navigateToPreviousPage();
      });
    } else {
      showSnackBarError('Kindly review the stock information...');
    }
  }

  reviewAndSubmitStockFromPO(
      GlobalKey<FormState> formKey,
      String uid,
      Item item,
      double stockLevel,
      double costPrice,
      String salePrice,
      String expirationWarning,
      Supplier? supplier,
      StockLocation? stockLocation,
      DateTime expirationDate,
      String batchNumber,
      DateTime purchaseDate,
      Inventory inventory,
      PurchaseOrder purchaseOrder) {
    bool isValid = formKey.currentState!.validate();

    if (stockLocation == null) {
      snackBarController
          .showSnackBarError("Please add the stock location to continue");
    } else if (supplier == null) {
      snackBarController
          .showSnackBarError("Please add the supplier to continue");
    } else if (isValid) {
      var stockID = itemController.getItemID();
      var salePriceDouble = double.tryParse(salePrice);
      var expirationWarningDouble = double.tryParse(expirationWarning);
      var newLeadTime = dateTimeController.leadTimeFromPO(
          orderPlacedOn: purchaseOrder.orderPlacedOn!,
          orderDeliveredOn: purchaseOrder.orderDeliveredOn!);

      Stock stock = Stock(
          item: item.toFirestore(),
          supplier: supplier.toFirestore(),
          stockLevel: stockLevel,
          stockLocation: stockLocation.toFirestore(),
          expirationDate: expirationDate,
          batchNumber: batchNumber,
          costPrice: costPrice,
          salePrice: salePriceDouble,
          purchaseDate: purchaseDate,
          inventoryCreatedOn: DateTime.now(),
          expirationWarning: expirationWarningDouble,
          stockID: stockID,
          forRetailSale: false);

      snackBarController.showLoadingSnackBar(message: "Adding stock...");

      purchaseOrderController
          .addInventoryStockFromPO(
              uid: uid,
              itemID: item.itemID!,
              stock: stock,
              inventory: inventory,
              newLeadTime: newLeadTime,
              purchaseOrder: purchaseOrder)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar("Item successfully added...");

        navigationController.navigateToPreviousPage();
      });
    } else {
      showSnackBarError('Kindly review the stock information...');
    }
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
                stockID: stockID,
                forRetailSale: false);

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

  reviewAndSubmitAccountSalesOrder(
      {required String uid,
      required List<SalesOrderItem> salesOrderItemList,
      required Customer? customer,
      required String? paymentTerms,
      required String? orderTotal,
      required List<Stock> stockList}) {
    var salesOrderID = itemController.getItemID();
    List<Map>? itemOrders = [];

    for (var item in salesOrderItemList) {
      itemOrders.add(item.toMap());
    }

    if (customer != null) {
      SalesOrder salesOrder = SalesOrder(
          customer: customer.toMap(),
          transactionMadeOn: DateTime.now(),
          paymentTerms: paymentTerms,
          itemOrders: itemOrders,
          orderTotal: orderTotal,
          salesOrderID: salesOrderID);

      snackBarController.showLoadingSnackBar(
          message: 'Creating sales order....');

      salesOrderController
          .addAccountSalesOrder(
              uid: uid, salesOrder: salesOrder, adjustedStockList: stockList)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController.showSnackBar('Sales order successfully created...');
        navigateToPreviousPage();
        navigateToPreviousPage();
      });
    } else {
      snackBarController.showSnackBarError(
          'Please provide a customer account for this sale...');
    }
  }

  submitRetailSalesOrder(
      {required String uid,
      required List<SalesOrderItem> salesOrderItemList,
      required String? paymentTerms,
      required String? orderTotal,
      required List<Stock> stockList}) {
    var salesOrderID = itemController.getItemID();
    List<Map>? itemOrders = [];

    for (var item in salesOrderItemList) {
      itemOrders.add(item.toMap());
    }

    SalesOrder salesOrder = SalesOrder(
        customer: {},
        transactionMadeOn: DateTime.now(),
        paymentTerms: paymentTerms,
        itemOrders: itemOrders,
        orderTotal: orderTotal,
        salesOrderID: salesOrderID);

    snackBarController.showLoadingSnackBar(message: 'Creating sales order....');

    salesOrderController
        .addSalesOrder(
            uid: uid, salesOrder: salesOrder, adjustedStockList: stockList)
        .whenComplete(() {
      snackBarController.hideCurrentSnackBar();
      snackBarController.showSnackBar('Sales order successfully created...');
      navigateToPreviousPage();
      navigateToPreviousPage();
    });
  }

  reviewAndSubmitPurchaseOrder(
      {required GlobalKey<FormState> formKey,
      required String uid,
      required Supplier? supplier,
      required String? deliveryAddress,
      required DateTime? expectedDeliveryDate,
      required List<PurchaseOrderItem>? purchaseOrderItemList}) {
    bool isValid = formKey.currentState!.validate();

    if (supplier == null) {
      snackBarController
          .showSnackBarError('Please provide a supplier for this order...');
    } else if (!isValid) {
      snackBarController
          .showSnackBarError('Please review the information you provided...');
    } else if (purchaseOrderItemList!.isEmpty) {
      snackBarController.showSnackBarError('You do not have any orders...');
    } else {
      var purchaseOrderID = itemController.getItemID();
      List<Map>? itemOrderList = [];
      for (var item in purchaseOrderItemList) {
        itemOrderList.add(item.toMap());
      }
      PurchaseOrder purchaseOrder = PurchaseOrder(
        supplier: supplier.toFirestore(),
        deliveryAddress: deliveryAddress,
        expectedDeliveryDate: expectedDeliveryDate,
        orderPlaced: false,
        orderConfirmed: false,
        orderPlacedOn: defaultDateTime,
        orderConfirmedOn: defaultDateTime,
        orderDeliveredOn: defaultDateTime,
        itemOrderList: itemOrderList,
        purchaseOrderID: purchaseOrderID,
        orderCreatedOn: DateTime.now(),
        orderDelivered: false,
      );
      snackBarController.showLoadingSnackBar(
          message: 'Creating purchase order....');

      purchaseOrderController
          .addPurchaseOrder(uid: uid, purchaseOrder: purchaseOrder)
          .whenComplete(() {
        snackBarController.hideCurrentSnackBar();
        snackBarController
            .showSnackBar('Purchase order successfully created...');
        navigateToPreviousPage();
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

  bool checkIfPurchaseOrderChanged(
      PurchaseOrder originalPurchaseOrder, PurchaseOrder newPurchaseOrder) {
    var equatableOriginal =
        EquatablePurchaseOrder.fromPurchaseOrder(originalPurchaseOrder);
    var equatableNew =
        EquatablePurchaseOrder.fromPurchaseOrder(newPurchaseOrder);

    if (equatableOriginal == equatableNew) {
      return false;
    } else {
      return true;
    }
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

  getIncomingInventoryState(
      bool orderPlaced, bool orderConfirmed, bool orderDelivered) {
    if (orderPlaced == false) {
      return IncomingInventoryState.forPlacement;
    } else if (orderConfirmed == false) {
      return IncomingInventoryState.forConfirmation;
    } else if (orderConfirmed == true && orderDelivered == false) {
      return IncomingInventoryState.forDelivery;
    } else if (orderDelivered == true) {
      return IncomingInventoryState.forInventory;
    }
  }

  ExpirationState getExpirationState(
      DateTime expirationDate, double expirationWarning) {
    DateTime now = DateTime.now();
    Duration timeUntilExpiration = expirationDate.difference(now);

    int warningDays = expirationWarning.ceil();

    if (timeUntilExpiration.inDays <= 0) {
      return ExpirationState.expired;
    } else if (timeUntilExpiration.inDays <= warningDays) {
      return ExpirationState.nearExpiration;
    } else {
      return ExpirationState.good;
    }
  }

  int getDaysToExpiration(DateTime expirationDate) {
    DateTime now = DateTime.now();
    Duration timeUntilExpiration = expirationDate.difference(now);

    return timeUntilExpiration.inDays;
  }

  DateTime timestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  double leadTimeFromPO(DateTime orderPlacedOn, DateTime orderDeliveredOn) {
    int leadTime = orderDeliveredOn.difference(orderPlacedOn).inDays;

    return leadTime.toDouble();
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

  Perishability getPerishabilityState({required String perishabilityString}) {
    for (var perishability in Perishability.values) {
      if (perishability.label == perishabilityString) {
        return perishability;
      }
    }

    return Perishability.values.first;
  }

  String pluralize(String noun, num count) {
    if (count == 1) {
      return noun; // Singular form
    } else {
      // Basic pluralization rule: Add "s" to the noun
      return "${noun}s"; // Plural form
    }
  }

  String formatAsPhilippineCurrency(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
    );
    return formatter.format(amount);
  }

  String formatAsPhilippineCurrencyWithoutSymbol(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'fil_PH',
      symbol: '',
    );
    return formatter.format(amount);
  }

  String formatDateTimeToYYYYMMDD(DateTime date) {
    final formattedDateTime = DateFormat('yyyyMMdd');
    return formattedDateTime.format(date);
  }

  String formatDateTimeToYMd(DateTime dateTime) {
    DateFormat formattedDateTime = DateFormat.yMd();
    return formattedDateTime.format(dateTime);
  }

  String formatDateTimeToYMdjm(DateTime dateTime) {
    DateFormat formattedDateTime = DateFormat.yMd().add_jm();
    return formattedDateTime.format(dateTime);
  }

  double getInventoryValue(double stockLevel, double costPrice) {
    var inventoryValue = stockLevel * costPrice;

    return inventoryValue;
  }

  double getMaximumLeadTime(double oldMaximumLeadTime, double newLeadTime) {
    if (newLeadTime > oldMaximumLeadTime) {
      return newLeadTime;
    } else {
      return oldMaximumLeadTime;
    }
  }

  double getAverageLeadTime(double oldAverageLeadTime, newLeadTime) {
    var sum = oldAverageLeadTime + newLeadTime;
    var average = sum / 2;

    return average.ceilToDouble();
  }

  double getSafetyStockLevel(double maximumLeadTime, double maximumDailyDemand,
      double averageDailyDemand, double averageLeadTime) {
    var safetyStockLevel = (maximumLeadTime * maximumDailyDemand) -
        (averageDailyDemand * averageLeadTime);

    return safetyStockLevel;
  }

  double getReorderPoint(double averageLeadTime, double averageDailyDemand,
      double safetyStockLevel) {
    var reorderPoint =
        (averageLeadTime * averageDailyDemand) + safetyStockLevel;

    return reorderPoint;
  }

  Map<String, dynamic> getInventoryStatisticsOnSale(
    Inventory inventory,
    double currentInventoryDepletionValue,
    double stockLevelDepletion,
  ) {
    double? safetyStockLevel = statisticsController.getSafetyStockLevel(
        maximumLeadTime: inventory.maximumLeadTime!,
        maximumDailyDemand: inventory.maximumDailyDemand!,
        averageDailyDemand: inventory.averageDailyDemand!,
        averageLeadTime: inventory.averageLeadTime!);

    double? reorderPoint = statisticsController.getReorderPoint(
        averageLeadTime: inventory.averageLeadTime!,
        averageDailyDemand: inventory.averageDailyDemand!,
        safetyStockLevel: safetyStockLevel);

    Map<String, dynamic> data = {
      'currentInventory': FieldValue.increment(currentInventoryDepletionValue),
      'stockLevel': FieldValue.increment(stockLevelDepletion),
      'safetyStockLevel': safetyStockLevel,
      'reorderPoint': reorderPoint,
    };

    return data;
  }

  Map<String, dynamic> getInventoryStatisticsOnStockAdd(Inventory inventory,
      double newLeadTime, double stockLevel, double costPrice) {
    var oldMaximumLeadTime = inventory.maximumLeadTime;
    var oldAverageLeadTime = inventory.averageLeadTime;
    var maximumDailyDemand = inventory.maximumDailyDemand;
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

    Map<String, dynamic> data = {
      'maximumLeadTime': maximumLeadTime,
      'averageLeadTime': averageLeadTime,
      'currentInventory': FieldValue.increment(newInventory),
      'stockLevel': FieldValue.increment(newStockLevel),
      'safetyStockLevel': safetyStockLevel,
      'reorderPoint': reorderPoint,
    };

    return data;
  }

  bool isPositiveDoubleBelowOrEqualToCount(String input, double maxCount) {
    double? number = double.tryParse(input);
    return number != null && number >= 0 && number <= maxCount;
  }

  double getAdjustedStockLevelForMovement(
      double currentStockLevel, double adjustment) {
    double adjustedStockLevel = currentStockLevel - adjustment;

    return adjustedStockLevel;
  }

  String addLeadingZeros(int a) {
    String aString = a.toString();
    int length = aString.length;

    if (length < 8) {
      int numberOfZerosToAdd = 8 - length;
      String zeros = '0' * numberOfZerosToAdd;
      return zeros + aString;
    } else {
      return aString;
    }
  }

  String createPurchaseOrderNumber(int a) {
    String aString = a.toString();
    int length = aString.length;

    if (length < 8) {
      int numberOfZerosToAdd = 8 - length;
      String zeros = '0' * numberOfZerosToAdd;
      return 'PO-$zeros$aString';
    } else {
      return 'PO-$aString';
    }
  }

  String createSalesOrderNumber(int a) {
    String aString = a.toString();
    int length = aString.length;

    if (length < 8) {
      int numberOfZerosToAdd = 8 - length;
      String zeros = '0' * numberOfZerosToAdd;
      return 'SO-$zeros$aString';
    } else {
      return 'SO-$aString';
    }
  }

  processEditPurchaseOrder(GlobalKey<FormState> formKey, String uid,
      PurchaseOrder originalPurchaseOrder, PurchaseOrder newPurchaseOrder) {
    bool isValid = formKey.currentState!.validate();
    bool hasChanges = purchaseOrderController.checkIfPurchaseOrderChanged(
        originalPurchaseOrder: originalPurchaseOrder,
        newPurchaseOrder: newPurchaseOrder);

    if (isValid) {
      if (hasChanges) {
        snackBarController.showLoadingSnackBar(
            message: 'Updating your purchase order...');

        purchaseOrderController
            .updatePurchaseOrder(uid: uid, purchaseOrder: newPurchaseOrder)
            .whenComplete(() {
          snackBarController.hideCurrentSnackBar();
          navigationController.navigateToPreviousPage();
          navigationController.navigateToPreviousPage();
          snackBarController
              .showSnackBar('Purchase order successfully updated...');
        });
      } else {
        snackBarController.showSnackBarError(
            'You have made no changes to this purchase order');
      }
    } else {
      snackBarController
          .showSnackBarError('Kindly review the purchase order information...');
    }
  }

  SalesOrderItem getSalesOrderItem(RetailItem retailItem, double quantity) {
    var retailStocks =
        retailItem.retailStocks!.map((e) => Stock.fromMap(e)).toList();

    retailStocks
        .sort((a, b) => a.inventoryCreatedOn!.compareTo(b.inventoryCreatedOn!));

    double getSubtotalFromStockList(List<Stock> retailStocks, double quantity) {
      double subtotal = 0.0;
      for (var stock in retailStocks) {
        if (stock.stockLevel! >= quantity) {
          subtotal += quantity * stock.salePrice!;
          break;
        } else {
          subtotal += stock.stockLevel! * stock.salePrice!;
          quantity -= stock.stockLevel!;
        }
      }
      return subtotal;
    }

    var subtotal = getSubtotalFromStockList(retailStocks, quantity);

    return SalesOrderItem(
        item: retailItem.item!, quantity: quantity, subtotal: subtotal);
  }

  List<Stock> getAdjustedStocksFromSO(RetailItem retailItem, double quantity) {
    var retailStocks =
        retailItem.retailStocks!.map((e) => Stock.fromMap(e)).toList();

    retailStocks
        .sort((a, b) => a.inventoryCreatedOn!.compareTo(b.inventoryCreatedOn!));

    List<Stock> adjustedStocks = [];
    double remainingQuantity = quantity; // Initialize the local variable.

    for (var stock in retailStocks) {
      if (remainingQuantity > 0) {
        if (stock.stockLevel! >= remainingQuantity) {
          stock.stockLevel = stock.stockLevel! - remainingQuantity;
          adjustedStocks.add(stock);
          remainingQuantity = 0; // Update the remaining quantity.
        } else {
          double usedQuantity = stock.stockLevel!;
          stock.stockLevel = 0;
          adjustedStocks.add(stock);
          remainingQuantity -= usedQuantity;
        }
      } else {
        adjustedStocks.add(stock);
      }
    }

    return adjustedStocks;
  }

/*  List<Stock> getAdjustedStocksFromSO(RetailItem retailItem, double quantity) {
    var retailStocks =
        retailItem.retailStocks!.map((e) => Stock.fromMap(e)).toList();

    retailStocks
        .sort((a, b) => a.inventoryCreatedOn!.compareTo(b.inventoryCreatedOn!));

    List<Stock> adjustedStocks = [];

    for (var stock in retailStocks) {
      if (quantity > 0) {
        if (stock.stockLevel! >= quantity) {
          stock.stockLevel = stock.stockLevel! - quantity;
          adjustedStocks.add(stock);
          quantity = 0;
        } else {
          stock.stockLevel = 0;
          adjustedStocks.add(stock);
          quantity -= stock.stockLevel!;
        }
      } else {
        adjustedStocks.add(stock);
      }
    }

    return adjustedStocks;
  }*/

  addSalesOrderItem(
      WidgetRef ref, RetailItem retailItem, double stockLimit, double count) {
    bool atLimit = stockLimit <= count;

    if (atLimit) {
      stockLimit == 0.0
          ? snackBarController.showSnackBarError(
              'You have no stock available to fulfill this order...')
          : snackBarController.showSnackBarError(
              'You do not have enough stock to fulfill additional orders for this item...');
    } else {
      ++count;
      SalesOrderItem salesOrderItem = salesOrderController.getSalesOrderItem(
          retailItem: retailItem, quantity: count);

      List<Stock> adjustedStockList = salesOrderController
          .getAdjustedStocksFromSO(retailItem: retailItem, quantity: count);

      ref.read(salesOrderCartNotifierProvider.notifier).addItem(salesOrderItem);
      ref
          .read(adjustedStockListNotifierProvider.notifier)
          .updateList(adjustedStockList);
    }
  }

  Future<void> addSalesOrderItemViaScan(
    WidgetRef ref,
    RetailItem retailItem,
  ) async {
    var count = 0.0;
    var item = Item.fromMap(retailItem.item!);
    var salesOrderCart = ref.watch(salesOrderCartNotifierProvider);
    var orderItem = salesOrderCart.firstWhereOrNull(
        (salesOrderItem) => salesOrderItem.item?['itemID'] == item.itemID);
    if (orderItem != null) {
      count = orderItem.quantity!;
      count++;
      SalesOrderItem salesOrderItem = salesOrderController.getSalesOrderItem(
          retailItem: retailItem, quantity: count);

      List<Stock> adjustedStockList = salesOrderController
          .getAdjustedStocksFromSO(retailItem: retailItem, quantity: count);

      ref.read(salesOrderCartNotifierProvider.notifier).addItem(salesOrderItem);
      ref
          .read(adjustedStockListNotifierProvider.notifier)
          .updateList(adjustedStockList);
    } else {
      count++;
      SalesOrderItem salesOrderItem = salesOrderController.getSalesOrderItem(
          retailItem: retailItem, quantity: count);

      List<Stock> adjustedStockList = salesOrderController
          .getAdjustedStocksFromSO(retailItem: retailItem, quantity: count);

      ref.read(salesOrderCartNotifierProvider.notifier).addItem(salesOrderItem);
      ref
          .read(adjustedStockListNotifierProvider.notifier)
          .updateList(adjustedStockList);
    }
  }

  addCustomSalesOrderItem(WidgetRef ref, RetailItem retailItem,
      double stockLimit, double quantity) {
    bool beyondLimit = stockLimit < quantity;

    if (beyondLimit) {
      stockLimit == 0.0
          ? snackBarController.showSnackBarError(
              'You have no stock available to fulfill this order...')
          : snackBarController.showSnackBarError(
              'You do not have enough stock to fulfill additional orders for this item...');
    } else {
      SalesOrderItem salesOrderItem = salesOrderController.getSalesOrderItem(
          retailItem: retailItem, quantity: quantity);

      List<Stock> adjustedStockList = salesOrderController
          .getAdjustedStocksFromSO(retailItem: retailItem, quantity: quantity);

      ref.read(salesOrderCartNotifierProvider.notifier).addItem(salesOrderItem);
      ref
          .read(adjustedStockListNotifierProvider.notifier)
          .updateList(adjustedStockList);
    }
  }

  String removeTrailingZeros(double value) {
    String stringValue = value.toString();
    if (stringValue.contains('.')) {
      stringValue = stringValue.replaceAll(RegExp(r'0*$'), '');

      stringValue = stringValue.replaceAll(RegExp(r'\.$'), '');
    }
    return stringValue;
  }

  String getAveragePrice(double quantity, double total) {
    var average = total / quantity;
    var averageAsCurrency = currencyController
        .formatAsPhilippineCurrencyWithoutSymbol(amount: average);

    return averageAsCurrency;
  }

  double averageInventory(double beginningInventory, double currentInventory) {
    var value = (beginningInventory + currentInventory) / 2;

    return value;
  }

  double costOfGoodsSold(double beginningInventory,
      double purchasesDuringThePeriod, double currentInventory) {
    var value =
        beginningInventory + purchasesDuringThePeriod - currentInventory;

    return value;
  }

  double stockTurnOverRate(double costOfGoodsSold, double averageInventory) {
    var value = costOfGoodsSold / averageInventory;

    return value;
  }

  double daysOfInventoryOnHand(
      double averageInventoryValue, double costOfGoodsSold, int numberOfDays) {
    var numberOfDaysDouble = numberOfDays.toDouble();
    var value = averageInventoryValue / (costOfGoodsSold / numberOfDaysDouble);
    return value;
  }

  double stockToSalesRatio(
      double averageInventoryValue, double netSalesDuringThePeriod) {
    var value = averageInventoryValue / netSalesDuringThePeriod;

    return value;
  }

  double sellThroughRate(
      double salesDuringThePeriod, double beginningInventory) {
    var value = salesDuringThePeriod / beginningInventory;

    return value;
  }


}
