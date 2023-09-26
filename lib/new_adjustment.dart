// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'providers.dart';
import 'widget_components.dart';
import 'enumerated_values.dart';

class NewAdjustment extends StatelessWidget {
  const NewAdjustment({super.key, required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Adjustment'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: NewAdjustmentForm(
          stock: stock,
        ),
      )),
    );
  }
}

class NewAdjustmentForm extends StatefulWidget {
  const NewAdjustmentForm({super.key, required this.stock});

  final Stock stock;

  @override
  _NewAdjustmentFormState createState() => _NewAdjustmentFormState();
}

class _NewAdjustmentFormState extends State<NewAdjustmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockLevelAdjustmentController =
      TextEditingController();
  final TextEditingController costPriceAdjustmentController =
      TextEditingController();
  final TextEditingController salePriceAdjustmentController =
      TextEditingController();

  final FocusNode dateFocusNode = FocusNode();
  final FocusNode reasonFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode stockLevelAdjustmentFocusNode = FocusNode();
  final FocusNode costPriceAdjustmentFocusNode = FocusNode();
  final FocusNode salePriceAdjustmentFocusNode = FocusNode();

  late InventoryAdjustmentReason selectedReason;
  late AdjustmentType selectedAdjustmentType;
  late Widget selectedWidget;

  @override
  void initState() {
    super.initState();
    selectedReason = InventoryAdjustmentReason.countingErrors;
    selectedAdjustmentType = AdjustmentType.stockLevelAdjustment;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<AdjustmentType>> adjustmentTypeEntries =
        <DropdownMenuEntry<AdjustmentType>>[];
    for (final AdjustmentType adjustmentType in AdjustmentType.values) {
      adjustmentTypeEntries.add(
        DropdownMenuEntry<AdjustmentType>(
            value: adjustmentType, label: adjustmentType.label),
      );
    }
    final List<DropdownMenuEntry<InventoryAdjustmentReason>>
        adjustmentReasonEntries =
        <DropdownMenuEntry<InventoryAdjustmentReason>>[];
    for (final InventoryAdjustmentReason adjustmentReason
        in InventoryAdjustmentReason.values) {
      adjustmentReasonEntries.add(
        DropdownMenuEntry<InventoryAdjustmentReason>(
            value: adjustmentReason, label: adjustmentReason.label),
      );
    }

    switch (selectedAdjustmentType) {
      case AdjustmentType.stockLevelAdjustment:
        selectedWidget = StockLevelAdjustmentForm(stock: widget.stock);
        break;
      case AdjustmentType.costPriceAdjustment:
        selectedWidget = CostPriceAdjustmentForm(stock: widget.stock);
        break;
      case AdjustmentType.salePriceAdjustment:
        selectedWidget = SalePriceAdjustmentForm(stock: widget.stock);
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownMenu<AdjustmentType>(
            requestFocusOnTap: false,
            initialSelection: AdjustmentType.stockLevelAdjustment,
            label: const Text('Adjustment Type'),
            enableFilter: false,
            enableSearch: false,
            dropdownMenuEntries: adjustmentTypeEntries,
            onSelected: (AdjustmentType? adjustmentType) {
              setState(() {
                selectedAdjustmentType = adjustmentType!;
              });
            },
          ),
        ),
        selectedWidget
      ],
    );
  }
}

class StockLevelAdjustmentForm extends ConsumerStatefulWidget {
  const StockLevelAdjustmentForm({super.key, required this.stock});

  final Stock stock;

  @override
  _StockLevelAdjustmentFormState createState() =>
      _StockLevelAdjustmentFormState();
}

class _StockLevelAdjustmentFormState
    extends ConsumerState<StockLevelAdjustmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockLevelAdjustmentController =
      TextEditingController();

  late InventoryAdjustmentReason selectedReason;

  @override
  void initState() {
    super.initState();
    selectedReason = InventoryAdjustmentReason.countingErrors;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
    stockLevelAdjustmentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);

    final List<DropdownMenuEntry<InventoryAdjustmentReason>>
        adjustmentReasonEntries =
        <DropdownMenuEntry<InventoryAdjustmentReason>>[];
    for (final InventoryAdjustmentReason adjustmentReason
        in InventoryAdjustmentReason.values) {
      adjustmentReasonEntries.add(
        DropdownMenuEntry<InventoryAdjustmentReason>(
            value: adjustmentReason, label: adjustmentReason.label),
      );
    }

    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownMenu<InventoryAdjustmentReason>(
                requestFocusOnTap: false,
                initialSelection: InventoryAdjustmentReason.countingErrors,
                label: const Text('Reason'),
                enableFilter: false,
                enableSearch: false,
                dropdownMenuEntries: adjustmentReasonEntries,
                onSelected: (InventoryAdjustmentReason? adjustmentReason) {
                  setState(() {
                    selectedReason = adjustmentReason!;
                  });
                },
              ),
            ),
            /*    Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description (Optional)'),
                    ),
                  ),
                ),
              ],
            ),*/
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdjustmentDashboardCard(
                    label: 'Current Stock Level',
                    data: widget.stock.stockLevel.toString()),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: stockLevelAdjustmentController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adjusted Stock Level'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the adjusted Stock Level';
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
                        : () => inventoryController.reviewAndAdjustStockLevel(
                            formKey: _formKey,
                            uid: user.uid,
                            stock: widget.stock,
                            adjustedStockLevel:
                                stockLevelAdjustmentController.text,
                            reason: selectedReason.label),
                    child: const Text('Adjust Stock Level'))
              ],
            )
          ],
        ));
  }
}

class CostPriceAdjustmentForm extends StatefulWidget {
  const CostPriceAdjustmentForm({super.key, required this.stock});

