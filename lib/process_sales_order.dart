// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'enumerated_values.dart';
import 'widget_components.dart';
import 'color_scheme.dart';
import 'models.dart';
import 'text_theme.dart';

class ProcessSalesOrder extends StatefulWidget {
  const ProcessSalesOrder({super.key});

  @override
  _ProcessSalesOrderState createState() => _ProcessSalesOrderState();
}

class _ProcessSalesOrderState extends State<ProcessSalesOrder> {
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
                  saleType: SaleType.account,
                  totalCost: 'Php 999999.99',
                  salesOrderItemList: [
                    SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456',
                        '999 Units', '999999.99', 'Php 999999.99'),
                    SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456',
                        '999 Units', '999999.99', 'Php 999999.99'),
                    SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456',
                        '999 Units', '999999.99', 'Php 999999.99'),
                    SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456',
                        '999 Units', '999999.99', 'Php 999999.99'),
                    SalesOrderItemListTileData('Item Name', 'SAM-123-ABC-456',
                        '999 Units', '999999.99', 'Php 999999.99'),
                  ],
                  customerList: [

                  ],
                  salespersonList: [
                    Salesperson(salespersonName: 'Salesperson Name')
                  ])
            ],
          ),
        ),
      ),
    );
  }
}

class SaleTypeBody extends StatelessWidget {
  const SaleTypeBody(
      {super.key,
      required this.saleType,
      required this.totalCost,
      required this.salesOrderItemList,
      required this.customerList,
      required this.salespersonList});

  final SaleType saleType;
  final String totalCost;
  final List<SalesOrderItemListTileData> salesOrderItemList;
  final List<Customer> customerList;
  final List<Salesperson> salespersonList;

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
            customerList: customerList,
            salespersonList: salespersonList,
            totalCost: totalCost,
            salesOrderItemList: salesOrderItemList);
        break;
    }

    return saleTypeBody;
  }
}

class RetailBody extends StatelessWidget {
  const RetailBody(
      {super.key, required this.totalCost, required this.salesOrderItemList});

  final String totalCost;
  final List<SalesOrderItemListTileData> salesOrderItemList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: GroupTitle(title: 'Items'),
        ),
        SalesOrderItemListCard(
            totalCost: totalCost, salesOrderItemList: salesOrderItemList),
        ButtonBar(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
            FilledButton(onPressed: () {}, child: const Text('Create Order'))
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

class AccountBody extends StatefulWidget {
  const AccountBody(
      {super.key,
      required this.customerList,
      required this.salespersonList,
      required this.totalCost,
      required this.salesOrderItemList});

  final String totalCost;
  final List<SalesOrderItemListTileData> salesOrderItemList;
  final List<Customer> customerList;
  final List<Salesperson> salespersonList;

  @override
  _AccountBodyState createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  child:
                      CustomerDropDownMenu(customerList: widget.customerList)),
              const Padding(padding: EdgeInsets.only(left: 16.0)),
              Flexible(
                  child: TextButton(
                      onPressed: () {}, child: const Text('New Customer'))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const PaymentTermsDropDownMenu(),
              const Padding(padding: EdgeInsets.only(left: 16.0)),
              SalespersonDropDownMenu(salespersonList: widget.salespersonList)
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: GroupTitle(title: 'Items'),
        ),
        SalesOrderItemListCard(
            totalCost: widget.totalCost,
            salesOrderItemList: widget.salesOrderItemList),
        ButtonBar(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
            FilledButton(onPressed: () {}, child: const Text('Create Order'))
          ],
        )
      ],
    );
  }
}
