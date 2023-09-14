import 'package:flutter/material.dart';
import 'models.dart';
import 'color_scheme.dart';
import 'enumerated_values.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class SalesOrderDetails extends StatelessWidget {
  const SalesOrderDetails(
      {super.key,
      required this.salesOrderNumber,
      required this.customerName,
      required this.contactPerson,
      required this.email,
      required this.contactNumber,
      required this.address,
      required this.totalCost,
      required this.salesOrderItemList,
      required this.salesOrderState});

  final String salesOrderNumber;
  final String customerName;
  final String contactPerson;
  final String email;
  final String contactNumber;
  final String address;
  final String totalCost;
  final List<SalesOrderItemListTileData> salesOrderItemList;
  final SalesOrderState salesOrderState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Order Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadlineSmall(headline: salesOrderNumber),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Customer Detail'),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomerDetailCard(
                        customerName: customerName,
                        contactNumber: contactNumber,
                        contactPerson: contactPerson,
                        email: email,
                        address: address),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: GroupTitle(title: 'Order Status'),
              ),
              SalesOrderStatusFilterChips(
                salesOrderState: salesOrderState,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Order Details'),
              ),
              SalesOrderDetailsItemListCard(
                  totalCost: totalCost, salesOrderItemList: salesOrderItemList),
              ButtonBar(
                children: [
                  OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {}, child: const Text('Release Order'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SalesOrderDetailsItemListCard extends StatelessWidget {
  const SalesOrderDetailsItemListCard(
      {super.key, required this.totalCost, required this.salesOrderItemList});

  final String totalCost;
  final List<SalesOrderItemListTileData> salesOrderItemList;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SalesOrderItemListHeader(),
            SalesOrderItemList(salesOrderItemList: salesOrderItemList),
            const Divider(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Total: $totalCost',
                style: customTextStyle.titleMedium
                    .copyWith(color: lightColorScheme.onSurface),
              ),
            )
          ],
        ),
      ),
    );
  }
}
