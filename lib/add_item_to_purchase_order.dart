import 'package:accustox/controllers.dart';
import 'package:accustox/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';
import 'widget_components.dart';

class AddItemToPurchaseOrder extends StatelessWidget {
  const AddItemToPurchaseOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item Order'),
      ),
      body: const PurchaseOrderItemGrid(),
    );
  }
}

class PurchaseOrderItemGrid extends ConsumerWidget {
  const PurchaseOrderItemGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncItemList = ref.watch(streamItemListProvider);

    return asyncItemList.when(
        data: (data) {
          var list = data;

          list.sort((a, b) =>
              a.itemName!.toLowerCase().compareTo(b.itemName!.toLowerCase()));

          return list.isEmpty
              ? const ErrorMessage(
                  errorMessage: 'There are no items listed yet...')
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            childAspectRatio: 3),
                    itemBuilder: (context, index) {
                      Item data = list[index];
                      return GestureDetector(
                        onTap: () =>
                            dialogController.addPurchaseItemOrderDialog(
                                context: context, item: data, ref: ref),
                        child: PurchaseOrderItemCard(
                          item: data,
                        ),
                      );
                    },
                    itemCount: list.length,
                  ),
                );
        },
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...}'),
        loading: () => const LoadingWidget());
  }
}
