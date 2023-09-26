import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'controllers.dart';
import 'default_values.dart';
import 'models.dart';
import 'providers.dart';
import 'widget_components.dart';

class NewInventoryStock extends StatelessWidget {
  final Inventory inventory;

  const NewInventoryStock({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock'),
      ),
      body: NewInventoryStockBody(inventory),
    );
  }
}

class NewInventoryStockBody extends ConsumerStatefulWidget {
  const NewInventoryStockBody(this.inventory, {super.key});

  final Inventory inventory;

  @override
  _NewInventoryStockBodyState createState() => _NewInventoryStockBodyState();
}

class _NewInventoryStockBodyState extends ConsumerState<NewInventoryStockBody> {
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

  @override
  void initState() {
    super.initState();
    selectedExpirationDate = defaultDateTime;
    selectedPurchaseDate = defaultDateTime;
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
    var supplier = ref.watch(supplierSelectionProvider);
    var stockLocation = ref.watch(locationSelectionProvider);
    Inventory inventory = widget.inventory;
    Item item = Item.fromMap(widget.inventory.item!);
    var perishability = perishabilityController.getPerishabilityState(
        perishabilityString: item.perishability!);
    var enabled = perishabilityController.enableExpirationDateInput(
        perishability: perishability);

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
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LocationDropDownMenu(),
                        ),
                        Padding(padding: EdgeInsets.only(left: 16.0)),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: SupplierDropDownMenu(),
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
                              controller: openingStockController,
                              focusNode: openingStockFocusNode,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Stock Level'),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your stock quantity';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: costPriceController,
                              focusNode: costPriceFocusNode,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Cost Price (in Php)'),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your cost per product unit';
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
                              onTap: () async {
                                var selectedDate =
                                    await dateTimeController.selectDate(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101));
                                setState(() {
                                  selectedPurchaseDate = selectedDate!;
                                  String formattedDate =
                                      DateFormat.yMd().format(selectedDate);
                                  purchaseDateController.text = formattedDate;
                                });
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: purchaseDateController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Purchase Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 16.0)),
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
                        const Padding(padding: EdgeInsets.only(left: 16.0)),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: leadTimeController,
                              focusNode: leadTimeFocusNode,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Lead Time'),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter the lead Time for this item';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ButtonBar(
                      children: [
                        FilledButton(
                            onPressed: user == null
                                ? null
                                : () {
                                    inventoryController.reviewAndSubmitStock(
                                        formKey: _formKey,
                                        uid: user.uid,
                                        item: item,
                                        openingStock:
                                            openingStockController.text,
                                        costPrice: costPriceController.text,
                                        salePrice: salePriceController.text,
                                        expirationWarning:
                                            expirationWarningController.text,
                                        supplier: supplier,
                                        stockLocation: stockLocation,
                                        expirationDate: selectedExpirationDate!,
                                        batchNumber: batchNumberController.text,
                                        purchaseDate: selectedPurchaseDate!,
                                        inventory: inventory,
                                        newLeadTime: leadTimeController.text);
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
