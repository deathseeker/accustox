

import 'package:accustox/add_item_to_purchase_order.dart';
import 'package:accustox/edit_profile.dart';
import 'package:accustox/new_customer_account.dart';
import 'package:accustox/new_item.dart';
import 'package:accustox/new_purchase_order.dart';
import 'package:accustox/new_supplier.dart';
import 'package:accustox/process_sales_order.dart';
import 'package:flutter/material.dart';
import 'app_open_splash.dart';
import 'create_profile.dart';
import 'error_splash.dart';
import 'home.dart';
import 'sign_in.dart';

Map<String, Widget Function(BuildContext)> routes(BuildContext context) {
  Map<String, Widget Function(BuildContext)> routes = {
    'home': (context) => const Home(),
    'signIn': (context) => const SignIn(),
    'createProfile': (context) => const CreateProfile(),
    'appOpenSplash': (context) => const AppOpenSplash(),
    'errorSplash': (context) => const ErrorSplash(),
    'editProfile': (context) =>  const EditProfile(),
    'newSupplier': (context) => const NewSupplier(),
    'newCustomerAccount': (context) => const NewCustomerAccount(),
    'newItem': (context) => const NewItem(),
    'newPurchaseOrder': (context) => const NewPurchaseOrder(),
    'addItemToPurchaseOrder': (context) => const AddItemToPurchaseOrder(),
    'processSalesOrder': (context) => const ProcessSalesOrder()
  };

  return routes;
}