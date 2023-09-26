import 'package:accustox/providers.dart';
import 'package:accustox/widget_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';

class InventoryHistory extends StatelessWidget {
  const InventoryHistory({super.key, required this.inventory});

  final Inventory inventory;

  @override
  Widget build(BuildContext context) {
    return InventoryHistoryBody(inventory);
  }
}

class InventoryHistoryBody extends ConsumerWidget {
  const InventoryHistoryBody(this.inventory, {super.key});

  final Inventory inventory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncTransactionList =
        ref.watch(streamTransactionListProvider(inventory));

    return asyncTransactionList.when(
        data: (data) {
          return data.isEmpty
              ? const ErrorMessage(
                  errorMessage: 'You currently have no listed transactions...')
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 56.0),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    InventoryTransaction inventoryTransaction = data[index];

                    return InventoryTransactionCard(inventoryTransaction: inventoryTransaction);
                  },
                  itemCount: data.length,
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
