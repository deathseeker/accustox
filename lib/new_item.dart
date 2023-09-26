import 'package:accustox/default_values.dart';
import 'package:intl/intl.dart';
import 'controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'image_container.dart';
import 'models.dart';
import 'providers.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class NewItem extends StatelessWidget {
  const NewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
      ),
      body: const NewItemBody(),
    );
  }
}

class NewItemBody extends ConsumerStatefulWidget {
  const NewItemBody({super.key});

  @override
  _NewItemBodyState createState() => _NewItemBodyState();
}

class _NewItemBodyState extends ConsumerState<NewItemBody> {
  ImageStorageUploadData imageStorageUploadData = ImageStorageUploadData();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController productTypeController = TextEditingController();
  final TextEditingController manufacturerPartNumberController =
      TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController eanController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
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
  final TextEditingController dailyDemandController = TextEditingController();
  final TextEditingController leadTimeController = TextEditingController();
  final TextEditingController maximumDailyDemandController =
      TextEditingController();
  final TextEditingController maximumLeadTimeController =
      TextEditingController();

  final FocusNode itemNameFocusNode = FocusNode();
  final FocusNode manufacturerFocusNode = FocusNode();
  final FocusNode unitFocusNode = FocusNode();
  final FocusNode sizeFocusNode = FocusNode();
  final FocusNode brandFocusNode = FocusNode();
  final FocusNode productTypeFocusNode = FocusNode();
  final FocusNode manufacturerPartNumberFocusNode = FocusNode();
  final FocusNode colorFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode skuFocusNode = FocusNode();
  final FocusNode eanFocusNode = FocusNode();
  final FocusNode lengthFocusNode = FocusNode();
  final FocusNode widthFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();
  final FocusNode openingStockFocusNode = FocusNode();
  final FocusNode stockLocationFocusNode = FocusNode();
  final FocusNode expirationDateFocusNode = FocusNode();
  final FocusNode batchNumberFocusNode = FocusNode();
  final FocusNode costPriceFocusNode = FocusNode();
  final FocusNode salePriceFocusNode = FocusNode();
  final FocusNode purchaseDateFocusNode = FocusNode();
  final FocusNode supplierFocusNode = FocusNode();
  final FocusNode expirationWarningFocusNode = FocusNode();
  final FocusNode dailyDemandFocusNode = FocusNode();
  final FocusNode leadTimeFocusNode = FocusNode();
  final FocusNode maximumLeadTimeFocusNode = FocusNode();
  final FocusNode maximumDailyDemandFocusNode = FocusNode();

  late DateTime? selectedExpirationDate;
  late DateTime? selectedPurchaseDate;

  ImageFile imageFile = ImageFile();

  @override
  void initState() {
    super.initState();
    selectedExpirationDate = defaultDateTime;
    selectedPurchaseDate = defaultDateTime;
  }

