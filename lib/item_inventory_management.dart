import 'package:accustox/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'widget_components.dart';

class ItemInventoryManagement extends StatelessWidget {
  const ItemInventoryManagement({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return InventoryList(item);
  }
}

class InventoryList extends ConsumerWidget {
  const InventoryList(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncStockList = ref.watch(streamStockListProvider(item.itemID!));

    return asyncStockList.when(
        data: (data) {
          var stockList = data;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 56.0),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Stock data = stockList[index];
              return ItemInventoryCard(
                stock: data,
              );
            },
            itemCount: stockList.length,
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
