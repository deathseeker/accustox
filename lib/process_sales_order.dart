// ignore_for_file: library_private_types_in_public_api
import 'controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'enumerated_values.dart';
import 'providers.dart';
import 'widget_components.dart';
import 'color_scheme.dart';
import 'models.dart';
import 'text_theme.dart';

class ProcessSalesOrder extends ConsumerStatefulWidget {
  const ProcessSalesOrder({super.key});

  @override
  _ProcessSalesOrderState createState() => _ProcessSalesOrderState();
}

class _ProcessSalesOrderState extends ConsumerState<ProcessSalesOrder> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var salesOrderItemList = ref.watch(salesOrderCartNotifierProvider);
    var totalCost =
        ref.watch(salesOrderCartNotifierProvider.notifier).getTotalCost();
    var saleType = ref.watch(saleTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Sales Order'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: SaleTypeDropDownMenu(),
              ),
              const Divider(),
              SaleTypeBody(
                saleType: saleType,
                totalCost: totalCost,
                salesOrderItemList: salesOrderItemList,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SaleTypeBody extends StatelessWidget {
  const SaleTypeBody({
    super.key,
    required this.saleType,
    required this.totalCost,
    required this.salesOrderItemList,
  });

  final SaleType saleType;
  final double totalCost;
  final List<SalesOrderItem> salesOrderItemList;

  @override
  Widget build(BuildContext context) {
    Widget? saleTypeBody;

    switch (saleType) {
      case SaleType.retail:
        saleTypeBody = RetailBody(
            totalCost: totalCost, salesOrderItemList: salesOrderItemList);
        break;
      case SaleType.account:
        saleTypeBody = AccountBody(
            totalCost: totalCost, salesOrderItemList: salesOrderItemList);
        break;
    }

    return saleTypeBody;
  }
}

class RetailBody extends StatelessWidget {
  const RetailBody(
      {super.key, required this.totalCost, required this.salesOrderItemList});

  final double totalCost;
  final List<SalesOrderItem> salesOrderItemList;

  @override
  Widget build(BuildContext context) {
    var paymentTerms = PaymentTerm.cash.label;
    var formattedTotalCost =
        currencyController.formatAsPhilippineCurrency(amount: totalCost);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: GroupTitle(title: 'Items'),
        ),
        SalesOrderItemListCard(
            totalCost: formattedTotalCost,
            salesOrderItemList: salesOrderItemList),
        ButtonBar(
          children: [
            OutlinedButton(
                onPressed: () => navigationController.navigateToPreviousPage(),
                child: const Text('Cancel')),
            Consumer(builder: (context, ref, child) {
              var user = ref.watch(userProvider);
              var stockList = ref.watch(adjustedStockListNotifierProvider);
              return FilledButton(
                  onPressed: user == null
                      ? null
                      : () => salesOrderController.submitRetailSalesOrder(
                          uid: user.uid,
                          salesOrderItemList: salesOrderItemList,
                          paymentTerms: paymentTerms,
                          orderTotal: totalCost.toString(),
                          stockList: stockList),
                  child: const Text('Create Order'));
            })
          ],
        )
      ],
    );
  }
}

class SalesOrderItemListCard extends StatelessWidget {
  const SalesOrderItemListCard(
      {super.key, required this.totalCost, required this.salesOrderItemList});

  final String totalCost;
  final List<SalesOrderItem> salesOrderItemList;

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

class AccountBody extends ConsumerStatefulWidget {
  const AccountBody(
      {super.key, required this.totalCost, required this.salesOrderItemList});

  final double totalCost;
  final List<SalesOrderItem> salesOrderItemList;

  @override
  _AccountBodyState createState() => _AccountBodyState();
}

class _AccountBodyState extends ConsumerState<AccountBody> {
  late final double totalCost;
  late final List<SalesOrderItem> salesOrderItemList;

  @override
  void initState() {
    super.initState();
    totalCost = widget.totalCost;
    salesOrderItemList = widget.salesOrderItemList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var customerProvider = ref.watch(streamCustomerListProvider);
    var user = ref.watch(userProvider);
    var stockList = ref.watch(adjustedStockListNotifierProvider);
    var customerSelection = ref.watch(customerSelectionProvider);
    var paymentTermsSelection = ref.watch(paymentTermsProvider);
    var formattedTotalCost =
        currencyController.formatAsPhilippineCurrency(amount: totalCost);

    return customerProvider.when(
        data: (data) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Flexible(child: PaymentTermsDropDownMenu()),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    const Flexible(child: CustomerDropDownMenu()),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Flexible(
                        child: TextButton(
                            onPressed: () => navigationController
                                .navigateToNewCustomerAccount(),
                            child: const Text('New Customer'))),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Items'),
              ),
              SalesOrderItemListCard(
                  totalCost: formattedTotalCost,
                  salesOrderItemList: widget.salesOrderItemList),
              ButtonBar(
                children: [
                  OutlinedButton(
                      onPressed: () =>
                          navigationController.navigateToPreviousPage(),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: user == null
                          ? null
                          : () => salesOrderController
                              .reviewAndSubmitAccountSalesOrder(
                                  uid: user.uid,
                                  customer: customerSelection,
                                  salesOrderItemList: salesOrderItemList,
                                  paymentTerms: paymentTermsSelection.label,
                                  orderTotal: totalCost.toString(),
                                  stockList: stockList),
                      child: const Text('Create Order'))
                ],
              )
            ],
          );
        },
        error: (e, st) => const Center(
            child: ErrorMessage(errorMessage: 'Something went wrong...')),
        loading: () => const Center(child: LoadingWidget()));
  }
}
