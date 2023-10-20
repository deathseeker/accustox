import 'providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'widget_components.dart';

class ItemInventoryManagement extends ConsumerWidget {
  const ItemInventoryManagement({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncStockList = ref.watch(streamStockListProvider(item.itemID!));

    return asyncStockList.when(
        data: (data) {
          var inventoryStockList =
              data.where((stock) => stock.forRetailSale == false).toList();
          var retailStockList =
              data.where((stock) => stock.forRetailSale == true).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: GroupTitle(title: 'Retail Stock'),
                ),
                RetailInventoryList(retailStockList),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: GroupTitle(title: 'Inventory Stock'),
                ),
                InventoryList(inventoryStockList),
              ],
            ),
          );
        },
        error: (e, st) {
          debugPrint(e.toString());
          debugPrint(st.toString());
          return const ErrorMessage(errorMessage: 'Something went wrong...');
        },
        loading: () => const LoadingWidget());
  }
}

class InventoryList extends StatelessWidget {
  final List<Stock> stockList;

  const InventoryList(this.stockList, {super.key});

  @override
  Widget build(BuildContext context) {
    return stockList.isNotEmpty
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 56.0),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Stock data = stockList[index];

              return ItemInventoryCard(
                stock: data,
              );
            },
            itemCount: stockList.length,
          )
        : const ErrorMessage(
            errorMessage: 'You currently have no stock under this category...');
  }
}

class RetailInventoryList extends StatelessWidget {
  final List<Stock> stockList;

  const RetailInventoryList(this.stockList, {super.key});

  @override
  Widget build(BuildContext context) {
    return stockList.isNotEmpty
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Stock data = stockList[index];

              return RetailItemInventoryCard(
                stock: data,
              );
            },
            itemCount: stockList.length,
          )
        : const ErrorMessage(
            errorMessage:
                'You currently have no stock available for retail sale...');
  }
}
