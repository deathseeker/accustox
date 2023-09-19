// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'color_scheme.dart';
import 'models.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class NewPurchaseOrder extends StatefulWidget {
  const NewPurchaseOrder({super.key});

  @override
  _NewPurchaseOrderState createState() => _NewPurchaseOrderState();
}

class _NewPurchaseOrderState extends State<NewPurchaseOrder> {
  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController deliveryAddressController =
      TextEditingController();

  final FocusNode supplierNameNode = FocusNode();
  final FocusNode deliveryAddressNode = FocusNode();

  final String estimatedTotalCost = 'Php 999999.99';
  late Supplier selectedSupplier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Supplier> supplierList = [

    ];

    final List<DropdownMenuEntry<Supplier>> supplierEntries =
        <DropdownMenuEntry<Supplier>>[];
    for (final Supplier supplier in supplierList) {
      supplierEntries.add(
        DropdownMenuEntry<Supplier>(
            value: supplier, label: supplier.supplierName),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Purchase Order'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownMenu<Supplier>(
                  width: MediaQuery.of(context).size.width/3,
                  requestFocusOnTap: false,
                  controller: supplierNameController,
                  label: const Text('Supplier'),
                  enableFilter: false,
                  enableSearch: false,
                  dropdownMenuEntries: supplierEntries,
                  onSelected: (Supplier? supplier) {
                    setState(() {
                      selectedSupplier = supplier!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GroupTitleWithTextButton(
                    title: 'Items',
                    onPressed: () {},
                    buttonLabel: 'Add Item Order'),
              ),
              NewPurchaseOrderItemListCard(
                estimatedTotalCost: estimatedTotalCost,
              ),
              ButtonBar(
                children: [
                  OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {}, child: const Text('Create Order'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NewPurchaseOrderItemListCard extends StatelessWidget {
  const NewPurchaseOrderItemListCard(
      {super.key, required this.estimatedTotalCost});

  final String estimatedTotalCost;

  @override
  Widget build(BuildContext context) {
    List<PurchaseOrderItemListTileData> purchaseOrderItemList = [
      PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
          '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
      PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
          '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
      PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
          '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
    ];

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
                'Total: $estimatedTotalCost',
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
