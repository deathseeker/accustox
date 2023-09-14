import 'package:flutter/material.dart';
import 'default_values.dart';
import 'item_dashboard.dart';
import 'item_inventory_management.dart';
import 'item_supplier_management.dart';
import 'models.dart';
import 'widget_components.dart';

class CurrentInventoryDetails extends StatelessWidget {
  const CurrentInventoryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    ItemDetailsData itemDetailsData = ItemDetailsData(
        defaultMerchantImageUrl,
        'Sample Item',
        'SAM-123-ABC-456',
        '123456789-12',
        '123456789012',
        'Sample Manufacturer',
        'Sample Brand',
        'Philippines',
        'Sample Product Type',
        'Sample Unit',
        '123456789012');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                text: 'Supplier Management',
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
                      itemDetailsData: itemDetailsData,
                    ),
                    const ItemInventoryManagement(),
                    const ItemSupplierManagement()
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}
