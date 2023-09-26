import 'package:accustox/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'widget_components.dart';

class ItemDashboard extends StatelessWidget {
  const ItemDashboard({super.key, required this.currentInventoryData});

  final CurrentInventoryData currentInventoryData;

  @override
  Widget build(BuildContext context) {
    var item = Item.fromMap(currentInventoryData.inventory.item!);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemDetailsCard(item: item),
          const Padding(padding: EdgeInsets.only(top: 16.0)),
          const GroupTitle(title: 'Inventory Summary'),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          InventorySummary(
            item: item,
          ),
          const GroupTitleWithPeriodMenu(title: 'Inventory Metrics'),
          const InventoryMetrics()
        ],
      ),
    );
  }
}

class InventorySummary extends ConsumerWidget {
  const InventorySummary({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncInventory = ref.watch(streamInventoryProvider(item.itemID!));

    return asyncInventory.when(
        data: (data) {
          var currentInventory = currencyController.formatAsPhilippineCurrency(
              amount: data.currentInventory!);
          var stockLevel = data.stockLevel.toString();
          var backOrder = data.backOrder.toString();
          var safetyStockLevel = data.safetyStockLevel.toString();
          var leadTime = data.averageLeadTime!.truncate().toString();
          var reorderPoint = data.reorderPoint.toString();

          List<DashboardData> inventorySummaryList = [
            DashboardData('Value (in Php)', currentInventory),
            DashboardData('Stock Level', stockLevel),
            DashboardData('Back Order', backOrder),
            DashboardData('Safety Stock Level', safetyStockLevel),
            DashboardData('Average Lead Time (in Days)', leadTime),
            DashboardData('Reorder Point', reorderPoint),
          ];

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 2.0),
            itemBuilder: (context, index) {
              DashboardData data = inventorySummaryList[index];
              return ItemDashboardCard(
                  label: data.label, content: data.content);
            },
            itemCount: inventorySummaryList.length,
          );
        },
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class InventoryMetrics extends StatelessWidget {
  const InventoryMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    List<DashboardData> inventoryMetricsList = [
      DashboardData('Stock Turnover Rate', '9.99'),
      DashboardData('COGS (in Php)', '999999999'),
      DashboardData('DOH', '999999999'),
      DashboardData('Stock to Sales Ratio', '999999999'),
      DashboardData('Sell Through Rate', '999999999'),
      DashboardData('Back Order Rate', '999999999'),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 2.0),
      itemBuilder: (context, index) {
        DashboardData data = inventoryMetricsList[index];
        return ItemDashboardCard(label: data.label, content: data.content);
      },
      itemCount: inventoryMetricsList.length,
    );
  }
}
