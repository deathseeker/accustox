import 'package:flutter/material.dart';
import 'widget_components.dart';
import 'models.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [InventorySummaryDashboard()],
        ),
      ),
    );
  }
}

class InventorySummaryDashboard extends StatelessWidget {
  const InventorySummaryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<DashboardData> inventorySummaryList = [
      DashboardData('Total Inventory Value (in Php)', '999999999'),
      DashboardData('Total Inventory Quantity (in Units)', '999999999'),
      DashboardData('Out of Stock (in SKUs)', '999999999'),
      DashboardData('Low Stock (in SKUs)', '999999999'),
      DashboardData('Expired Stock (in SKUs)', '999999999'),
    ];

    List<DashboardData> inventoryMetricsList = [
      DashboardData('Inventory Turnover Rate', '9.99'),
      DashboardData('Cost of Goods Sold (in Php)', '999999999'),
      DashboardData('Days of Inventory on Hand (DOH)', '999999999'),
      DashboardData('Stock to Sales Ratio', '999999999'),
      DashboardData('Sell Through Rate', '999999999'),
      DashboardData('Back Order Rate', '999999999'),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: GroupTitle(title: 'InventorySummary'),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 3.0),
          itemBuilder: (context, index) {
            DashboardData data = inventorySummaryList[index];
            return DashboardCard(label: data.label, content: data.content);
          },
          itemCount: inventorySummaryList.length,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 0.0),
          child: GroupTitleWithPeriodMenu(title: 'Inventory Metrics'),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 3.0),
          itemBuilder: (context, index) {
            DashboardData data = inventoryMetricsList[index];
            return DashboardCard(label: data.label, content: data.content);
          },
          itemCount: inventorySummaryList.length,
        ),
      ],
    );
  }
}
