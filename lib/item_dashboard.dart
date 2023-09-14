import 'package:flutter/material.dart';
import 'models.dart';
import 'widget_components.dart';

class ItemDashboard extends StatelessWidget {
  const ItemDashboard({super.key, required this.itemDetailsData});

  final ItemDetailsData itemDetailsData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemDetailsCard(itemDetailsData: itemDetailsData),
          const Padding(padding: EdgeInsets.only(top: 16.0)),
          const GroupTitle(title: 'Inventory Summary'),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          const InventorySummary(),
          const GroupTitleWithPeriodMenu(title: 'Inventory Metrics'),
          const InventoryMetrics()
        ],
      ),
    );
  }
}

class InventorySummary extends StatelessWidget {
  const InventorySummary({super.key});

  @override
  Widget build(BuildContext context) {
    List<DashboardData> inventorySummaryList = [
      DashboardData('Value (in Php)', '999999999'),
      DashboardData('Stock Level', '999999999'),
      DashboardData('Reserved', '999999999'),
      DashboardData('Back Order', '999999999'),
      DashboardData('Safety Stock Level', '999999999'),
      DashboardData('Lead Time (in Days)', '999999999'),
      DashboardData('Reorder Point', '999999999'),
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
        return ItemDashboardCard(label: data.label, content: data.content);
      },
      itemCount: inventorySummaryList.length,
    );
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
