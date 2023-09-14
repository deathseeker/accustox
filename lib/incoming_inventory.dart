import 'package:flutter/material.dart';
import 'enumerated_values.dart';
import 'models.dart';

import 'widget_components.dart';

class IncomingInventory extends StatelessWidget {
  const IncomingInventory({super.key});

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
                title: 'Incoming Inventory',
                onPressed: () {},
                buttonLabel: 'New Purchase Order'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: IncomingInventoryFilterChips(),
          ),
          const IncomingInventoryList()
        ],
      ),
    );
  }
}

class IncomingInventoryList extends StatelessWidget {
  const IncomingInventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    List<IncomingInventoryCardData> incomingInventoryList = [
      IncomingInventoryCardData(
          'SupplierName',
          'PO-1234678',
          'Php 999999.99',
          'Delivery Address',
          'DD/MM/YYYY',
          [
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
          ],
          IncomingInventoryState.forPlacement),
      IncomingInventoryCardData(
          'SupplierName',
          'PO-1234678',
          'Php 999999.99',
          'Purok Cebuano, Poblacion, Malungon, Sarangani Province, Mindanao, Philippines',
          'DD/MM/YYYY',
          [
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
          ],
          IncomingInventoryState.forDelivery),
      IncomingInventoryCardData(
          'SupplierName',
          'PO-1234678',
          'Php 999999.99',
          'Purok Cebuano, Poblacion, Malungon, Sarangani Province, Mindanao, Philippines',
          'DD/MM/YYYY',
          [
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
            PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
                '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
          ],
          IncomingInventoryState.forConfirmation),
    ];

    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          IncomingInventoryCardData data = incomingInventoryList[index];
          return IncomingInventoryCard(
            supplierName: data.supplierName,
            purchaseOrderNumber: data.purchaseOrderNumber,
            estimatedTotalCost: data.estimatedTotalCost,
            deliveryAddress: data.deliveryAddress,
            expectedDeliveryDate: data.expectedDeliveryDate,
            purchaseOrderItemList: data.purchaseOrderItemList,
            incomingInventoryState: data.incomingInventoryState,
          );
        },
        itemCount: incomingInventoryList.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 8.0,
        ),
      ),
    );
  }
}
