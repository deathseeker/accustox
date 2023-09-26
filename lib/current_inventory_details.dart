import 'package:accustox/controllers.dart';
import 'package:accustox/inventory_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'default_values.dart';
import 'item_dashboard.dart';
import 'item_inventory_management.dart';
import 'item_supplier_management.dart';
import 'models.dart';
import 'providers.dart';
import 'widget_components.dart';

class CurrentInventoryDetails extends StatelessWidget {
  const CurrentInventoryDetails(
      {super.key, required this.currentInventoryData});

  final CurrentInventoryData currentInventoryData;

  @override
  Widget build(BuildContext context) {
    Item item = Item.fromMap(currentInventoryData.inventory.item!);
    Inventory inventory = currentInventoryData.inventory!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          floatingActionButton: AddStockFAB(inventory),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text('Current Inventory'),
            bottom: const TabBar(tabs: [
              Tab(
                text: 'Dashboard',
              ),
              Tab(
                text: 'Inventory Management',
              ),
              Tab(
                text: 'Inventory History',
              )
            ]),
          ),
          body: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
                  child: TabBarView(children: [
                    ItemDashboard(
                      currentInventoryData: currentInventoryData,
                    ),
                    ItemInventoryManagement(
                      item: item,
                    ),
                    InventoryHistory(inventory: inventory)
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}

class AddStockFAB extends ConsumerWidget {
  const AddStockFAB(this.inventory, {super.key});

  final Inventory inventory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FloatingActionButton.extended(
      onPressed: user == null
          ? null
          : () =>
              navigationController.navigateToAddInventory(inventory: inventory),
      label: const Text('Add Stock'),
      icon: const Icon(Icons.add_box_outlined),
    );
  }
}