  @override
  void dispose() {
    super.dispose();
    itemNameController.dispose();
    manufacturerController.dispose();
    manufacturerPartNumberController.dispose();
    productTypeController.dispose();
    unitController.dispose();
    sizeController.dispose();
    brandController.dispose();
    colorController.dispose();
    skuController.dispose();
    eanController.dispose();
    descriptionController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    openingStockController.dispose();
    stockLocationController.dispose();
    costPriceController.dispose();
    salePriceController.dispose();
    batchNumberController.dispose();
    purchaseDateController.dispose();
    expirationDateController.dispose();
    expirationWarningController.dispose();
    dailyDemandController.dispose();
    leadTimeController.dispose();
    itemNameFocusNode.dispose();
    manufacturerPartNumberFocusNode.dispose();
    manufacturerFocusNode.dispose();
    productTypeFocusNode.dispose();
    unitFocusNode.dispose();
    sizeFocusNode.dispose();
    brandFocusNode.dispose();
    colorFocusNode.dispose();
    skuFocusNode.dispose();
    eanFocusNode.dispose();
    descriptionFocusNode.dispose();
    lengthFocusNode.dispose();
    widthFocusNode.dispose();
    heightFocusNode.dispose();
    stockLocationFocusNode.dispose();
    supplierFocusNode.dispose();
    openingStockFocusNode.dispose();
    costPriceFocusNode.dispose();
    salePriceFocusNode.dispose();
    batchNumberFocusNode.dispose();
    purchaseDateFocusNode.dispose();
    expirationDateFocusNode.dispose();
    expirationWarningFocusNode.dispose();
    dailyDemandFocusNode.dispose();
    leadTimeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var perishabilitySelection = ref.watch(perishabilityProvider);
    var enabled = perishabilityController.enableExpirationDateInput(
        perishability: perishabilitySelection);
    var supplier = ref.watch(supplierSelectionProvider);
    var stockLocation = ref.watch(locationSelectionProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(asyncCategorySelectionDataProvider.notifier).resetState();
        ref.read(categorySelectionProvider.notifier).resetState();
        navigationController.navigateToPreviousPage();
        return false;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      ImageContainer(
                        imageFile: imageFile,
                      ),
                      Text(
                        "(*Item image is required.)",
                        style: customTextStyle.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: GroupTitle(title: 'Item Information'),
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: PerishabilityDropDownMenu(),
                    )
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: itemNameController,
                          focusNode: itemNameFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Item Name (Required)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter item name';
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
                          controller: manufacturerController,
                          focusNode: manufacturerFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Manufacturer'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          /*    validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter manufacturer';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: manufacturerPartNumberController,
                          focusNode: manufacturerPartNumberFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'MPN (Manufacturer Part Number)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          /* validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter manufacturer part number';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: productTypeController,
                          focusNode: productTypeFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Product Type'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product type';
                            }
                            return null;
                          },*/
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: unitController,
                          focusNode: unitFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Unit of Measurement (Required)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter unit of measurement';
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
                          controller: sizeController,
                          focusNode: sizeFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Size'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          /* validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter item size';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: brandController,
                          focusNode: brandFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Brand'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter brand';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: colorController,
                          focusNode: colorFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Color'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product color';
                            }
                            return null;
                          },*/
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: skuController,
                          focusNode: skuFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  'SKU (Stock Keeping Unit)  (Required)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter SKU';
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
                          controller: eanController,
                          focusNode: eanFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  'Barcode/EAN (European Article Number)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product color';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          String barcodeData =
                              await scannerController.scanBarCode();

                          setState(() {
                            eanController.text = barcodeData;
                          });
                        },
                        child: const Icon(Icons.barcode_reader))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: descriptionController,
                          focusNode: descriptionFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          /*  validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product description';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: GroupTitle(title: 'Item Dimensions'),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: lengthController,
                          focusNode: lengthFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Length (in cm)'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          /* validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product length';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: widthController,
                          focusNode: widthFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Width (in cm)'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product width';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: heightController,
                          focusNode: heightFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Height (in cm)'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          /*  validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product height';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: GroupTitle(
                      title: 'Item Category (Please select all that apply)'),
                ),
                const _CategoryTags(),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: GroupTitle(title: 'Opening Inventory Information'),
                ),
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
                          controller: openingStockController,
                          focusNode: openingStockFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Opening Stock'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your starting stock level';
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
                          controller: costPriceController,
                          focusNode: costPriceFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Cost Price (in Php)'),
                          keyboardType: TextInputType.number,
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
                          controller: salePriceController,
                          focusNode: salePriceFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Sale Price (in Php)'),
                          keyboardType: TextInputType.number,
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
                                    String formattedDate =
                                        DateFormat.yMd().format(selectedDate);
                                    expirationDateController.text =
                                        formattedDate;
                                  });
                                }
                              : null,
                          child: AbsorbPointer(
                            child: TextFormField(
                              enabled: perishabilityController
                                  .enableExpirationDateInput(
                                      perishability: perishabilitySelection),
                              controller: expirationDateController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Expiration Date',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
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
                          controller: expirationWarningController,
                          focusNode: expirationWarningFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Expiration Warning (in Days)'),
                          keyboardType: TextInputType.number,
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
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: dailyDemandController,
                          focusNode: dailyDemandFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Daily Demand (Est.)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an estimate of the daily demand for this item';
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
                          controller: maximumDailyDemandController,
                          focusNode: maximumDailyDemandFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Maximum Daily Demand (Est)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an estimate of the maximum daily demand for this item';
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
                          controller: leadTimeController,
                          focusNode: leadTimeFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Average Lead Time (Est.)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the estimated average lead Time for this item';
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
                          controller: maximumLeadTimeController,
                          focusNode: maximumLeadTimeFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Maximum Lead Time (Est.)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the estimated maximum lead Time for this item';
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
                                var itemID = itemController.getItemID();
                                List<Map>? categoryTags = ref
                                    .read(categorySelectionProvider)
                                    .map((e) => e.toMap())
                                    .toList();


                                Item item = Item(
                                    itemName: itemNameController.text,
                                    manufacturer: manufacturerController.text,
                                    manufacturerPartNumber:
                                        manufacturerPartNumberController.text,
                                    productType: productTypeController.text,
                                    unitOfMeasurement: unitController.text,
                                    size: sizeController.text,
                                    brand: brandController.text,
                                    color: colorController.text,
                                    sku: skuController.text,
                                    ean: eanController.text,
                                    itemDescription: descriptionController.text,
                                    length: lengthController.text,
                                    width: widthController.text,
                                    height: heightController.text,
                                    itemID: itemID,
                                    categoryTags: categoryTags,
                                    uid: user.uid,
                                    isItemAvailable: true,
                                    perishability:
                                        perishabilitySelection.label);

                                itemController.reviewAndSubmitItem(
                                    formKey: _formKey,
                                    imageFile: imageFile,
                                    uid: user.uid,
                                    imageStorageUploadData:
                                        imageStorageUploadData,
                                    item: item,
                                    ref: ref,
                                    openingStock: openingStockController.text,
                                    costPrice: costPriceController.text,
                                    salePrice: salePriceController.text,
                                    expirationWarning:
                                        expirationWarningController.text,
                                    averageDailyDemand:
                                        dailyDemandController.text,
                                    maximumDailyDemand:
                                        maximumDailyDemandController.text,
                                    averageLeadTime: leadTimeController.text,
                                    maximumLeadTime:
                                        maximumLeadTimeController.text,
                                    supplier: supplier,
                                    stockLocation: stockLocation,
                                    expirationDate: selectedExpirationDate!,
                                    batchNumber: batchNumberController.text,
                                    purchaseDate: selectedPurchaseDate!);
                              },
                        child: const Text('Create Item'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTags extends ConsumerStatefulWidget {
  const _CategoryTags({Key? key}) : super(key: key);

  @override
  _CategoryTagsState createState() => _CategoryTagsState();
}

class _CategoryTagsState extends ConsumerState<_CategoryTags> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncCategorySelectionList =
        ref.watch(asyncCategorySelectionDataProvider);

    return asyncCategorySelectionList.when(data: (data) {
      var list = data;

      list.sort((a, b) => a.categoryName!
          .toLowerCase()
          .compareTo(b.categoryName!.toLowerCase()));

      return list.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('There are no categories listed yet...'),
              ),
            )
          : Wrap(
              runSpacing: 8.0,
              spacing: 8.0,
              children: List.generate(list.length, (index) {
                CategorySelectionData data = list[index];
                return FilterChip(
                  label: Text(
                    data.categoryName!,
                  ),
                  selected: data.isSelected!,
                  onSelected: (bool value) {
                    setState(() {
                      data.isSelected = value;
                    });
                    value
                        ? ref
                            .read(categorySelectionProvider.notifier)
                            .addCategory(Category(
                              categoryName: null,
                              categoryID: data.categoryID,
                              uid: data.uid,
                            ))
                        : ref
                            .read(categorySelectionProvider.notifier)
                            .removeCategory(data.categoryID!);
                  },
                );
              }).toList(),
            );
    }, error: (e, st) {
      return const Center(child: Text('Something went wrong...'));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
