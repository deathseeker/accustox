import 'package:flutter/material.dart';
import 'default_values.dart';
import 'text_theme.dart';
import 'widget_components.dart';

import 'models.dart';

class NewSalesOrder extends StatelessWidget {
  const NewSalesOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Sales Order'),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemView(),
              Padding(padding: EdgeInsets.only(left: 16.0)),
              OrderSummaryView()
            ],
          ),
        ));
  }
}

class ItemView extends StatelessWidget {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: NewSalesOrderFilterChips(filters: ['All']),
            ),
            Expanded(
              child: NewSalesOrderItemGrid(itemList: [
                NewSalesOrderItemCardData(defaultMerchantImageUrl,
                    'Very Long Item Name Item Name Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(
                    defaultMerchantImageUrl, 'Very Long Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(
                    defaultMerchantImageUrl, 'Very Long Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(
                    defaultMerchantImageUrl, 'Very Long Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
                NewSalesOrderItemCardData(defaultMerchantImageUrl, 'Item Name'),
              ]),
            )
          ],
        ));
  }
}

class OrderSummaryView extends StatelessWidget {
  const OrderSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    var total = 'Php 999999.99';
    return Expanded(
      child: SingleChildScrollView(
        child: Card(
          borderOnForeground: false,
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 1.0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GroupTitle(title: 'Order Summary'),
                OrderSummaryList(orderSummaryList: [
                  OrderSummaryListTileData('Item Name', '99999.99', '999'),
                  OrderSummaryListTileData(
                      'Very Long Item Name Item Name Item Name Item Name',
                      '99999.99',
                      '9999999999'),
                  OrderSummaryListTileData('Item Name', '99999.99', '999'),
                  OrderSummaryListTileData(
                      'Very Long Item Name Item Name Item Name Item Name',
                      '99999.99',
                      '9999999999'),
                  OrderSummaryListTileData('Item Name', '99999.99', '999'),
                  OrderSummaryListTileData(
                      'Very Long Item Name Item Name Item Name Item Name',
                      '99999.99',
                      '9999999999'),
                  OrderSummaryListTileData('Item Name', '99999.99', '999'),
                  OrderSummaryListTileData(
                      'Very Long Item Name Item Name Item Name Item Name',
                      '99999.99',
                      '9999999999'),
                  OrderSummaryListTileData('Item Name', '99999.99', '999'),
                  OrderSummaryListTileData(
                      'Very Long Item Name Item Name Item Name Item Name',
                      '99999.99',
                      '9999999999'),
                ]),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: customTextStyle.titleMedium,
                    ),
                    Text(
                      total,
                      style: customTextStyle.titleMedium,
                    )
                  ],
                ),
                ButtonBar(
                  children: [
                    OutlinedButton(
                        onPressed: () {}, child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () {}, child: const Text('Place Order'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderSummaryList extends StatelessWidget {
  const OrderSummaryList({super.key, required this.orderSummaryList});

  final List<OrderSummaryListTileData> orderSummaryList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        OrderSummaryListTileData data = orderSummaryList[index];
        return OrderSummaryListTile(
          itemName: data.itemName,
          itemCount: data.itemCount,
          subTotal: data.subTotal,
        );
      },
      itemCount: orderSummaryList.length,
    );
  }
}

class NewSalesOrderItemGrid extends StatelessWidget {
  const NewSalesOrderItemGrid({super.key, required this.itemList});

  final List<NewSalesOrderItemCardData> itemList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.7657,
      ),
      itemBuilder: (context, index) {
        NewSalesOrderItemCardData data = itemList[index];
        return NewSalesOrderItemCard(
            imageURL: data.imageURL, itemName: data.itemName);
      },
      itemCount: itemList.length,
    );
  }
}