  final Stock stock;

  @override
  _CostPriceAdjustmentFormState createState() =>
      _CostPriceAdjustmentFormState();
}

class _CostPriceAdjustmentFormState extends State<CostPriceAdjustmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costPriceAdjustmentController =
      TextEditingController();

  late InventoryAdjustmentReason selectedReason;

  @override
  void initState() {
    super.initState();
    selectedReason = InventoryAdjustmentReason.countingErrors;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
    costPriceAdjustmentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentCostPrice = currencyController.formatAsPhilippineCurrency(
        amount: widget.stock.costPrice!);

    final List<DropdownMenuEntry<InventoryAdjustmentReason>>
        adjustmentReasonEntries =
        <DropdownMenuEntry<InventoryAdjustmentReason>>[];
    for (final InventoryAdjustmentReason adjustmentReason
        in InventoryAdjustmentReason.values) {
      adjustmentReasonEntries.add(
        DropdownMenuEntry<InventoryAdjustmentReason>(
            value: adjustmentReason, label: adjustmentReason.label),
      );
    }

    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownMenu<InventoryAdjustmentReason>(
                requestFocusOnTap: false,
                initialSelection: InventoryAdjustmentReason.countingErrors,
                label: const Text('Reason'),
                enableFilter: false,
                enableSearch: false,
                dropdownMenuEntries: adjustmentReasonEntries,
                onSelected: (InventoryAdjustmentReason? adjustmentReason) {
                  setState(() {
                    selectedReason = adjustmentReason!;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description (Optional)'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                AdjustmentDashboardCard(
                    label: 'Current Cost Price', data: currentCostPrice),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextFormField(
                      controller: costPriceAdjustmentController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adjusted Cost Price'),
                      keyboardType: TextInputType.number,
                      // You can specify the keyboard type
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a cost price adjustment';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class SalePriceAdjustmentForm extends StatefulWidget {
  const SalePriceAdjustmentForm({super.key, required this.stock});

  final Stock stock;

  @override
  _SalePriceAdjustmentFormState createState() =>
      _SalePriceAdjustmentFormState();
}

class _SalePriceAdjustmentFormState extends State<SalePriceAdjustmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController salePriceAdjustmentController =
      TextEditingController();

  late InventoryAdjustmentReason selectedReason;

  @override
  void initState() {
    super.initState();
    selectedReason = InventoryAdjustmentReason.countingErrors;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descriptionController.dispose();
    salePriceAdjustmentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentSalePrice = currencyController.formatAsPhilippineCurrency(
        amount: widget.stock.salePrice!);

    final List<DropdownMenuEntry<InventoryAdjustmentReason>>
        adjustmentReasonEntries =
        <DropdownMenuEntry<InventoryAdjustmentReason>>[];
    for (final InventoryAdjustmentReason adjustmentReason
        in InventoryAdjustmentReason.values) {
      adjustmentReasonEntries.add(
        DropdownMenuEntry<InventoryAdjustmentReason>(
            value: adjustmentReason, label: adjustmentReason.label),
      );
    }

    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownMenu<InventoryAdjustmentReason>(
                requestFocusOnTap: false,
                initialSelection: InventoryAdjustmentReason.countingErrors,
                label: const Text('Reason'),
                enableFilter: false,
                enableSearch: false,
                dropdownMenuEntries: adjustmentReasonEntries,
                onSelected: (InventoryAdjustmentReason? adjustmentReason) {
                  setState(() {
                    selectedReason = adjustmentReason!;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description (Optional)'),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                AdjustmentDashboardCard(
                    label: 'Current Sale Price', data: currentSalePrice),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextFormField(
                      controller: salePriceAdjustmentController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adjusted Sale Price'),
                      keyboardType: TextInputType.number,
                      // You can specify the keyboard type
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a sale price adjustment';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

/*const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: GroupTitle(title: 'Quantity'),
          ),
          Row(
            children: [
              AdjustmentDashboardCard(
                  label: 'Current Stock Level',
                  data: widget.stock.stockLevel.toString()),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: stockLevelAdjustmentController,
                    focusNode: stockLevelAdjustmentFocusNode,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adjusted Stock Level'),
                    keyboardType: TextInputType.number,
                    // You can specify the keyboard type
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the adjusted Stock Level';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              */ /*const AdjustmentDashboardCard(
                  label: 'Adjusted Stock Level', data: '999'),*/ /*
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: GroupTitle(title: 'Value'),
          ),
          Row(
            children: [
              AdjustmentDashboardCard(
                  label: 'Current Cost Price', data: currentCostPrice),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: costPriceAdjustmentController,
                    focusNode: costPriceAdjustmentFocusNode,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adjusted Cost Price'),
                    keyboardType: TextInputType.number,
                    // You can specify the keyboard type
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a cost price adjustment';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              */ /*const AdjustmentDashboardCard(
                  label: 'Adjusted Cost Price', data: 'Php 999'),*/ /*
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 16.0)),
          Row(
            children: [
              AdjustmentDashboardCard(
                  label: 'Current Sale Price', data: currentSalePrice),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: salePriceAdjustmentController,
                    focusNode: salePriceAdjustmentFocusNode,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adjusted Sale Price'),
                    keyboardType: TextInputType.number,
                    // You can specify the keyboard type
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a sale price adjustment';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              */ /*const AdjustmentDashboardCard(
                  label: 'Adjusted Cost Price', data: 'Php 999'),*/ /*
            ],
          ),
          ButtonBar(
            children: [
              OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
              FilledButton(
                  onPressed: () {}, child: const Text('Save Adjustments'))
            ],
          )*/
