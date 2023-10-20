import 'controllers.dart';
import 'providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class NewSalesOrder extends ConsumerWidget {
  const NewSalesOrder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Sales Order'),
          actions: [
            IconButton(
                onPressed: () => scannerController.streamBarcodes(ref: ref),
                icon: const Icon(Icons.barcode_reader))
          ],
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

class ItemView extends ConsumerStatefulWidget {
  const ItemView({super.key});

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends ConsumerState<ItemView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(categoryIDProvider.notifier).setCategoryID('All');

      ref.read(asyncCategoryFilterListProvider.notifier).resetState();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: NewSalesOrderFilterChips(),
            ),
            Expanded(child: NewSalesOrderItemGrid())
          ],
        ));
  }
}

class OrderSummaryView extends StatelessWidget {
  const OrderSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
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
                const OrderSummaryList(),
                const Divider(),
                const OrderSummaryTotal(),
                ButtonBar(
                  children: [
                    Consumer(builder: (context, ref, child) {
                      var salesCart = ref.watch(salesOrderCartNotifierProvider);
                      var stockCart = ref.watch(adjustedStockListNotifierProvider);
                      var cartIsEmpty = salesCart.isEmpty;
                      return FilledButton(
                          onPressed: cartIsEmpty || stockCart.isEmpty
                              ? () => snackBarController
                                  .showSnackBarError('Your cart is empty...')
                              : () => navigationController
                                  .navigateToProcessSalesOrder(),
                          child: const Text('Place Order'));
                    })
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

class OrderSummaryTotal extends ConsumerWidget {
  const OrderSummaryTotal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var salesOrderCartNotifier = ref.watch(salesOrderCartNotifierProvider);
    var estimatedTotalCostFromNotifier = salesOrderCartNotifier.fold(
        0.0, (total, element) => total + element.subtotal!);
    var total = currencyController.formatAsPhilippineCurrency(
        amount: estimatedTotalCostFromNotifier);
    return Row(
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
    );
  }
}

class OrderSummaryList extends ConsumerWidget {
  const OrderSummaryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var salesOrderItemList = ref.watch(salesOrderCartNotifierProvider);
    return salesOrderItemList.isNotEmpty
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var data = salesOrderItemList[index];
              var subtotal =
                  currencyController.formatAsPhilippineCurrencyWithoutSymbol(
                      amount: data.subtotal!);
              return OrderSummaryListTile(
                itemName: data.item!['itemName'],
                itemCount:
                    stringController.removeTrailingZeros(value: data.quantity!),
                subTotal: subtotal,
              );
            },
            itemCount: salesOrderItemList.length,
          )
        : const Padding(
            padding: EdgeInsets.all(8.0),
            child:
                ErrorMessage(errorMessage: 'You currently have no orders...'),
          );
  }
}

class NewSalesOrderItemGrid extends ConsumerWidget {
  const NewSalesOrderItemGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncItemCardList = ref.watch(asyncNewSalesOrderItemCardListProvider);

    return asyncItemCardList.when(
        data: (data) {
          return data.isEmpty
              ? const ErrorMessage(
                  errorMessage: 'You currently have no items...')
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 3.5),
                  itemBuilder: (context, index) => data[index],
                  itemCount: data.length,
                );
        },
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}
