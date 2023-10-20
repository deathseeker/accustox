import 'providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'color_scheme.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class SalesOrderDetails extends StatelessWidget {
  final String salesOrderID;

  const SalesOrderDetails({super.key, required this.salesOrderID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Order Details'),
      ),
      body: SalesOrderDetailsBody(salesOrderID),
    );
  }
}

class SalesOrderDetailsBody extends ConsumerWidget {
  const SalesOrderDetailsBody(this.salesOrderID, {super.key});

  final String salesOrderID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var salesOrder = ref.watch(salesOrderProvider(salesOrderID));

    return salesOrder.when(
        data: (data) {
          var salesOrder = data;
          var customer = Customer.fromMap(salesOrder.customer);
          var amount = double.tryParse(salesOrder.orderTotal!);
          var totalCost =
              currencyController.formatAsPhilippineCurrency(amount: amount!);
          var salesOrderItemList = salesOrder.getSalesOrderItemList();
          var transactionMadeOn = dateTimeController.formatDateTimeToYMdjm(
              dateTime: salesOrder.transactionMadeOn!);
          var paymentTerms = salesOrder.paymentTerms!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadlineSmall(headline: salesOrder.salesOrderNumber!),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: GroupTitle(title: 'Customer Detail'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomerDetailCard(
                            customerName: customer.customerName,
                            contactNumber: customer.contactNumber,
                            contactPerson: customer.contactPerson,
                            email: customer.email,
                            address: customer.address),
                      ),
                    ],
                  ),
/*              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: GroupTitle(title: 'Order Status'),
              ),
              SalesOrderStatusFilterChips(
                salesOrderState: salesOrderState,
              ),*/
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: GroupTitle(title: 'Order Details'),
                  ),
                  SalesOrderDetailsItemListCard(
                    totalCost: totalCost,
                    salesOrderItemList: salesOrderItemList,
                    transactionMadeOn: transactionMadeOn,
                    paymentTerms: paymentTerms,
                  ),
/*              ButtonBar(
                children: [
                  OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {}, child: const Text('Release Order'))
                ],
              )*/
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

class SalesOrderDetailsItemListCard extends StatelessWidget {
  const SalesOrderDetailsItemListCard(
      {super.key,
      required this.totalCost,
      required this.salesOrderItemList,
      required this.transactionMadeOn,
      required this.paymentTerms});

  final String totalCost;
  final List<SalesOrderItem> salesOrderItemList;
  final String transactionMadeOn;
  final String paymentTerms;

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
            Row(
              children: [
            InformationWithLabel(
                label: 'Transaction Made On', data: transactionMadeOn),
            const Padding(padding: EdgeInsets.only(left: 16.0)),
            InformationWithLabel(label: 'PaymentTerms', data: paymentTerms)
              ],
            ),
            const Divider(),
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
