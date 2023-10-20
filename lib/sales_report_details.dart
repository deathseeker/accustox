import 'controllers.dart';
import 'models.dart';
import 'providers.dart';
import 'text_theme.dart';
import 'widget_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesReportDetails extends StatelessWidget {
  final String date;

  const SalesReportDetails({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
      ),
      body: SalesReportBody(date),
    );
  }
}

class SalesReportBody extends ConsumerWidget {
  const SalesReportBody(this.date, {super.key});

  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncSalesReport = ref.watch(dailySalesReportProvider(date));
    var dateTime = DateTime.parse(date);
    var dateInYMd = dateTimeController.formatDateTimeToYMd(dateTime: dateTime);

    return asyncSalesReport.when(
        data: (data) {
          var dailySalesReport = data;
          var salesOrderList = dailySalesReport.getSalesOrders();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SalesReportHeader(date: dateInYMd),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: GroupTitle(title: 'Sales Summary'),
                  ),
                  ItemSalesSummaryCard(dailySalesReport),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: GroupTitle(title: 'Sales Orders'),
                  ),
                  DailySalesReportSalesOrderList(salesOrderList: salesOrderList)
                ],
              ),
            ),
          );
        },
        error: (e, st) => const Center(
            child: ErrorMessage(errorMessage: 'Something went wrong...')),
        loading: () => const Center(child: LoadingWidget()));
  }
}

class SalesReportHeader extends StatelessWidget {
  const SalesReportHeader({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sales Report for $date',
          style: customTextStyle.headlineMedium,
        )
      ],
    );
  }
}

class DailySalesReportSalesOrderList extends StatelessWidget {
  const DailySalesReportSalesOrderList(
      {super.key, required this.salesOrderList});

  final List<SalesOrder> salesOrderList;

  @override
  Widget build(BuildContext context) {
    return salesOrderList.isEmpty
        ? const ErrorMessage(
            errorMessage: 'You currently have no outgoing inventory...')
        : ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              SalesOrder salesOrder = salesOrderList[index];
              return OutgoingInventoryCard(salesOrder: salesOrder);
            },
            itemCount: salesOrderList.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 8.0,
            ),
          );
  }
}
