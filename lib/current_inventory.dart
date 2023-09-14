import 'package:flutter/material.dart';
import 'enumerated_values.dart';
import 'models.dart';
import 'widget_components.dart';

class CurrentInventory extends StatelessWidget {
  const CurrentInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: GroupTitle(title: 'Current Inventory'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CurrentInventoryFilterChips(),
            ),
            Expanded(child: CurrentInventoryList())
          ],
        ));
  }
}

class CurrentInventoryList extends StatelessWidget {
  const CurrentInventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    List<CurrentInventoryItemData> currentInventoryItemList = [
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.inStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.lowStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.outOfStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.inStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.lowStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.outOfStock), CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.inStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.lowStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.outOfStock), CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.inStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.lowStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.outOfStock), CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.inStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.lowStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.outOfStock), CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.inStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.lowStock),
      CurrentInventoryItemData(
          'Sample Item', 'SAM-123-ABC-456', 12345, StockLevelState.outOfStock),
    ];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3.0),
      itemBuilder: (context, index) {
        CurrentInventoryItemData data = currentInventoryItemList[index];
        return CurrentInventoryItemCard(
            itemName: data.itemName,
            sku: data.sku,
            stockLevel: data.stockLevel,
            stockLevelState: data.stockLevelState);
      },
      itemCount: currentInventoryItemList.length,
    );
  }
}
