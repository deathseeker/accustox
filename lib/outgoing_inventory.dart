import 'package:flutter/material.dart';

import 'models.dart';
import 'widget_components.dart';

class OutgoingInventory extends StatelessWidget {
  const OutgoingInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: GroupTitleWithFilledButton(
                title: 'Outgoing Inventory',
                onPressed: () {},
                buttonLabel: 'New Sales Order'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: OutgoingInventoryFilterChips(),
          ),
          const OutgoingInventoryList()
        ],
      ),
    );
  }
}

class OutgoingInventoryList extends StatelessWidget {
  const OutgoingInventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    List<OutgoingInventoryCardData> outgoingInventoryList = [
      OutgoingInventoryCardData(
          'Customer Name', 'Php 999999.99', 'SO-1234567', [
        SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456', '999 Units',
            '999999.99/Unit', 'Php 999999.99'),
        SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456', '999 Units',
            '999999.99/Unit', 'Php 999999.99'),
        SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456', '999 Units',
            '999999.99/Unit', 'Php 999999.99'),
        SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456', '999 Units',
            '999999.99/Unit', 'Php 999999.99'),
        SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456', '999 Units',
            '999999.99/Unit', 'Php 999999.99'),
      ]),
      OutgoingInventoryCardData(
          'Customer Name', 'Php 999999.99', 'SO-1234567', [
        SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456', '999 Units',
            '999999.99/Unit', 'Php 999999.99')
      ]),
      OutgoingInventoryCardData(
          'Customer Name', 'Php 999999.99', 'SO-1234567', [
        SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456', '999 Units',
            '999999.99/Unit', 'Php 999999.99')
      ]),
    ];

    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          OutgoingInventoryCardData data = outgoingInventoryList[index];
          return OutgoingInventoryCard(
              customerName: data.customerName,
              totalCost: data.totalCost,
              salesOrderNumber: data.salesOrderNumber,
              salesOrderItemList: data.salesOrderItemList);
        },
        itemCount: outgoingInventoryList.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 8.0,
        ),
      ),
    );
  }
}
