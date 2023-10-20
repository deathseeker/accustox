import 'package:accustox/controllers.dart';

import 'providers.dart';
import 'widget_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'package:flutter/material.dart';

class IncomingInventoryManagement extends StatelessWidget {
  const IncomingInventoryManagement({super.key, required this.purchaseOrder});

  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Incoming Inventory Management'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: IncomingInventoryListManagement(purchaseOrder),
        ));
  }
}

class IncomingInventoryListManagement extends ConsumerWidget {
  const IncomingInventoryListManagement(this.purchaseOrder, {super.key});

  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncPurchaseOrder =
        ref.watch(streamPurchaseOrderProvider(purchaseOrder.purchaseOrderID!));
    var user = ref.watch(userProvider);

    return asyncPurchaseOrder.when(
        data: (data) {
          var itemOrderList = data.getPurchaseOrderItemList();
          var inventoryComplete = data.inventoryComplete();

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  PurchaseOrderItem purchaseOrderItem = itemOrderList[index];
                  return PurchaseOrderItemManagementCard(
                      purchaseOrderItem: purchaseOrderItem,
                      purchaseOrder: purchaseOrder);
                },
                itemCount: itemOrderList.length,
              ),
              ButtonBar(
                children: [
                  FilledButton(
                      onPressed: inventoryComplete && user != null
                          ? () {
                              snackBarController.showLoadingSnackBar(
                                  message: 'Completing inventory...');
                              purchaseOrderController
                                  .completeInventoryAndPurchaseOrder(
                                      uid: user.uid,
                                      purchaseOrder: purchaseOrder)
                                  .whenComplete(() {
                                snackBarController.hideCurrentSnackBar();
                                navigationController.navigateToPreviousPage();
                                snackBarController.showSnackBar(
                                    'Inventory completed successfully...');
                              });
                            }
                          : null,
                      child: const Text('Inventory Complete'))
                ],
              )
            ],
          );
        },
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}
