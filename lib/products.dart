import 'package:flutter/material.dart';
import 'default_values.dart';
import 'models.dart';
import 'widget_components.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ProductFilterChips(filters: ['All']),
          ),
          ItemGrid(itemList: [
            ItemCardData('Item Name Item Name Item Name Item Name Item Name',
                'SAM-123-ABC-456', defaultMerchantImageUrl),
            ItemCardData(
                'Item Name', 'SAM-123-ABC-456', defaultMerchantImageUrl),
            ItemCardData(
                'Item Name', 'SAM-123-ABC-456', defaultMerchantImageUrl),
            ItemCardData(
                'Item Name', 'SAM-123-ABC-456', defaultMerchantImageUrl),
            ItemCardData(
                'Item Name', 'SAM-123-ABC-456', defaultMerchantImageUrl),
            ItemCardData(
                'Item Name', 'SAM-123-ABC-456', defaultMerchantImageUrl),
          ])
        ],
      ),
    );
  }
}

class ItemGrid extends StatelessWidget {
  const ItemGrid({super.key, required this.itemList});

  final List<ItemCardData> itemList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3),
      itemBuilder: (context, index) {
        ItemCardData data = itemList[index];
      },
      itemCount: itemList.length,
    );
  }
}
