// ignore_for_file: library_private_types_in_public_api

import 'package:accustox/add_item_to_purchase_order.dart';
import 'package:accustox/controllers.dart';
import 'package:accustox/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'color_scheme.dart';
import 'models.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class NewPurchaseOrder extends ConsumerStatefulWidget {
  const NewPurchaseOrder({super.key});

  @override
  _NewPurchaseOrderState createState() => _NewPurchaseOrderState();
}

class _NewPurchaseOrderState extends ConsumerState<NewPurchaseOrder> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController deliveryAddressController =
      TextEditingController();
  final TextEditingController expectedDeliveryDateController =
      TextEditingController();

  final FocusNode supplierNameNode = FocusNode();
  final FocusNode deliveryAddressNode = FocusNode();

  final String estimatedTotalCost = 'Php 999999.99';
  late Supplier selectedSupplier;
  late DateTime selectedExpectedDeliveryDate;

  @override
  void initState() {
    super.initState();
    selectedExpectedDeliveryDate = DateTime.now();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var asyncSupplierList = ref.watch(streamSupplierListProvider);
    var supplierSelection = ref.watch(supplierSelectionProvider);
    var purchaseOrderItemList = ref.watch(purchaseOrderCartNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Purchase Order'),
      ),
      body: asyncSupplierList.when(
          data: (data) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: SupplierDropDownMenu(),
                      ),
                      Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: deliveryAddressController,
                                focusNode: deliveryAddressNode,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Deliver To'),
                                keyboardType: TextInputType.name,
                                // You can specify the keyboard type
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter delivery address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 16.0)),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  var selectedDate =
                                      await dateTimeController.selectDate(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101));
                                  setState(() {
                                    selectedExpectedDeliveryDate = selectedDate!;
                                    String formattedDate =
                                        DateFormat.yMd().format(selectedDate);
                                    expectedDeliveryDateController.text =
                                        formattedDate;
                                  });
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    controller: expectedDeliveryDateController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Expected Delivery Date',
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the expected delivery date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GroupTitleWithTextButton(
                            title: 'Items',
                            onPressed: () => navigationController
                                .navigateToAddItemToPurchaseOrder(),
                            buttonLabel: 'Add Item Order'),
                      ),
                      const NewPurchaseOrderItemListCard(),
                      ButtonBar(
                        children: [
                          FilledButton(
                              onPressed: user == null
                                  ? null
                                  : () {
                                      var supplier = supplierSelection;
                                      purchaseOrderController
                                          .reviewAndSubmitPurchaseOrder(
                                              formKey: _formKey,
                                              uid: user.uid,
                                              supplier: supplier,
                                              deliveryAddress:
                                                  deliveryAddressController.text,
                                              expectedDeliveryDate:
                                                  selectedExpectedDeliveryDate,
                                              purchaseOrderItemList:
                                                  purchaseOrderItemList);
                                    },
                              child: const Text('Create Order'))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          error: (e, st) =>
              const ErrorMessage(errorMessage: 'Something went wrong...'),
          loading: () => const LoadingWidget()),
    );
  }
}

class NewPurchaseOrderItemListCard extends ConsumerWidget {
  const NewPurchaseOrderItemListCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var purchaseOrderItemList = ref.watch(purchaseOrderCartNotifierProvider);
    var estimatedTotalCostFromNotifier =
        ref.watch(purchaseOrderCartNotifierProvider.notifier).getTotalCost();

    var estimatedTotalCost = currencyController.formatAsPhilippineCurrency(
        amount: estimatedTotalCostFromNotifier);

    return Card(
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PurchaseOrderItemListHeaderWithButtonSpace(),
            NewPurchaseOrderItemList(
                purchaseOrderItemList: purchaseOrderItemList),
            const Divider(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Estimated Total: $estimatedTotalCost',
                style: customTextStyle.titleMedium
                    .copyWith(color: lightColorScheme.onSurface),
              ),
            )
          ],
        ),
      ),
    );
  }
}
