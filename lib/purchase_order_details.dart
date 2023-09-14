import 'package:flutter/material.dart';
import ''
    'enumerated_values.dart';
import ''
    'widget_components.dart';

import 'color_scheme.dart';
import 'models.dart';
import 'text_theme.dart';

class PurchaseOrderDetails extends StatelessWidget {
  const PurchaseOrderDetails(
      {super.key,
      required this.purchaseOrderNumber,
      required this.supplierName,
      required this.contactPerson,
      required this.email,
      required this.contactNumber,
      required this.address,
      required this.deliveryAddress,
      required this.expectedDeliveryDate, required this.purchaseOrderItemList});

  final String purchaseOrderNumber;
  final String supplierName;
  final String contactPerson;
  final String email;
  final String contactNumber;
  final String address;
  final String deliveryAddress;
  final String expectedDeliveryDate;
  final List<PurchaseOrderItemListTileData> purchaseOrderItemList;

  @override
  Widget build(BuildContext context) {
    List<PurchaseOrderItemListTileData> purchaseOrderItemList = [
      PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
          '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
      PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
          '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
      PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
          '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
      PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
          '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
      PurchaseOrderItemListTileData('ItemName', 'SAM-123-ABC-456',
          '9999999 Units', '999999.99/Unit', 'Php 999999.99'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Order Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadlineSmall(headline: purchaseOrderNumber),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Supplier Detail'),
              ),
              Row(
                children: [
                  Expanded(
                    child: SupplierDetailCard(
                        supplierName: supplierName,
                        contactNumber: contactNumber,
                        contactPerson: contactPerson,
                        email: email,
                        address: address),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Delivery Detail'),
              ),
              Row(
                children: [
                  Expanded(
                    child: DeliveryDetailCard(
                        deliveryAddress: deliveryAddress,
                        expectedDeliveryDate: expectedDeliveryDate),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: GroupTitle(title: 'Order Status'),
              ),
              const PurchaseOrderStatus(
                  placeOrderState: PlaceOrderState.disabled,
                  confirmOrderState: ConfirmOrderState.disabled,
                  deliveryState: DeliveryState.disabled),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Order Details'),
              ),
               PurchaseOrderDetailsItemListCard(
                  estimatedTotalCost: 'Php 999999.99', purchaseOrderItemList: purchaseOrderItemList,)
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseOrderDetailsItemListCard extends StatelessWidget {
  const PurchaseOrderDetailsItemListCard(
      {super.key, required this.estimatedTotalCost, required this.purchaseOrderItemList});

  final String estimatedTotalCost;
  final List<PurchaseOrderItemListTileData> purchaseOrderItemList;

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
            const PurchaseOrderItemListHeader(),
            PurchaseOrderDetailsItemList(
                purchaseOrderItemList: purchaseOrderItemList),
            const Divider(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Total: $estimatedTotalCost',
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


