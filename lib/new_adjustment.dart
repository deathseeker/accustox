// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widget_components.dart';

import 'enumerated_values.dart';

class NewAdjustment extends StatelessWidget {
  const NewAdjustment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Adjustment'),
      ),
      body: const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: NewAdjustmentForm(),
      )),
    );
  }
}

class NewAdjustmentForm extends StatefulWidget {
  const NewAdjustmentForm({super.key});

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

  late DateTime selectedDate;

  InventoryAdjustmentReason selectedReason =
      InventoryAdjustmentReason.shrinkageTheft;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
        dateController.text = formattedDate;
      });
    }
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownMenu<InventoryAdjustmentReason>(
            requestFocusOnTap: false,
            controller: reasonController,
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
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                child: TextFormField(
                  controller: descriptionController,
                  focusNode: descriptionFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: GroupTitle(title: 'Quantity'),
        ),
        Row(
          children: [
            const AdjustmentDashboardCard(
                label: 'Current Stock Level', data: '999'),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: stockLevelAdjustmentController,
                  focusNode: stockLevelAdjustmentFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Stock Level Adjustment'),
                  keyboardType: TextInputType.number,
                  // You can specify the keyboard type
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a stock level adjustment';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const AdjustmentDashboardCard(
                label: 'Adjusted Stock Level', data: '999'),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: GroupTitle(title: 'Value'),
        ),
        Row(
          children: [
            const AdjustmentDashboardCard(
                label: 'Current Cost Price', data: 'Php 999'),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: costPriceAdjustmentController,
                  focusNode: costPriceAdjustmentFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cost Price Adjustment'),
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
            const AdjustmentDashboardCard(
                label: 'Adjusted Cost Price', data: 'Php 999'),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 16.0)),
        Row(
          children: [
            const AdjustmentDashboardCard(
                label: 'Current Sale Price', data: 'Php 999'),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: salePriceAdjustmentController,
                  focusNode: salePriceAdjustmentFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sale Price Adjustment'),
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
            const AdjustmentDashboardCard(
                label: 'Adjusted Cost Price', data: 'Php 999'),
          ],
        ),
        ButtonBar(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
            FilledButton(
                onPressed: () {}, child: const Text('Save Adjustments'))
          ],
        )
      ],
    );
  }
}
