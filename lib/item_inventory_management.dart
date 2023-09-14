import 'package:flutter/material.dart';
import 'models.dart';
import 'widget_components.dart';

class ItemInventoryManagement extends StatelessWidget {
  const ItemInventoryManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupTitleWithTextButton(
              title: 'Inventory',
              onPressed: () {},
              buttonLabel: 'Adjust Inventory'),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          const InventoryList()
        ],
      ),
    );
  }
}

class InventoryList extends StatelessWidget {
  const InventoryList({super.key});

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
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        ItemInventoryData data = itemInventoryList[index];
        return ItemInventoryCard(
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
