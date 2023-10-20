import 'controllers.dart';
import 'package:flutter/material.dart';
import 'widget_components.dart';
import 'color_scheme.dart';
import 'models.dart';
import 'text_theme.dart';

class PurchaseOrderDetails extends StatelessWidget {
  const PurchaseOrderDetails({super.key, required this.purchaseOrder});

  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context) {
    Supplier supplier = Supplier.fromMap(purchaseOrder.supplier);
    var expectedDeliveryDate = dateTimeController.formatDateTimeToYMd(
        dateTime: purchaseOrder.expectedDeliveryDate!);
    var getEstimatedTotalCost = purchaseOrder.getTotalCost();
    var estimatedTotalCost = currencyController.formatAsPhilippineCurrency(
        amount: getEstimatedTotalCost);
    var purchaseOrderItemList = purchaseOrder.getPurchaseOrderItemList();

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
              HeadlineSmall(headline: purchaseOrder.purchaseOrderNumber!),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Supplier Detail'),
              ),
              Row(
                children: [
                  Expanded(
                    child: SupplierDetailCard(
                        supplierName: supplier.supplierName,
                        contactNumber: supplier.contactNumber,
                        contactPerson: supplier.contactPerson,
                        email: supplier.email,
                        address: supplier.address),
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
                        deliveryAddress: purchaseOrder.deliveryAddress!,
                        expectedDeliveryDate: expectedDeliveryDate),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: GroupTitle(title: 'Order Status'),
              ),
              PurchaseOrderStatus(purchaseOrder: purchaseOrder),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Order Details'),
              ),
              PurchaseOrderDetailsItemListCard(
                estimatedTotalCost: estimatedTotalCost,
                purchaseOrderItemList: purchaseOrderItemList,
              ),
              PurchaseOrderButtonBar(purchaseOrder: purchaseOrder)
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseOrderDetailsItemListCard extends StatelessWidget {
  const PurchaseOrderDetailsItemListCard(
      {super.key,
      required this.estimatedTotalCost,
      required this.purchaseOrderItemList});

  final String estimatedTotalCost;
  final List<PurchaseOrderItem> purchaseOrderItemList;

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

class PurchaseOrderButtonBar extends StatelessWidget {
  const PurchaseOrderButtonBar({super.key, required this.purchaseOrder});

  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: [
        VoidPurchaseOrderButton(purchaseOrder),
        PurchaseOrderEditButton(purchaseOrder),
        ReceiveOrderButton(purchaseOrder)
      ],
    );
  }
}
