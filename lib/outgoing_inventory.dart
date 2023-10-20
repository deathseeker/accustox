import 'providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'widget_components.dart';

class OutgoingInventory extends StatelessWidget {
  const OutgoingInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: GroupTitle(
              title: 'Outgoing Inventory',
            ),
          ),
/*          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: OutgoingInventoryFilterChips(),
          ),*/
          OutgoingInventoryList()
        ],
      ),
    );
  }
}

class OutgoingInventoryList extends ConsumerWidget {
  const OutgoingInventoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncSalesOrderList = ref.watch(streamCurrentSalesOrderProvider);

    return asyncSalesOrderList.when(
        data: (data) {
          var salesOrderList = data;
          return salesOrderList.isEmpty
              ? const Expanded(
                  child: ErrorMessage(
                      errorMessage:
                          'You currently have no outgoing inventory...'),
                )
              : Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      SalesOrder salesOrder = salesOrderList[index];
                      return OutgoingInventoryCard(salesOrder: salesOrder);
                    },
                    itemCount: salesOrderList.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8.0,
                    ),
                  ),
                );
        },
        error: (e, st) => const Expanded(
            child: ErrorMessage(errorMessage: 'Something went wrong...')),
        loading: () => const Expanded(child: LoadingWidget()));
  }
}


