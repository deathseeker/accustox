import 'package:accustox/controllers.dart';
import 'package:accustox/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                onPressed: () =>
                    navigationController.navigateToNewPurchaseOrder(),
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

class IncomingInventoryList extends ConsumerWidget {
  const IncomingInventoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncIncomingInventoryList =
        ref.watch(asyncIncomingInventoryDataListProvider);

    return asyncIncomingInventoryList.when(
        data: (incomingInventoryList) {
          return incomingInventoryList.isEmpty
              ? const Expanded(
                  child: ErrorMessage(
                      errorMessage:
                          'You have no purchase orders under this category...'),
                )
              : Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      IncomingInventoryData data = incomingInventoryList[index];
                      return IncomingInventoryCard(
                        purchaseOrder: data.purchaseOrder,
                        incomingInventoryState: data.incomingInventoryState,
                      );
                    },
                    itemCount: incomingInventoryList.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8.0,
                    ),
                  ),
                );
        },
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}
