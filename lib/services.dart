import 'enumerated_values.dart';
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

  bool hasProfileChanged(
      UserProfile originalProfile, UserProfileChangeNotifier notifier) {
    if (notifier.ownerName != originalProfile.ownerName ||
        notifier.businessName != originalProfile.businessName ||
        notifier.contactNumber != originalProfile.contactNumber ||
        notifier.address != originalProfile.address ||
        notifier.contactNumber != originalProfile.contactNumber ||
        notifier.email != originalProfile.email ||
        notifier.uid != originalProfile.uid) {
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

  addStockLocationDialog(BuildContext context, String uid) {
    final TextEditingController locationNameController =
        TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController typeController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    InventoryLocationType? handleLocationType(
        InventoryLocationType? selectedType) {
      return selectedType;
    }

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
}
