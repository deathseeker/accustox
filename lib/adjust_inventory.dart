import 'package:flutter/material.dart';
import 'models.dart';
import 'widget_components.dart';

class AdjustInventory extends StatelessWidget {
  const AdjustInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Adjustment'),
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(32.0, 0, 32.0, 32.0),
        child: AdjustInventoryList(),
      ),
    );
  }
}

class AdjustInventoryList extends StatelessWidget {
  const AdjustInventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    List<ItemInventoryData> itemInventoryList = [
      ItemInventoryData(
          '999',
          'Sample Warehouse A',
          'MM/DD/YYYY',
          'ABCD12345',
          'Php 999999.99',
          'Php 999999.99',
          'MM/DD/YYYY',
          'SupplierName',
          'stockID'),
      ItemInventoryData(
          '999',
          'Sample Warehouse A',
          'MM/DD/YYYY',
          'ABCD12345',
          'Php 999999.99',
          'Php 999999.99',
          'MM/DD/YYYY',
          'SupplierName',
          'stockID'),
      ItemInventoryData(
          '999',
          'Sample Warehouse A',
          'MM/DD/YYYY',
          'ABCD12345',
          'Php 999999.99',
          'Php 999999.99',
          'MM/DD/YYYY',
          'SupplierName',
          'stockID'),
      ItemInventoryData(
          '999',
          'Sample Warehouse A',
          'MM/DD/YYYY',
          'ABCD12345',
          'Php 999999.99',
          'Php 999999.99',
          'MM/DD/YYYY',
          'SupplierName',
          'stockID'),
      ItemInventoryData(
          '999',
          'Sample Warehouse A',
          'MM/DD/YYYY',
          'ABCD12345',
          'Php 999999.99',
          'Php 999999.99',
          'MM/DD/YYYY',
          'SupplierName',
          'stockID')
    ];
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        ItemInventoryData data = itemInventoryList[index];
        return InventoryAdjustmentCard(
            stockLevel: data.stockLevel,
            stockLocation: data.stockLocation,
            expirationDate: data.expirationDate,
            batchNumber: data.batchNumber,
            costPrice: data.costPrice,
            salePrice: data.salePrice,
            purchaseDate: data.purchaseDate,
            supplierName: data.supplierName,
            onPressed: () {});
      },
      itemCount: itemInventoryList.length,
    );
  }
}
