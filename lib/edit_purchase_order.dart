import 'widget_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'color_scheme.dart';
import 'controllers.dart';
import 'models.dart';
import 'providers.dart';
import 'text_theme.dart';

class EditPurchaseOrder extends ConsumerStatefulWidget {
  const EditPurchaseOrder(this.purchaseOrder, {super.key});

  final PurchaseOrder purchaseOrder;

  @override
  _EditPurchaseOrderState createState() => _EditPurchaseOrderState();
}

class _EditPurchaseOrderState extends ConsumerState<EditPurchaseOrder> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController deliveryAddressController =
      TextEditingController();
  final TextEditingController expectedDeliveryDateController =
      TextEditingController();

  final FocusNode deliveryAddressNode = FocusNode();

  late Supplier selectedSupplier;
  late DateTime selectedExpectedDeliveryDate;
  late PurchaseOrder purchaseOrder;
  late Supplier initialSupplier;

  @override
  void initState() {
    super.initState();
    purchaseOrder = widget.purchaseOrder;
    selectedExpectedDeliveryDate = purchaseOrder.expectedDeliveryDate!;
    deliveryAddressController.text = purchaseOrder.deliveryAddress!;
    expectedDeliveryDateController.text = dateTimeController
        .formatDateTimeToYMd(dateTime: purchaseOrder.expectedDeliveryDate!);
    initialSupplier = Supplier.fromMap(widget.purchaseOrder.supplier);
    Future.delayed(Duration.zero, () async {
      var itemOrderList = purchaseOrder.itemOrderList!;
      for (var itemOrder in itemOrderList) {
        PurchaseOrderItem purchaseOrderItem =
            PurchaseOrderItem.fromMap(itemOrder);
        ref
            .read(purchaseOrderCartNotifierProvider.notifier)
            .addItem(purchaseOrderItem);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    deliveryAddressController.dispose();
    expectedDeliveryDateController.dispose();
    deliveryAddressNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var asyncSupplierList = ref.watch(streamSupplierListProvider);
    var supplierSelection = ref.watch(supplierSelectionProvider);
    var purchaseOrderItemList = ref.watch(purchaseOrderCartNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Purchase Order'),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: EditSupplierDropDownMenu(initialSupplier),
                      ),
                      Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  var selectedDate =
                                      await dateTimeController.selectDate(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101));
                                  setState(() {
                                    selectedExpectedDeliveryDate =
                                        selectedDate!;
                                    String formattedDate =
                                        DateFormat.yMd().format(selectedDate);
                                    expectedDeliveryDateController.text =
                                        formattedDate;
                                  });
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
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
                      const EditPurchaseOrderItemListCard(),
                      ButtonBar(
                        children: [
                          FilledButton(
                              onPressed: user == null
                                  ? null
                                  : () {
                                      var supplier = supplierSelection!.toMap();
                                      var itemOrderList = purchaseOrder
                                          .getPurchaseOrderItemListMap(
                                              purchaseOrderItemList);
                                      PurchaseOrder originalPurchaseOrder =
                                          purchaseOrder;
                                      PurchaseOrder newPurchaseOrder =
                                          purchaseOrder.copyWith(
                                              supplier: supplier,
                                              deliveryAddress:
                                                  deliveryAddressController
                                                      .text,
                                              expectedDeliveryDate:
                                                  selectedExpectedDeliveryDate,
                                              itemOrderList: itemOrderList);
                                      purchaseOrderController
                                          .processEditPurchaseOrder(
                                              formKey: _formKey,
                                              uid: user.uid,
                                              originalPurchaseOrder:
                                                  originalPurchaseOrder,
                                              newPurchaseOrder:
                                                  newPurchaseOrder);
                                    },
                              child: const Text('Edit Order'))
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

class EditPurchaseOrderItemListCard extends ConsumerWidget {
  const EditPurchaseOrderItemListCard({super.key});

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
