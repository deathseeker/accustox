import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'controllers.dart';
import 'default_values.dart';
import 'models.dart';
import 'providers.dart';
import 'widget_components.dart';

class NewInventoryStockFromPurchaseOrder extends StatelessWidget {
  final PurchaseOrderItem purchaseOrderItem;
  final PurchaseOrder purchaseOrder;

  const NewInventoryStockFromPurchaseOrder(
      {super.key,
      required this.purchaseOrderItem,
      required this.purchaseOrder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock from PO'),
      ),
      body: NewInventoryStockFromPurchaseOrderBody(
          purchaseOrderItem, purchaseOrder),
    );
  }
}

class NewInventoryStockFromPurchaseOrderBody extends ConsumerStatefulWidget {
  const NewInventoryStockFromPurchaseOrderBody(
      this.purchaseOrderItem, this.purchaseOrder,
      {super.key});

  final PurchaseOrderItem purchaseOrderItem;
  final PurchaseOrder purchaseOrder;

  @override
  _NewInventoryStockFromPurchaseOrderBodyState createState() =>
      _NewInventoryStockFromPurchaseOrderBodyState();
}

class _NewInventoryStockFromPurchaseOrderBodyState
    extends ConsumerState<NewInventoryStockFromPurchaseOrderBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController openingStockController = TextEditingController();
  final TextEditingController stockLocationController = TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();
  final TextEditingController batchNumberController = TextEditingController();
  final TextEditingController costPriceController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController expirationWarningController =
      TextEditingController();
  final TextEditingController leadTimeController = TextEditingController();

  final FocusNode openingStockFocusNode = FocusNode();
  final FocusNode stockLocationFocusNode = FocusNode();
  final FocusNode expirationDateFocusNode = FocusNode();
  final FocusNode batchNumberFocusNode = FocusNode();
  final FocusNode costPriceFocusNode = FocusNode();
  final FocusNode salePriceFocusNode = FocusNode();
  final FocusNode purchaseDateFocusNode = FocusNode();
  final FocusNode supplierFocusNode = FocusNode();
  final FocusNode expirationWarningFocusNode = FocusNode();
  final FocusNode leadTimeFocusNode = FocusNode();

  late DateTime? selectedExpirationDate;
  late DateTime? selectedPurchaseDate;
  late Item item;
  late PurchaseOrder purchaseOrder;
  late PurchaseOrderItem purchaseOrderItem;

  @override
  void initState() {
    super.initState();
    selectedExpirationDate = defaultDateTime;
    selectedPurchaseDate = defaultDateTime;
    purchaseOrderItem = widget.purchaseOrderItem;
    item = purchaseOrderItem.getItem();
    purchaseOrder = widget.purchaseOrder;
  }

  @override
  void dispose() {
    super.dispose();
    openingStockController.dispose();
    stockLocationController.dispose();
    costPriceController.dispose();
    salePriceController.dispose();
    batchNumberController.dispose();
    purchaseDateController.dispose();
    expirationDateController.dispose();
    expirationWarningController.dispose();
    stockLocationFocusNode.dispose();
    supplierFocusNode.dispose();
    openingStockFocusNode.dispose();
    costPriceFocusNode.dispose();
    salePriceFocusNode.dispose();
    batchNumberFocusNode.dispose();
    purchaseDateFocusNode.dispose();
    expirationDateFocusNode.dispose();
    expirationWarningFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var inventory = ref.watch(streamInventoryProvider(item.itemID!)).value;
    var supplier = Supplier.fromMap(purchaseOrder.supplier!);
    var stockLocation = ref.watch(locationSelectionProvider);
    var perishability = perishabilityController.getPerishabilityState(
        perishabilityString: purchaseOrderItem.perishability!);
    var enabled = perishabilityController.enableExpirationDateInput(
        perishability: perishability);
    var stockLevel =
        '${purchaseOrderItem.quantity.toString()} ${pluralizationController.pluralize(noun: purchaseOrderItem.unitOfMeasurement!, count: purchaseOrderItem.quantity)}';
    var costPrice = currencyController.formatAsPhilippineCurrency(
        amount: purchaseOrderItem.estimatedPrice);
    var asyncLocationList = ref.watch(streamLocationDataListProvider);

    return asyncLocationList.when(
        data: (data) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Wrap(
                                spacing: 16.0,
                                runSpacing: 4.0,
                                children: [
                                  InformationWithLabelLarge(
                                      label: 'SKU',
                                      data: purchaseOrderItem.sku!),
                                  InformationWithLabelLarge(
                                      label: 'Stock Level', data: stockLevel),
                                  InformationWithLabelLarge(
                                      label: 'Cost Price', data: costPrice),
                                  InformationWithLabelLarge(
                                      label: 'Item Name',
                                      data: purchaseOrderItem.itemName!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LocationDropDownMenu(),
                        ),
                      ],
                    ),
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: salePriceController,
                              focusNode: salePriceFocusNode,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Sale Price (in Php)'),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your selling price per product unit';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 16.0)),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: batchNumberController,
                              focusNode: batchNumberFocusNode,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Batch/Lot Number'),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: enabled
                                  ? () async {
                                      var selectedDate =
                                          await dateTimeController.selectDate(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101));
                                      setState(() {
                                        selectedExpirationDate = selectedDate!;
                                        String formattedDate = DateFormat.yMd()
                                            .format(selectedDate);
                                        expirationDateController.text =
                                            formattedDate;
                                      });
                                    }
                                  : null,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  autovalidateMode: enabled
                                      ? AutovalidateMode.onUserInteraction
                                      : null,
                                  enabled: enabled,
                                  controller: expirationDateController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Expiration Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  textInputAction: TextInputAction.done,
                                  validator: enabled
                                      ? (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter the expiration date';
                                          }
                                          return null;
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 16.0)),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              enabled: enabled,
                              autovalidateMode: enabled
                                  ? AutovalidateMode.onUserInteraction
                                  : null,
                              controller: expirationWarningController,
                              focusNode: expirationWarningFocusNode,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Expiration Warning (in Days)'),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: enabled
                                  ? (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter how soon should you be warned about expiring stock';
                                      }
                                      return null;
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ButtonBar(
                      children: [
                        FilledButton(
                            onPressed: user == null || inventory == null
                                ? null
                                : () {
                                    purchaseOrderController
                                        .reviewAndSubmitStockFromPO(
                                            formKey: _formKey,
                                            uid: user.uid,
                                            item: item,
                                            stockLevel:
                                                purchaseOrderItem.quantity,
                                            costPrice: purchaseOrderItem
                                                .estimatedPrice,
                                            salePrice: salePriceController.text,
                                            expirationWarning:
                                                expirationWarningController
                                                    .text,
                                            supplier: supplier,
                                            stockLocation: stockLocation,
                                            expirationDate:
                                                selectedExpirationDate!,
                                            batchNumber:
                                                batchNumberController.text,
                                            purchaseDate:
                                                purchaseOrder.orderDeliveredOn!,
                                            inventory: inventory,
                                            purchaseOrder: purchaseOrder);
                                  },
                            child: const Text('Add Inventory'))
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
        loading: () => const LoadingWidget());
  }
}
