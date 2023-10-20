// ignore_for_file: library_private_types_in_public_api
import 'package:collection/collection.dart';

import 'color_scheme.dart';
import 'controllers.dart';
import 'sub_location_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'custom_color.dart';
import 'enumerated_values.dart';
import 'providers.dart';
import 'text_theme.dart';
import 'default_values.dart';
import 'models.dart';

Widget googleSignInButton(VoidCallback onPressed) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.background),
      child: SizedBox(
        height: 40.0,
        width: 180.0,
        child: Row(
          children: [
            SizedBox(
              height: 18.0,
              width: 18.0,
              child: Image.asset(
                height: 18.0,
                width: 18.0,
                'assets/google_g_logo.png',
                fit: BoxFit.cover,
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 24.0)),
            Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 14.0, color: googleSignInText),
            )
          ],
        ),
      ));
}

class GroupTitle extends StatelessWidget {
  const GroupTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: customTextStyle.titleMedium
          .copyWith(color: lightColorScheme.onBackground),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.label, required this.content});

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
        borderOnForeground: true,
        child: Container(
          constraints: const BoxConstraints(minWidth: 244.0, minHeight: 80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: customTextStyle.labelLarge
                      .copyWith(color: lightColorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                Text(
                  content,
                  style: customTextStyle.headlineMedium
                      .copyWith(color: lightColorScheme.onSurface),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ));
  }
}

class GroupTitleWithTextButton extends StatelessWidget {
  const GroupTitleWithTextButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.buttonLabel});

  final String title;
  final VoidCallback onPressed;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GroupTitle(title: title),
        TextButton(onPressed: onPressed, child: Text(buttonLabel))
      ],
    );
  }
}

class GroupTitleWithFilledButton extends StatelessWidget {
  const GroupTitleWithFilledButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.buttonLabel});

  final String title;
  final VoidCallback onPressed;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GroupTitle(title: title),
        FilledButton(onPressed: onPressed, child: Text(buttonLabel))
      ],
    );
  }
}

class GroupTitleWithPeriodMenu extends StatefulWidget {
  const GroupTitleWithPeriodMenu({super.key, required this.title});

  final String title;

  @override
  _GroupTitleWithPeriodMenuState createState() =>
      _GroupTitleWithPeriodMenuState();
}

class _GroupTitleWithPeriodMenuState extends State<GroupTitleWithPeriodMenu> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GroupTitle(title: widget.title),
        const ReportingPeriodDropdown()
      ],
    );
  }
}

class PeriodDropDownMenu extends StatefulWidget {
  const PeriodDropDownMenu({super.key});

  @override
  _PeriodDropDownMenu createState() => _PeriodDropDownMenu();
}

class _PeriodDropDownMenu extends State<PeriodDropDownMenu> {
  ReportingPeriod? selectedReportingPeriod;

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
    final List<DropdownMenuEntry<ReportingPeriod>> reportingPeriodEntries =
        <DropdownMenuEntry<ReportingPeriod>>[];
    for (final ReportingPeriod reportingPeriod in ReportingPeriod.values) {
      reportingPeriodEntries.add(
        DropdownMenuEntry<ReportingPeriod>(
            value: reportingPeriod, label: reportingPeriod.label),
      );
    }

    return DropdownMenu<ReportingPeriod>(
      leadingIcon: const Icon(Icons.calendar_today_outlined),
      initialSelection: ReportingPeriod.today,
      enableFilter: false,
      enableSearch: false,
      label: const Text('Period'),
      dropdownMenuEntries: reportingPeriodEntries,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      ),
      onSelected: (ReportingPeriod? reportingPeriod) {
        setState(() {
          selectedReportingPeriod = reportingPeriod;
        });
      },
    );
  }
}

class ReportingPeriodDropdown extends StatefulWidget {
  const ReportingPeriodDropdown({super.key});

  @override
  _ReportingPeriodDropdownState createState() =>
      _ReportingPeriodDropdownState();
}

class _ReportingPeriodDropdownState extends State<ReportingPeriodDropdown> {
  String selectedPeriod = 'Today';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: selectedPeriod,
            onChanged: (newValue) {
              setState(() {
                selectedPeriod = newValue!;
              });
            },
            items: <String>[
              'Today',
              'Week to Date',
              'Last Week',
              'Month to Date',
              'Last Month',
              'Year to Date',
              'Last Year',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class IncomingInventoryFilterChips extends ConsumerStatefulWidget {
  const IncomingInventoryFilterChips({super.key});

  @override
  _IncomingInventoryFilterChipsState createState() =>
      _IncomingInventoryFilterChipsState();
}

class _IncomingInventoryFilterChipsState
    extends ConsumerState<IncomingInventoryFilterChips> {
  List<IncomingInventoryFilter> incomingInventoryFilterList =
      IncomingInventoryFilter.values;
  late IncomingInventoryFilter selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = ref.read(incomingInventoryFilterSelectionProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Adjust the spacing between filter chips
      children: incomingInventoryFilterList.map((filter) {
        return FilterChip(
          label: Text(filter.label),
          selected: selectedFilter == filter,
          onSelected: (isSelected) {
            setState(() {
              selectedFilter = filter;
            });
            ref.read(incomingInventoryFilterSelectionProvider.notifier).state =
                filter;
          },
        );
      }).toList(),
    );
  }
}

class CurrentInventoryFilterChips extends ConsumerStatefulWidget {
  const CurrentInventoryFilterChips({super.key});

  @override
  _CurrentInventoryFilterChipsState createState() =>
      _CurrentInventoryFilterChipsState();
}

class _CurrentInventoryFilterChipsState
    extends ConsumerState<CurrentInventoryFilterChips> {
  List<CurrentInventoryFilter> currentInventoryFilterList =
      CurrentInventoryFilter.values;
  late CurrentInventoryFilter selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = ref.read(currentInventoryFilterSelectionProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Adjust the spacing between filter chips
      children: currentInventoryFilterList.map((filter) {
        return FilterChip(
          label: Text(filter.label),
          selected: selectedFilter == filter,
          onSelected: (isSelected) {
            setState(() {
              selectedFilter = filter;
            });
            ref.read(currentInventoryFilterSelectionProvider.notifier).state =
                filter;
          },
        );
      }).toList(),
    );
  }
}

class CurrentInventoryItemCard extends StatelessWidget {
  const CurrentInventoryItemCard(
      {super.key, required this.currentInventoryData});

  final CurrentInventoryData currentInventoryData;

  @override
  Widget build(BuildContext context) {
    Item item = Item.fromMap(currentInventoryData.inventory.item!);

    return GestureDetector(
      onTap: () => navigationController.navigateToCurrentInventoryDetails(
          currentInventoryData: currentInventoryData),
      child: Card(
        borderOnForeground: true,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 78,
          width: 244,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName!,
                      style: customTextStyle.titleMedium
                          .copyWith(color: lightColorScheme.onSurface),
                    ),
                    Text(
                      item.sku!,
                      style: customTextStyle.bodyMedium
                          .copyWith(color: lightColorScheme.onSurface),
                    ),
                  ],
                ),
              ),
              StockLevelNotification(
                  stockLevel: currentInventoryData.inventory.stockLevel!,
                  stockLevelState: currentInventoryData.stockLevelState,
                  unit: item.unitOfMeasurement!)
            ],
          ),
        ),
      ),
    );
  }
}

class ExpirationNotification extends StatelessWidget {
  const ExpirationNotification({super.key, required this.expirationState});

  final ExpirationState expirationState;

  @override
  Widget build(BuildContext context) {
    Color? color;

    switch (expirationState) {
      case ExpirationState.good:
        color = lightColorScheme.tertiary;
        break;
      case ExpirationState.nearExpiration:
        color = lightCustomColors.sourceMikadoyellow;
        break;
      case ExpirationState.expired:
        color = lightCustomColors.redalert;
        break;
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 92.0, maxWidth: 16.0),
      color: color,
    );
  }
}

class StockLevelNotification extends StatelessWidget {
  const StockLevelNotification(
      {super.key,
      required this.stockLevel,
      required this.stockLevelState,
      required this.unit});

  final double stockLevel;
  final StockLevelState stockLevelState;
  final String unit;

  @override
  Widget build(BuildContext context) {
    Color? color;
    Color? textColor;

    var pluralizedUnit =
        pluralizationController.pluralize(noun: unit, count: stockLevel);

    var stockLevelString =
        stringController.removeTrailingZeros(value: stockLevel);

    switch (stockLevelState) {
      case StockLevelState.inStock:
        color = lightColorScheme.tertiaryContainer;
        textColor = lightColorScheme.onTertiaryContainer;
        break;
      case StockLevelState.reorder:
        color = lightCustomColors.mikadoyellowContainer;
        textColor = lightCustomColors.onMikadoyellowContainer;
        break;
      case StockLevelState.lowStock:
        color = lightCustomColors.redalertContainer;
        textColor = lightCustomColors.onRedalertContainer;
        break;
      case StockLevelState.outOfStock:
        color = darkCustomColors.redalertContainer;
        textColor = darkCustomColors.onRedalertContainer;
    }
    return Container(
      color: color,
      height: 24,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Stock Level:',
              style: customTextStyle.labelMedium.copyWith(color: textColor),
            ),
            Text(
              '$stockLevelString $pluralizedUnit',
              style: customTextStyle.labelMedium.copyWith(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}

class IncomingInventoryNotification extends StatelessWidget {
  final IncomingInventoryState incomingInventoryState;

  const IncomingInventoryNotification(
      {super.key, required this.incomingInventoryState});

  @override
  Widget build(BuildContext context) {
    Color? color;
    Color? textColor;
    String? status;

    switch (incomingInventoryState) {
      case IncomingInventoryState.forPlacement:
        color = lightCustomColors.redalertContainer;
        textColor = lightCustomColors.onRedalertContainer;
        status = 'Awaiting Order Placement';
        break;
      case IncomingInventoryState.forConfirmation:
        color = lightCustomColors.mikadoyellowContainer;
        textColor = lightCustomColors.onMikadoyellowContainer;
        status = 'Awaiting Order Confirmation';
        break;
      case IncomingInventoryState.forDelivery:
        color = lightColorScheme.tertiaryContainer;
        textColor = lightColorScheme.onTertiaryContainer;
        status = 'For Delivery';
        break;
      case IncomingInventoryState.forInventory:
        color = lightColorScheme.primaryContainer;
        textColor = lightColorScheme.onPrimaryContainer;
        status = 'For Inventory';
        break;
    }

    return Container(
      color: color,
      height: 24,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            Flexible(
              child: Text(
                'Status: ',
                style: customTextStyle.labelMedium.copyWith(color: textColor),
              ),
            ),
            Flexible(
              child: Text(
                status,
                style: customTextStyle.labelMedium.copyWith(color: textColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemDetailsCard extends StatelessWidget {
  const ItemDetailsCard({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 77,
          minWidth: 756,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ItemPicture(imageURL: item.imageURL!),
              const Padding(padding: EdgeInsets.only(left: 8.0)),
              ItemDetails(item: item)
            ],
          ),
        ),
      ),
    );
  }
}

class ItemPicture extends StatelessWidget {
  const ItemPicture({super.key, required this.imageURL});

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      height: 132,
      width: 132,
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: imageURL,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        ),
        errorWidget: (context, url, error) {
          debugPrint('Error loading image: $error');
          return Image.network(
            defaultMerchantImageUrl,
            fit: BoxFit.cover,
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }
}

class ItemTitle extends StatelessWidget {
  const ItemTitle({super.key, required this.itemName});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Display Name',
          style: customTextStyle.labelMedium
              .copyWith(color: lightColorScheme.onSurfaceVariant),
        ),
        Text(
          itemName,
          style: customTextStyle.titleMedium
              .copyWith(color: lightColorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ));
  }
}

class NewSalesOrderItemCardTitle extends StatelessWidget {
  const NewSalesOrderItemCardTitle({super.key, required this.itemName});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Center(
      child: Text(
        itemName,
        style: customTextStyle.titleMedium
            .copyWith(color: lightColorScheme.onSurface),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    ));
  }
}

class InformationWithLabel extends StatelessWidget {
  const InformationWithLabel(
      {super.key, required this.label, required this.data});

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: customTextStyle.labelMedium
              .copyWith(color: lightColorScheme.onSurfaceVariant),
        ),
        Text(
          data.isEmpty ? '--' : data,
          style: customTextStyle.bodyMedium
              .copyWith(color: lightColorScheme.onSurface),
        ),
      ],
    );
  }
}

class InformationWithLabelForRetailItemCard extends StatelessWidget {
  const InformationWithLabelForRetailItemCard(
      {super.key, required this.label, required this.data});

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: customTextStyle.labelMedium
              .copyWith(color: onPrimaryFixedVariant),
        ),
        Text(
          data.isEmpty ? '--' : data,
          style: customTextStyle.bodyMedium
              .copyWith(color: lightColorScheme.onPrimaryContainer),
        ),
      ],
    );
  }
}

class InformationWithLabelLarge extends StatelessWidget {
  const InformationWithLabelLarge(
      {super.key, required this.label, required this.data});

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: customTextStyle.labelLarge
              .copyWith(color: lightColorScheme.onSurfaceVariant),
        ),
        Text(
          data.isEmpty ? '--' : data,
          style: customTextStyle.bodyLarge
              .copyWith(color: lightColorScheme.onSurface),
        ),
      ],
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ItemTitle(itemName: item.itemName!),
            EditItemButton(onPressed: () {})
          ],
        ),
        Wrap(
          runSpacing: 4.0,
          spacing: 16.0,
          children: [
            InformationWithLabel(
                label: 'Perishability', data: item.perishability!),
            InformationWithLabel(label: 'SKU', data: item.sku!),
            InformationWithLabel(label: 'EAN', data: item.ean!),
            InformationWithLabel(
                label: 'Product Type', data: item.productType!),
            InformationWithLabel(label: 'Brand', data: item.brand!),
            InformationWithLabel(
                label: 'Manufacturer', data: item.manufacturer!),
            InformationWithLabel(
                label: 'Manufacturer Part Number',
                data: item.manufacturerPartNumber!),
            InformationWithLabel(
                label: 'Unit of Measurement', data: item.unitOfMeasurement!),
            InformationWithLabel(label: 'Size', data: item.size!),
            InformationWithLabel(label: 'Color', data: item.color!),
            InformationWithLabel(label: 'Length', data: item.length!),
            InformationWithLabel(label: 'Width', data: item.width!),
            InformationWithLabel(label: 'Height', data: item.height!),
            InformationWithLabel(
                label: 'Description', data: item.itemDescription!),
          ],
        )
      ],
    ));
  }
}

class EditItemButton extends StatelessWidget {
  const EditItemButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: const Icon(
          Icons.edit_outlined,
        ));
  }
}

class ItemDashboardCard extends StatelessWidget {
  const ItemDashboardCard(
      {super.key, required this.label, required this.content});

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
        borderOnForeground: true,
        child: Container(
          constraints: const BoxConstraints(minWidth: 180.0, minHeight: 80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: customTextStyle.labelLarge
                      .copyWith(color: lightColorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                Text(
                  content.isEmpty ? '--' : content,
                  style: customTextStyle.headlineMedium
                      .copyWith(color: lightColorScheme.onSurface),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ));
  }
}

class PurchaseOrderItemManagementCard extends StatelessWidget {
  const PurchaseOrderItemManagementCard(
      {super.key,
      required this.purchaseOrderItem,
      required this.purchaseOrder});

  final PurchaseOrderItem purchaseOrderItem;
  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context) {
    var stockLevel =
        '${purchaseOrderItem.quantity.toString()} ${pluralizationController.pluralize(noun: purchaseOrderItem.unitOfMeasurement!, count: purchaseOrderItem.quantity)}';
    var costPrice = currencyController.formatAsPhilippineCurrency(
        amount: purchaseOrderItem.estimatedPrice);
    var supplier = Supplier.fromMap(purchaseOrder.supplier);
    var supplierName = supplier.supplierName;
    var addedToInventory = purchaseOrderItem.addedToInventory!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: Wrap(
              spacing: 16.0,
              runSpacing: 4.0,
              children: [
                InformationWithLabel(
                    label: 'SKU', data: purchaseOrderItem.sku!),
                InformationWithLabel(label: 'Stock Level', data: stockLevel),
                InformationWithLabel(label: 'Cost Price', data: costPrice),
                InformationWithLabel(
                    label: 'Item Name', data: purchaseOrderItem.itemName!),
                InformationWithLabel(label: 'Supplier', data: supplierName)
              ],
            )),
            IconButton(
                onPressed: addedToInventory
                    ? null
                    : () => navigationController
                        .navigateToNewInventoryStockFromPurchaseOrder(
                            purchaseOrderItem: purchaseOrderItem,
                            purchaseOrder: purchaseOrder),
                icon: addedToInventory
                    ? Icon(
                        Icons.check_box_outlined,
                        color: lightColorScheme.tertiary,
                      )
                    : Icon(
                        Icons.add_box_outlined,
                        color: lightColorScheme.primary,
                      ))
          ],
        ),
      ),
    );
  }
}

class ItemInventoryCard extends StatelessWidget {
  final Stock stock;

  const ItemInventoryCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    Item item = Item.fromMap(stock.item!);
    Supplier supplier = Supplier.fromMap(stock.supplier!);
    StockLocation stockLocation = StockLocation.fromMap(stock.stockLocation!);
    bool expires = perishabilityController.getPerishabilityState(
                perishabilityString: item.perishability!) ==
            Perishability.durableGoods
        ? false
        : true;
    bool hasPurchaseDate =
        stock.purchaseDate! == defaultDateTime ? false : true;
    var stockLevel =
        '${stock.stockLevel.toString()} ${pluralizationController.pluralize(noun: item.unitOfMeasurement!, count: stock.stockLevel!)}';
    var stockLocationAddress = stockLocation.locationAddress;
    var expirationDate = expires
        ? dateTimeController.formatDateTimeToYMd(
            dateTime: stock.expirationDate!)
        : 'N/A';
    var batchNumber = stock.batchNumber!;
    var costPrice =
        currencyController.formatAsPhilippineCurrency(amount: stock.costPrice!);
    var salePrice =
        currencyController.formatAsPhilippineCurrency(amount: stock.salePrice!);
    var purchaseDate = hasPurchaseDate
        ? dateTimeController.formatDateTimeToYMd(dateTime: stock.purchaseDate!)
        : '--/--/----';
    var supplierName = supplier.supplierName;

    var expirationState = dateTimeController.getExpirationState(
        stock.expirationDate!, stock.expirationWarning!);

    var daysToExpiration = dateTimeController.getDaysToExpiration(
        expirationDate: stock.expirationDate!);

    return Card(
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(minHeight: 92.0),
        child: Row(
          children: [
            expires
                ? ExpirationNotification(expirationState: expirationState)
                : const SizedBox(
                    height: 0.0,
                    width: 0.0,
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Wrap(
                        spacing: 16.0,
                        runSpacing: 4.0,
                        children: [
                          InformationWithLabel(
                              label: 'Stock Level', data: stockLevel),
                          InformationWithLabel(
                              label: 'Stock Location',
                              data: stockLocationAddress),
                          InformationWithLabel(
                              label: 'Cost Price', data: costPrice),
                          InformationWithLabel(
                              label: 'Sale Price', data: salePrice),
                          InformationWithLabel(
                              label: 'Batch/Lot Number', data: batchNumber),
                          InformationWithLabel(
                              label: 'Supplier', data: supplierName),
                          InformationWithLabel(
                              label: 'Purchase Date', data: purchaseDate),
                          InformationWithLabel(
                              label: 'Expiration Date', data: expirationDate),
                          expires
                              ? ExpirationMessage(
                                  expirationState: expirationState,
                                  daysToExpiration: daysToExpiration)
                              : const SizedBox(
                                  height: 0.0,
                                  width: 0.0,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StockMoreMenuButton(
              stock: stock,
            )
          ],
        ),
      ),
    );
  }
}

class RetailItemInventoryCard extends StatelessWidget {
  final Stock stock;

  const RetailItemInventoryCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    Item item = Item.fromMap(stock.item!);
    Supplier supplier = Supplier.fromMap(stock.supplier!);
    StockLocation stockLocation = StockLocation.fromMap(stock.stockLocation!);
    bool expires = perishabilityController.getPerishabilityState(
                perishabilityString: item.perishability!) ==
            Perishability.durableGoods
        ? false
        : true;
    bool hasPurchaseDate =
        stock.purchaseDate! == defaultDateTime ? false : true;
    var stockLevel =
        '${stock.stockLevel.toString()} ${pluralizationController.pluralize(noun: item.unitOfMeasurement!, count: stock.stockLevel!)}';
    var stockLocationAddress = stockLocation.locationAddress;
    var expirationDate = expires
        ? dateTimeController.formatDateTimeToYMd(
            dateTime: stock.expirationDate!)
        : 'N/A';
    var batchNumber = stock.batchNumber!;
    var costPrice =
        currencyController.formatAsPhilippineCurrency(amount: stock.costPrice!);
    var salePrice =
        currencyController.formatAsPhilippineCurrency(amount: stock.salePrice!);
    var purchaseDate = hasPurchaseDate
        ? dateTimeController.formatDateTimeToYMd(dateTime: stock.purchaseDate!)
        : '--/--/----';
    var supplierName = supplier.supplierName;

    var expirationState = dateTimeController.getExpirationState(
        stock.expirationDate!, stock.expirationWarning!);

    var daysToExpiration = dateTimeController.getDaysToExpiration(
        expirationDate: stock.expirationDate!);

    return Card(
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(minHeight: 92.0),
        color: lightColorScheme.primaryContainer,
        child: Row(
          children: [
            expires
                ? ExpirationNotification(expirationState: expirationState)
                : const SizedBox(
                    height: 0.0,
                    width: 0.0,
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Wrap(
                        spacing: 16.0,
                        runSpacing: 4.0,
                        children: [
                          InformationWithLabelForRetailItemCard(
                              label: 'Stock Level', data: stockLevel),
                          InformationWithLabelForRetailItemCard(
                              label: 'Stock Location',
                              data: stockLocationAddress),
                          InformationWithLabelForRetailItemCard(
                              label: 'Cost Price', data: costPrice),
                          InformationWithLabelForRetailItemCard(
                              label: 'Sale Price', data: salePrice),
                          InformationWithLabelForRetailItemCard(
                              label: 'Batch/Lot Number', data: batchNumber),
                          InformationWithLabelForRetailItemCard(
                              label: 'Supplier', data: supplierName),
                          InformationWithLabelForRetailItemCard(
                              label: 'Purchase Date', data: purchaseDate),
                          InformationWithLabelForRetailItemCard(
                              label: 'Expiration Date', data: expirationDate),
                          expires
                              ? ExpirationMessageForRetailItemCard(
                                  expirationState: expirationState,
                                  daysToExpiration: daysToExpiration)
                              : const SizedBox(
                                  height: 0.0,
                                  width: 0.0,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            RetailStockMoreMenuButton(
              stock: stock,
            )
          ],
        ),
      ),
    );
  }
}

class ExpirationMessage extends StatelessWidget {
  final ExpirationState expirationState;
  final int daysToExpiration;

  const ExpirationMessage(
      {super.key,
      required this.expirationState,
      required this.daysToExpiration});

  @override
  Widget build(BuildContext context) {
    String data;
    var unit =
        pluralizationController.pluralize(noun: 'Day', count: daysToExpiration);

    switch (expirationState) {
      case ExpirationState.good:
        data = '--';
        break;
      case ExpirationState.nearExpiration:
        data = 'Expires in $daysToExpiration $unit';
        break;
      case ExpirationState.expired:
        data = 'EXPIRED';
        break;
    }

    return InformationWithLabel(label: 'Status', data: data);
  }
}

class ExpirationMessageForRetailItemCard extends StatelessWidget {
  final ExpirationState expirationState;
  final int daysToExpiration;

  const ExpirationMessageForRetailItemCard(
      {super.key,
      required this.expirationState,
      required this.daysToExpiration});

  @override
  Widget build(BuildContext context) {
    String data;
    var unit =
        pluralizationController.pluralize(noun: 'Day', count: daysToExpiration);

    switch (expirationState) {
      case ExpirationState.good:
        data = '--';
        break;
      case ExpirationState.nearExpiration:
        data = 'Expires in $daysToExpiration $unit';
        break;
      case ExpirationState.expired:
        data = 'EXPIRED';
        break;
    }

    return InformationWithLabelForRetailItemCard(label: 'Status', data: data);
  }
}

class ItemSupplierCard extends StatelessWidget {
  const ItemSupplierCard(
      {super.key,
      required this.supplierName,
      required this.contactNumber,
      required this.contactPerson,
      required this.email,
      required this.address,
      required this.minimumOrderQuantity,
      required this.onPressed});

  final String supplierName;
  final String contactNumber;
  final String contactPerson;
  final String email;
  final String address;
  final String minimumOrderQuantity;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 92.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 4.0,
                  children: [
                    InformationWithLabel(
                        label: 'Supplier Name', data: supplierName),
                    InformationWithLabel(
                        label: 'Contact Number', data: contactNumber),
                    InformationWithLabel(
                        label: 'Contact Person', data: contactPerson),
                    InformationWithLabel(label: 'Email', data: email),
                    InformationWithLabel(label: 'Address', data: address),
                    InformationWithLabel(
                        label: 'Minimum Order Quantity',
                        data: minimumOrderQuantity),
                  ],
                ),
              ),
              TextButton(onPressed: onPressed, child: const Text('Order'))
            ],
          ),
        ),
      ),
    );
  }
}

class SupplierDetailCard extends StatelessWidget {
  const SupplierDetailCard({
    super.key,
    required this.supplierName,
    required this.contactNumber,
    required this.contactPerson,
    required this.email,
    required this.address,
  });

  final String supplierName;
  final String contactNumber;
  final String contactPerson;
  final String email;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 4.0,
          children: [
            InformationWithLabel(label: 'Supplier Name', data: supplierName),
            InformationWithLabel(label: 'Contact Number', data: contactNumber),
            InformationWithLabel(label: 'Contact Person', data: contactPerson),
            InformationWithLabel(label: 'Email', data: email),
            InformationWithLabel(label: 'Address', data: address),
          ],
        ),
      ),
    );
  }
}

class DeliveryDetailCard extends StatelessWidget {
  const DeliveryDetailCard(
      {super.key,
      required this.deliveryAddress,
      required this.expectedDeliveryDate});

  final String deliveryAddress;
  final String expectedDeliveryDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 4.0,
          children: [
            InformationWithLabel(
                label: 'DeliveryAddress', data: deliveryAddress),
            InformationWithLabel(
                label: 'Expected Delivery Date', data: expectedDeliveryDate),
          ],
        ),
      ),
    );
  }
}

class InventoryAdjustmentCard extends StatelessWidget {
  const InventoryAdjustmentCard(
      {super.key,
      required this.stockLevel,
      required this.stockLocation,
      required this.expirationDate,
      required this.batchNumber,
      required this.costPrice,
      required this.salePrice,
      required this.purchaseDate,
      required this.supplierName,
      required this.onPressed});

  final String stockLevel;
  final String stockLocation;
  final String expirationDate;
  final String batchNumber;
  final String costPrice;
  final String salePrice;
  final String purchaseDate;
  final String supplierName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 92.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 4.0,
                  children: [
                    InformationWithLabel(
                        label: 'Stock Level', data: stockLevel),
                    InformationWithLabel(
                        label: 'Stock Location', data: stockLocation),
                    InformationWithLabel(
                        label: 'Expiration Date', data: expirationDate),
                    InformationWithLabel(
                        label: 'Batch/Lot Number', data: batchNumber),
                    InformationWithLabel(label: 'Cost Price', data: costPrice),
                    InformationWithLabel(label: 'Sale Price', data: salePrice),
                    InformationWithLabel(
                        label: 'Purchase Date', data: purchaseDate),
                    InformationWithLabel(label: 'Supplier', data: supplierName)
                  ],
                ),
              ),
              TextButton(onPressed: onPressed, child: const Text('Adjust'))
            ],
          ),
        ),
      ),
    );
  }
}

class AdjustmentDashboardCard extends StatelessWidget {
  const AdjustmentDashboardCard(
      {super.key, required this.label, required this.data});

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 49.0, minWidth: 180),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: customTextStyle.labelMedium
                    .copyWith(color: lightColorScheme.onSurfaceVariant),
              ),
              Text(
                data,
                style: customTextStyle.bodyMedium
                    .copyWith(color: lightColorScheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IncomingInventoryCard extends StatelessWidget {
  const IncomingInventoryCard(
      {super.key,
      required this.purchaseOrder,
      required this.incomingInventoryState});

  final PurchaseOrder purchaseOrder;
  final IncomingInventoryState incomingInventoryState;

  @override
  Widget build(BuildContext context) {
    Supplier supplier = Supplier.fromMap(purchaseOrder.supplier);
    var getEstimatedTotalCost = purchaseOrder.getTotalCost();
    var estimatedTotalCost = currencyController.formatAsPhilippineCurrency(
        amount: getEstimatedTotalCost);
    var purchaseOrderNumber = purchaseOrder.purchaseOrderNumber!;
    var deliveryAddress = purchaseOrder.deliveryAddress!;
    var expectedDeliveryDate = dateTimeController.formatDateTimeToYMd(
        dateTime: purchaseOrder.expectedDeliveryDate!);
    var purchaseOrderItemList = purchaseOrder.getPurchaseOrderItemList();
    var deliveryDate = dateTimeController.formatDateTimeToYMd(
        dateTime: purchaseOrder.orderDeliveredOn!);

    return purchaseOrder.orderDelivered!
        ? Card(
            margin: const EdgeInsets.all(0.0),
            borderOnForeground: true,
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 16.0,
                              runSpacing: 4.0,
                              children: [
                                InformationWithLabel(
                                    label: 'Supplier',
                                    data: supplier.supplierName),
                                InformationWithLabel(
                                    label: 'Total Cost',
                                    data: estimatedTotalCost),
                                InformationWithLabel(
                                    label: 'Purchase Order Number',
                                    data: purchaseOrderNumber),
                                InformationWithLabel(
                                    label: 'Delivery Address',
                                    data: deliveryAddress),
                                InformationWithLabel(
                                    label: 'Delivery Date', data: deliveryDate)
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () => navigationController
                                  .navigateToIncomingInventoryManagement(
                                      purchaseOrder: purchaseOrder),
                              child: const Icon(Icons.info_outline_rounded))
                        ],
                      ),
                      const Divider(),
                      const FinalPurchaseOrderItemListHeader(),
                      PurchaseOrderItemList(
                          purchaseOrderItemList: purchaseOrderItemList),
                    ],
                  ),
                ),
                IncomingInventoryNotification(
                    incomingInventoryState: incomingInventoryState)
              ],
            ),
          )
        : Card(
            margin: const EdgeInsets.all(0.0),
            borderOnForeground: true,
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 16.0,
                              runSpacing: 4.0,
                              children: [
                                InformationWithLabel(
                                    label: 'Supplier',
                                    data: supplier.supplierName),
                                InformationWithLabel(
                                    label: 'Estimated Total Cost',
                                    data: estimatedTotalCost),
                                InformationWithLabel(
                                    label: 'Purchase Order Number',
                                    data: purchaseOrderNumber),
                                InformationWithLabel(
                                    label: 'Delivery Address',
                                    data: deliveryAddress),
                                InformationWithLabel(
                                    label: 'Expected Delivery Date',
                                    data: expectedDeliveryDate)
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () => navigationController
                                  .navigateToPurchaseOrderDetails(
                                      purchaseOrder: purchaseOrder),
                              child: const Icon(Icons.info_outline_rounded))
                        ],
                      ),
                      const Divider(),
                      const PurchaseOrderItemListHeader(),
                      PurchaseOrderItemList(
                          purchaseOrderItemList: purchaseOrderItemList),
                    ],
                  ),
                ),
                IncomingInventoryNotification(
                    incomingInventoryState: incomingInventoryState)
              ],
            ),
          );
  }
}

class PurchaseOrderItemListHeader extends StatelessWidget {
  const PurchaseOrderItemListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Text(
              'Item',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'SKU',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 2,
            child: Text(
              'Quantity',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'Est. Price/Unit',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'Subtotal',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }
}

class FinalPurchaseOrderItemListHeader extends StatelessWidget {
  const FinalPurchaseOrderItemListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Text(
              'Item',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'SKU',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 2,
            child: Text(
              'Quantity',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'Price/Unit',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'Subtotal',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }
}

class SalesOrderItemListHeader extends StatelessWidget {
  const SalesOrderItemListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Text(
              'Item',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'SKU',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 2,
            child: Text(
              'Quantity',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'Price/Unit',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'Subtotal',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }
}

class PurchaseOrderItemListHeaderWithButtonSpace extends StatelessWidget {
  const PurchaseOrderItemListHeaderWithButtonSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Text(
              'Item',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'SKU',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 2,
            child: Text(
              'Quantity',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'Est. Price/Unit',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              'Subtotal',
              textAlign: TextAlign.center,
              style: customTextStyle.labelLarge
                  .copyWith(color: lightColorScheme.onSurfaceVariant),
              overflow: TextOverflow.ellipsis,
            )),
        const Expanded(flex: 1, child: SizedBox())
      ],
    );
  }
}

class PurchaseOrderItemListTile extends StatelessWidget {
  const PurchaseOrderItemListTile(
      {super.key,
      required this.itemName,
      required this.sku,
      required this.quantity,
      required this.estimatedPrice,
      required this.subtotal});

  final String itemName;
  final String sku;
  final String quantity;
  final String estimatedPrice;
  final String subtotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Text(
              itemName,
              textAlign: TextAlign.start,
              style: customTextStyle.titleSmall
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              sku,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 2,
            child: Text(
              quantity,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              estimatedPrice,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              subtotal,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }
}

class SalesOrderItemListTile extends StatelessWidget {
  const SalesOrderItemListTile(
      {super.key,
      required this.itemName,
      required this.sku,
      required this.quantity,
      required this.price,
      required this.subtotal});

  final String itemName;
  final String sku;
  final String quantity;
  final String price;
  final String subtotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Text(
              itemName,
              textAlign: TextAlign.start,
              style: customTextStyle.titleSmall
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              sku,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 2,
            child: Text(
              quantity,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              price,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              subtotal,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }
}

class PurchaseOrderItemListTileWithEditButton extends ConsumerWidget {
  const PurchaseOrderItemListTileWithEditButton(
      {super.key, required this.purchaseOrderItem});

  final PurchaseOrderItem purchaseOrderItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var quantity = purchaseOrderItem.quantity.toString();
    var estimatedPrice =
        currencyController.formatAsPhilippineCurrencyWithoutSymbol(
            amount: purchaseOrderItem.estimatedPrice);
    var subtotal = currencyController.formatAsPhilippineCurrencyWithoutSymbol(
        amount: purchaseOrderItem.getEstimatedSubTotal());
    var itemName = purchaseOrderItem.itemName!;
    var sku = purchaseOrderItem.sku!;
    var units = pluralizationController.pluralize(
        noun: purchaseOrderItem.unitOfMeasurement!,
        count: purchaseOrderItem.quantity);

    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Text(
              itemName,
              textAlign: TextAlign.start,
              style: customTextStyle.titleSmall
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              sku,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 2,
            child: Text(
              "$quantity $units",
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              estimatedPrice,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Expanded(
            flex: 3,
            child: Text(
              subtotal,
              textAlign: TextAlign.center,
              style: customTextStyle.bodyMedium
                  .copyWith(color: lightColorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            )),
        Flexible(
            flex: 1,
            child: LabelButton(
                onTap: () => dialogController.editPurchaseItemOrderDialog(
                    context: context,
                    purchaseOrderItem: purchaseOrderItem,
                    ref: ref),
                label: 'Edit'))
      ],
    );
  }
}

class LabelButton extends StatelessWidget {
  const LabelButton({super.key, required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 24,
        child: Center(
          child: Text(
            label,
            style: customTextStyle.bodyMedium
                .copyWith(color: lightColorScheme.secondary),
          ),
        ),
      ),
    );
  }
}

class PurchaseOrderItemList extends StatelessWidget {
  const PurchaseOrderItemList({super.key, required this.purchaseOrderItemList});

  final List<PurchaseOrderItem> purchaseOrderItemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PurchaseOrderItem data = purchaseOrderItemList[index];
        var unit = pluralizationController.pluralize(
            noun: data.unitOfMeasurement!, count: data.quantity);
        var quantity = '${data.quantity.toString()} $unit';
        var estimatedPrice =
            currencyController.formatAsPhilippineCurrencyWithoutSymbol(
                amount: data.estimatedPrice);
        var getSubtotal = data.getEstimatedSubTotal();
        var subtotal =
            currencyController.formatAsPhilippineCurrency(amount: getSubtotal);

        return PurchaseOrderItemListTile(
            itemName: data.itemName!,
            sku: data.sku!,
            quantity: quantity,
            estimatedPrice: estimatedPrice,
            subtotal: subtotal);
      },
      itemCount: purchaseOrderItemList.length,
    );
  }
}

class NewPurchaseOrderItemList extends StatelessWidget {
  const NewPurchaseOrderItemList(
      {super.key, required this.purchaseOrderItemList});

  final List<PurchaseOrderItem> purchaseOrderItemList;

  @override
  Widget build(BuildContext context) {
    return purchaseOrderItemList.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child:
                ErrorMessage(errorMessage: 'You currently have no orders...'),
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              PurchaseOrderItem data = purchaseOrderItemList[index];

              return PurchaseOrderItemListTileWithEditButton(
                purchaseOrderItem: data,
              );
            },
            itemCount: purchaseOrderItemList.length,
          );
  }
}

class HeadlineSmall extends StatelessWidget {
  const HeadlineSmall({super.key, required this.headline});

  final String headline;

  @override
  Widget build(BuildContext context) {
    return Text(
      headline,
      style: customTextStyle.headlineSmall
          .copyWith(color: lightColorScheme.onBackground),
    );
  }
}

class PlaceOrderChip extends ConsumerStatefulWidget {
  const PlaceOrderChip({super.key, required this.purchaseOrder});

  final PurchaseOrder purchaseOrder;

  @override
  _PlaceOrderChipState createState() => _PlaceOrderChipState();
}

class _PlaceOrderChipState extends ConsumerState<PlaceOrderChip> {
  late final PurchaseOrder purchaseOrder;

  @override
  void initState() {
    super.initState();
    purchaseOrder = widget.purchaseOrder;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var streamPurchaseOrder =
        ref.watch(streamPurchaseOrderProvider(purchaseOrder.purchaseOrderID!));
    Widget? actionChip;

    PlaceOrderState placeOrderState = streamPurchaseOrder.when(
        data: (data) {
          bool orderPlaced = data.orderPlaced!;
          if (orderPlaced) {
            return PlaceOrderState.orderPlaced;
          } else {
            return PlaceOrderState.orderNotPlaced;
          }
        },
        error: (e, st) => PlaceOrderState.disabled,
        loading: () => PlaceOrderState.loading);

    switch (placeOrderState) {
      case PlaceOrderState.orderNotPlaced:
        actionChip = ActionChip(
          side: BorderSide(color: lightColorScheme.primary),
          label: Text(
            'Place Order',
            style: TextStyle(color: lightColorScheme.primary),
          ),
          onPressed: user == null
              ? null
              : () => dialogController.placeOrderDialog(
                  context: context,
                  uid: user.uid,
                  purchaseOrder: purchaseOrder,
                  orderPlaced: true),
        );
        break;
      case PlaceOrderState.loading:
        actionChip = AbsorbPointer(
          child: ActionChip(
            avatar: const CircularProgressIndicator(),
            side: BorderSide(color: lightColorScheme.primary),
            label: Text(
              'Place Order',
              style: TextStyle(color: lightColorScheme.primary),
            ),
            onPressed: () {},
          ),
        );
        break;
      case PlaceOrderState.orderPlaced:
        actionChip = ActionChip(
          side: BorderSide.none,
          avatar: Icon(
            Icons.check,
            color: lightColorScheme.onTertiaryContainer,
          ),
          label: Text(
            'Order Placed',
            style: TextStyle(color: lightColorScheme.onTertiaryContainer),
          ),
          backgroundColor: lightColorScheme.tertiaryContainer,
          onPressed: user == null
              ? null
              : () => dialogController.cancelOrderPlacementDialog(
                  context: context,
                  uid: user.uid,
                  purchaseOrder: purchaseOrder,
                  orderPlaced: false),
        );
        break;
      case PlaceOrderState.disabled:
        actionChip = const ActionChip(
          label: Text(
            'Place Order',
          ),
          onPressed: null,
        );
        break;
    }

    return actionChip;
  }
}

class ConfirmOrderChip extends ConsumerStatefulWidget {
  const ConfirmOrderChip({super.key, required this.purchaseOrder});

  final PurchaseOrder purchaseOrder;

  @override
  _ConfirmOrderChipState createState() => _ConfirmOrderChipState();
}

class _ConfirmOrderChipState extends ConsumerState<ConfirmOrderChip> {
  late final PurchaseOrder purchaseOrder;

  @override
  void initState() {
    super.initState();
    purchaseOrder = widget.purchaseOrder;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var streamPurchaseOrder =
        ref.watch(streamPurchaseOrderProvider(purchaseOrder.purchaseOrderID!));
    Widget? actionChip;

    ConfirmOrderState confirmOrderState = streamPurchaseOrder.when(
        data: (data) {
          var orderPlaced = data.orderPlaced!;
          var orderConfirmed = data.orderConfirmed!;

          if (!orderPlaced) {
            return ConfirmOrderState.disabled;
          } else if (orderPlaced && !orderConfirmed) {
            return ConfirmOrderState.orderNotConfirmed;
          } else {
            return ConfirmOrderState.orderConfirmed;
          }
        },
        error: (e, st) => ConfirmOrderState.disabled,
        loading: () => ConfirmOrderState.loading);

    switch (confirmOrderState) {
      case ConfirmOrderState.orderNotConfirmed:
        actionChip = ActionChip(
          side: BorderSide(color: lightColorScheme.primary),
          label: Text(
            'Confirm Order',
            style: TextStyle(color: lightColorScheme.primary),
          ),
          onPressed: user == null
              ? null
              : () => dialogController.orderConfirmationDialog(
                  context: context,
                  uid: user.uid,
                  purchaseOrder: purchaseOrder,
                  orderConfirmed: true),
        );
        break;
      case ConfirmOrderState.loading:
        actionChip = AbsorbPointer(
          child: ActionChip(
            side: BorderSide(color: lightColorScheme.primary),
            avatar: const CircularProgressIndicator(),
            label: const Text('Confirm Order'),
            onPressed: () {},
          ),
        );
        break;
      case ConfirmOrderState.orderConfirmed:
        actionChip = ActionChip(
          side: BorderSide.none,
          avatar: Icon(
            Icons.check,
            color: lightColorScheme.onTertiaryContainer,
          ),
          label: Text(
            'For Delivery',
            style: TextStyle(color: lightColorScheme.onTertiaryContainer),
          ),
          backgroundColor: lightColorScheme.tertiaryContainer,
          onPressed: user == null
              ? null
              : () => dialogController.cancelOrderConfirmationDialog(
                  context: context,
                  uid: user.uid,
                  purchaseOrder: purchaseOrder,
                  orderConfirmed: false),
        );
        break;
      case ConfirmOrderState.disabled:
        actionChip = const ActionChip(
          label: Text(
            'Confirm Order',
          ),
          onPressed: null,
        );
        break;
    }

    return actionChip;
  }
}

class ConfirmDeliveryChip extends StatefulWidget {
  const ConfirmDeliveryChip({super.key, required this.deliveryState});

  final DeliveryState deliveryState;

  @override
  _ConfirmDeliveryChipState createState() => _ConfirmDeliveryChipState();
}

class _ConfirmDeliveryChipState extends State<ConfirmDeliveryChip> {
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
    Widget? actionChip;

    switch (widget.deliveryState) {
      case DeliveryState.deliveryNotConfirmed:
        actionChip = ActionChip(
          side: BorderSide(color: lightColorScheme.primary),
          label: Text(
            'Confirm Delivery',
            style: TextStyle(color: lightColorScheme.primary),
          ),
          onPressed: () {},
        );
        break;
      case DeliveryState.loading:
        actionChip = AbsorbPointer(
          child: ActionChip(
            avatar: const CircularProgressIndicator(),
            side: BorderSide(color: lightColorScheme.primary),
            label: Text(
              'Confirm Delivery',
              style: TextStyle(color: lightColorScheme.primary),
            ),
            onPressed: () {},
          ),
        );
        break;
      case DeliveryState.deliveryConfirmed:
        actionChip = ActionChip(
          side: BorderSide.none,
          avatar: Icon(
            Icons.check,
            color: lightColorScheme.onTertiaryContainer,
          ),
          label: Text(
            'For Delivery',
            style: TextStyle(color: lightColorScheme.onTertiaryContainer),
          ),
          backgroundColor: lightColorScheme.tertiaryContainer,
          onPressed: () {},
        );
        break;
      case DeliveryState.disabled:
        actionChip = const ActionChip(
          label: Text(
            'Confirm Delivery',
          ),
          onPressed: null,
        );
        break;
    }

    return actionChip;
  }
}

class PurchaseOrderStatus extends StatelessWidget {
  const PurchaseOrderStatus({super.key, required this.purchaseOrder});

  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        PlaceOrderChip(purchaseOrder: purchaseOrder),
        ConfirmOrderChip(purchaseOrder: purchaseOrder)
      ],
    );
  }
}

class PurchaseOrderDetailsItemList extends StatelessWidget {
  const PurchaseOrderDetailsItemList(
      {super.key, required this.purchaseOrderItemList});

  final List<PurchaseOrderItem> purchaseOrderItemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PurchaseOrderItem data = purchaseOrderItemList[index];
        var quantity = data.quantity.toString();
        var estimatedPrice = data.estimatedPrice.toString();
        var subtotal = data.getEstimatedSubTotal().toString();
        return PurchaseOrderItemListTile(
            itemName: data.itemName!,
            sku: data.sku!,
            quantity: quantity,
            estimatedPrice: estimatedPrice,
            subtotal: subtotal);
      },
      itemCount: purchaseOrderItemList.length,
    );
  }
}

class SalesOrderDetailsItemList extends StatelessWidget {
  const SalesOrderDetailsItemList(
      {super.key, required this.salesOrderItemList});

  final List<SalesOrderItemListTileData> salesOrderItemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        SalesOrderItemListTileData data = salesOrderItemList[index];
        return PurchaseOrderItemListTile(
            itemName: data.itemName,
            sku: data.sku,
            quantity: data.quantity,
            estimatedPrice: data.price,
            subtotal: data.subtotal);
      },
      itemCount: salesOrderItemList.length,
    );
  }
}

class OutgoingInventoryFilterChips extends StatefulWidget {
  const OutgoingInventoryFilterChips({super.key});

  @override
  _OutgoingInventoryFilterChips createState() =>
      _OutgoingInventoryFilterChips();
}

class _OutgoingInventoryFilterChips
    extends State<OutgoingInventoryFilterChips> {
  List<String> filters = [
    "All",
    "On Hold",
    "For Release",
  ];

  String selectedFilter = "All"; // Default selected filter

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Adjust the spacing between filter chips
      children: filters.map((filter) {
        return FilterChip(
          label: Text(filter),
          selected: selectedFilter == filter,
          onSelected: (isSelected) {
            _onFilterSelected(filter);
          },
        );
      }).toList(),
    );
  }
}

class ItemSalesSummaryCard extends ConsumerWidget {
  const ItemSalesSummaryCard(this.dailySalesReport, {super.key});

  final DailySalesReport dailySalesReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncItemSalesSummary =
        ref.watch(asyncItemSalesSummaryProvider(dailySalesReport));

    return asyncItemSalesSummary.when(
        data: (data) {
          var itemSalesSummaryList = data;
          var amount = itemSalesSummaryList.fold(
              0.0,
              (previousValue, itemSalesSummary) =>
                  previousValue + itemSalesSummary.subtotal!);
          var totalCost =
              currencyController.formatAsPhilippineCurrency(amount: amount);
          return itemSalesSummaryList.isEmpty
              ? const ErrorMessage(
                  errorMessage: 'You have no sales data for this day...')
              : Card(
                  margin: const EdgeInsets.all(0.0),
                  borderOnForeground: true,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SalesOrderItemListHeader(),
                        ItemSalesSummaryList(
                            itemSalesSummaryList: itemSalesSummaryList),
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
        },
        error: (e, st) {
          print(e);
          print(st);
          return const ErrorMessage(errorMessage: 'Something went wrong...');
        },
        loading: () => const LoadingWidget());
  }
}

class OutgoingInventoryCard extends StatelessWidget {
  final SalesOrder salesOrder;

  const OutgoingInventoryCard({super.key, required this.salesOrder});

  @override
  Widget build(BuildContext context) {
    var customer = Customer.fromMap(salesOrder.customer!);
    var amount = double.tryParse(salesOrder.orderTotal!);
    var totalCost =
        currencyController.formatAsPhilippineCurrency(amount: amount!);
    var salesOrderItemList = salesOrder.getSalesOrderItemList();
    var transactionMadeOn = dateTimeController.formatDateTimeToYMdjm(
        dateTime: salesOrder.transactionMadeOn!);

    return Card(
      margin: const EdgeInsets.all(0.0),
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 4.0,
                    children: [
                      InformationWithLabel(
                          label: 'Customer',
                          data: customer.customerName.isEmpty
                              ? 'Retail Sale'
                              : customer.customerName),
                      InformationWithLabel(
                          label: 'Total Cost', data: totalCost),
                      InformationWithLabel(
                          label: 'Sales Order Number',
                          data: salesOrder.salesOrderNumber!),
                      InformationWithLabel(
                          label: 'Transaction Made On',
                          data: transactionMadeOn),
                      InformationWithLabel(
                          label: 'PaymentTerms', data: salesOrder.paymentTerms!)
                    ],
                  ),
                ),
                /*TextButton(
                    onPressed: () {},
                    child: const Icon(Icons.info_outline_rounded))*/
              ],
            ),
            const Divider(),
            const SalesOrderItemListHeader(),
            SalesOrderItemList(salesOrderItemList: salesOrderItemList),
          ],
        ),
      ),
    );
  }
}

class ItemSalesSummaryList extends StatelessWidget {
  const ItemSalesSummaryList({super.key, required this.itemSalesSummaryList});

  final List<ItemSalesSummary> itemSalesSummaryList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        ItemSalesSummary data = itemSalesSummaryList[index];
        Item item = Item.fromMap(data.item!);
        var quantityDouble = data.quantity;
        var quantity =
            stringController.removeTrailingZeros(value: quantityDouble!);
        var price = currencyController.getAveragePrice(
            quantity: data.quantity!, total: data.subtotal!);
        var subtotal = currencyController.formatAsPhilippineCurrency(
            amount: data.subtotal!);
        return PurchaseOrderItemListTile(
            itemName: item.itemName!,
            sku: item.sku!,
            quantity: quantity,
            estimatedPrice: price,
            subtotal: subtotal);
      },
      itemCount: itemSalesSummaryList.length,
    );
  }
}

class SalesOrderItemList extends StatelessWidget {
  const SalesOrderItemList({super.key, required this.salesOrderItemList});

  final List<SalesOrderItem> salesOrderItemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        SalesOrderItem data = salesOrderItemList[index];
        Item item = Item.fromMap(data.item!);
        var quantityDouble = data.quantity;
        var quantity =
            stringController.removeTrailingZeros(value: quantityDouble!);
        var price = currencyController.getAveragePrice(
            quantity: data.quantity!, total: data.subtotal!);
        var subtotal = currencyController.formatAsPhilippineCurrency(
            amount: data.subtotal!);
        return PurchaseOrderItemListTile(
            itemName: item.itemName!,
            sku: item.sku!,
            quantity: quantity,
            estimatedPrice: price,
            subtotal: subtotal);
      },
      itemCount: salesOrderItemList.length,
    );
  }
}

class CustomerDetailCard extends StatelessWidget {
  const CustomerDetailCard({
    super.key,
    required this.customerName,
    required this.contactNumber,
    required this.contactPerson,
    required this.email,
    required this.address,
  });

  final String customerName;
  final String contactNumber;
  final String contactPerson;
  final String email;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 4.0,
          children: [
            InformationWithLabel(label: 'Customer Name', data: customerName),
            InformationWithLabel(label: 'Contact Number', data: contactNumber),
            InformationWithLabel(label: 'Contact Person', data: contactPerson),
            InformationWithLabel(label: 'Email', data: email),
            InformationWithLabel(label: 'Address', data: address),
          ],
        ),
      ),
    );
  }
}

class SalesOrderStatusFilterChips extends StatefulWidget {
  const SalesOrderStatusFilterChips({super.key, required this.salesOrderState});

  final SalesOrderState salesOrderState;

  @override
  _SalesOrderStatusFilterChips createState() => _SalesOrderStatusFilterChips();
}

class _SalesOrderStatusFilterChips extends State<SalesOrderStatusFilterChips> {
  List<String> filters = ["On Hold", "For Release"];
  late String selectedFilter;

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.salesOrderState.label;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Adjust the spacing between filter chips
      children: filters.map((filter) {
        return FilterChip(
          label: selectedFilter == filter
              ? Text(
                  filter,
                  style: TextStyle(color: lightColorScheme.onTertiaryContainer),
                )
              : Text(filter),
          selectedColor: lightColorScheme.tertiaryContainer,
          selected: selectedFilter == filter,
          onSelected: (isSelected) {
            _onFilterSelected(filter);
          },
        );
      }).toList(),
    );
  }
}

class NewSalesOrderFilterChips extends ConsumerStatefulWidget {
  const NewSalesOrderFilterChips({super.key});

  @override
  _NewSalesOrderFilterChipsState createState() =>
      _NewSalesOrderFilterChipsState();
}

class _NewSalesOrderFilterChipsState
    extends ConsumerState<NewSalesOrderFilterChips> {
  final GlobalKey _selectedChipKey = GlobalKey();
  final GlobalKey _categoryWrapKey = GlobalKey();

  String? _selectedID = 'All';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var categoryFilterList = ref.watch(asyncCategoryFilterListProvider);

    return categoryFilterList.when(
        data: (data) {
          return Wrap(
            key: _categoryWrapKey,
            spacing: 8.0,
            runSpacing: 4.0,
            children: data
                .map(
                  (filter) => FilterChip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    key: filter.categoryID == _selectedID
                        ? _selectedChipKey
                        : null,
                    label: Text(
                      filter.categoryName!,
                    ),
                    selected: filter.categoryID == _selectedID,
                    onSelected: (selected) {
                      setState(() {
                        _selectedID = selected ? filter.categoryID : null;
                      });
                      ref
                          .read(categoryIDProvider.notifier)
                          .setCategoryID(filter.categoryID);
                    },
                  ),
                )
                .toList(),
          );
        },
        error: (e, st) => const SizedBox(
              height: 0.0,
              width: 0.0,
            ),
        loading: () => const LoadingWidget());
  }
}

/*class NewSalesOrderItemCard extends StatelessWidget {
  const NewSalesOrderItemCard(
      {super.key, required this.imageURL, required this.itemName});

  final String imageURL;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWithDynamicSizing(imageURL: imageURL),
            NewSalesOrderItemCardTitle(itemName: itemName),
          ],
        ),
      ),
    );
  }
}*/

class NewSalesOrderItemCard extends ConsumerStatefulWidget {
  const NewSalesOrderItemCard({super.key, required this.retailItem});

  final RetailItem retailItem;

  @override
  _NewSalesOrderItemCardState createState() => _NewSalesOrderItemCardState();
}

class _NewSalesOrderItemCardState extends ConsumerState<NewSalesOrderItemCard> {
  late final RetailItem retailItem;
  late final Item item;
  late final double stockLimit;
  double count = 0.0;

/*  double stockLevel = 0.0;
  List<Stock> stockList = [];*/

  @override
  void initState() {
    super.initState();
    retailItem = widget.retailItem;
    item = Item.fromMap(retailItem.item!);
    stockLimit = retailItem.retailStockLevel!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*var asyncRetailStockList =
        ref.watch(streamRetailStockListProvider(item.itemID!));
    asyncRetailStockList.whenData((value) => stockList = value);
    var stockLevel = stockList.fold(
        0.0, (previousValue, stock) => previousValue + stock.stockLevel!);*/
    var salesOrderCart = ref.watch(salesOrderCartNotifierProvider);
    var orderItem = salesOrderCart.firstWhereOrNull(
        (salesOrderItem) => salesOrderItem.item?['itemID'] == item.itemID);
    var currentStock = stringController.removeTrailingZeros(
        value: retailItem.retailStockLevel!);
    /*var currentStock = stringController.removeTrailingZeros(value: stockLevel);*/
    var unit = pluralizationController.pluralize(
        noun: item.unitOfMeasurement!, count: count);

    if (orderItem != null) {
      setState(() {
        count = orderItem.quantity!;
      });
    } else {
      setState(() {
        count = 0.0;
      });
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => salesOrderController.addSalesOrderItem(
            ref: ref,
            retailItem: retailItem,
            stockLimit: stockLimit,
            count: count),
        onLongPress: () => ref
            .read(salesOrderCartNotifierProvider.notifier)
            .removeItem(item.itemID!),
        onDoubleTap: () => dialogController.addCustomItemOrderDialog(
            context: context, ref: ref, retailItem: retailItem),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ItemCardImage(
                imageURL: item.imageURL!,
              ),
              const Padding(padding: EdgeInsets.only(left: 8.0)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.itemName!,
                            style: customTextStyle.titleMedium
                                .copyWith(color: lightColorScheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.sku!,
                            style: customTextStyle.bodyMedium
                                .copyWith(color: lightColorScheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Current Stock: $currentStock $unit',
                            style: customTextStyle.labelMedium
                                .copyWith(color: lightColorScheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageWithDynamicSizing extends StatelessWidget {
  const ImageWithDynamicSizing({super.key, required this.imageURL});

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxWidth,
        width: constraints.maxWidth,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: imageURL,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
            ),
          ),
          errorWidget: (context, url, error) {
            debugPrint('Error loading image: $error');
            return Image.network(
              defaultMerchantImageUrl,
              fit: BoxFit.cover,
            );
          },
          fit: BoxFit.cover,
        ),
      );
    });
  }
}

class OrderSummaryListTile extends StatelessWidget {
  const OrderSummaryListTile(
      {super.key,
      required this.itemName,
      required this.subTotal,
      required this.itemCount});

  final String itemName;
  final String subTotal;
  final String itemCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: customTextStyle.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'x $itemCount',
                  style: customTextStyle.labelMedium,
                ),
              ],
            )),
        Flexible(
            flex: 2,
            child: Text(
              subTotal,
              style: customTextStyle.bodyMedium,
            )),
      ],
    );
  }
}

class SaleTypeDropDownMenu extends ConsumerStatefulWidget {
  const SaleTypeDropDownMenu({super.key});

  @override
  _SaleTypeDropDownMenuState createState() => _SaleTypeDropDownMenuState();
}

class _SaleTypeDropDownMenuState extends ConsumerState<SaleTypeDropDownMenu> {
  SaleType? selectedSaleType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<SaleType>> saleTypeEntries =
        <DropdownMenuEntry<SaleType>>[];
    for (final SaleType saleType in SaleType.values) {
      saleTypeEntries.add(
        DropdownMenuEntry<SaleType>(value: saleType, label: saleType.label),
      );
    }

    return DropdownMenu<SaleType>(
      initialSelection: ref.watch(saleTypeProvider),
      enableFilter: false,
      enableSearch: false,
      label: const Text('Sale Type'),
      dropdownMenuEntries: saleTypeEntries,
      onSelected: (SaleType? saleType) {
        setState(() {
          selectedSaleType = saleType;
        });
        ref.read(saleTypeProvider.notifier).state = saleType!;
      },
    );
  }
}

class CustomerDropDownMenu extends ConsumerStatefulWidget {
  const CustomerDropDownMenu({super.key});

  @override
  _CustomerDropDownMenuState createState() => _CustomerDropDownMenuState();
}

class _CustomerDropDownMenuState extends ConsumerState<CustomerDropDownMenu> {
  Customer? selectedCustomer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var asyncCustomerList = ref.watch(streamCustomerListProvider);

    return asyncCustomerList.when(
      data: (data) {
        var customerList = data;

        final List<DropdownMenuEntry<Customer>> customerEntries =
            <DropdownMenuEntry<Customer>>[];
        for (final Customer customer in customerList) {
          customerEntries.add(
            DropdownMenuEntry<Customer>(
                value: customer, label: customer.customerName),
          );
        }

        return DropdownMenu<Customer>(
          enableFilter: false,
          enableSearch: false,
          label: const Text('Customer'),
          dropdownMenuEntries: customerEntries,
          onSelected: (Customer? customer) {
            setState(() {
              selectedCustomer = customer;
            });
            ref.read(customerSelectionProvider.notifier).setCustomer(customer!);
          },
        );
      },
      error: (e, st) => const DropdownMenu(
        dropdownMenuEntries: [],
        enabled: false,
        label: Text('Customer'),
      ),
      loading: () => const DropdownMenu(
        dropdownMenuEntries: [],
        enabled: false,
        label: Text('Customer'),
      ),
    );
  }
}

class PaymentTermsDropDownMenu extends ConsumerStatefulWidget {
  const PaymentTermsDropDownMenu({super.key});

  @override
  _PaymentTermsDropDownMenuState createState() =>
      _PaymentTermsDropDownMenuState();
}

class _PaymentTermsDropDownMenuState
    extends ConsumerState<PaymentTermsDropDownMenu> {
  PaymentTerm? selectedPaymentTerm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<PaymentTerm>> paymentTermEntries =
        <DropdownMenuEntry<PaymentTerm>>[];
    for (final PaymentTerm paymentTerm in PaymentTerm.values) {
      paymentTermEntries.add(
        DropdownMenuEntry<PaymentTerm>(
            value: paymentTerm, label: paymentTerm.label),
      );
    }

    return DropdownMenu<PaymentTerm>(
      initialSelection: ref.watch(paymentTermsProvider),
      enableFilter: false,
      enableSearch: false,
      label: const Text('Payment Terms'),
      dropdownMenuEntries: paymentTermEntries,
      onSelected: (PaymentTerm? paymentTerm) {
        setState(() {
          selectedPaymentTerm = paymentTerm;
        });

        ref.read(paymentTermsProvider.notifier).state = paymentTerm!;
      },
    );
  }
}

/*class SalespersonDropDownMenu extends ConsumerStatefulWidget {
  const SalespersonDropDownMenu({super.key});

  @override
  _SalespersonDropDownMenuState createState() =>
      _SalespersonDropDownMenuState();
}

class _SalespersonDropDownMenuState
    extends ConsumerState<SalespersonDropDownMenu> {
  Salesperson? selectedSalesperson;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var asyncSalesPersonList = ref.watch(salespersonListStreamProvider);

    return asyncSalesPersonList.when(
        data: (data) {
          var salespersonList = data;

          final List<DropdownMenuEntry<Salesperson>> salespersonEntries =
              <DropdownMenuEntry<Salesperson>>[];
          for (final Salesperson salesperson in salespersonList) {
            salespersonEntries.add(
              DropdownMenuEntry<Salesperson>(
                  value: salesperson, label: salesperson.salespersonName!),
            );
          }

          return DropdownMenu<Salesperson>(
            enableFilter: false,
            enableSearch: false,
            label: const Text('Salesperson'),
            dropdownMenuEntries: salespersonEntries,
            onSelected: (Salesperson? salesperson) {
              setState(() {
                selectedSalesperson = salesperson;
              });
              ref
                  .read(salesPersonSelectionProvider.notifier)
                  .setSalesperson(salesperson!);
            },
          );
        },
        error: (e, st) => const DropdownMenu(
            dropdownMenuEntries: [],
            enabled: false,
            label: Text('Salesperson')),
        loading: () => const DropdownMenu(
            dropdownMenuEntries: [],
            enabled: false,
            label: Text('Salesperson')));
  }
}*/

class CustomerTypeDropDownMenu extends ConsumerStatefulWidget {
  const CustomerTypeDropDownMenu({super.key});

  @override
  _CustomerTypeDropDownMenuState createState() =>
      _CustomerTypeDropDownMenuState();
}

class _CustomerTypeDropDownMenuState
    extends ConsumerState<CustomerTypeDropDownMenu> {
  CustomerType? selectedCustomerType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<CustomerType>> customerTypeEntries =
        <DropdownMenuEntry<CustomerType>>[];
    for (final CustomerType customerType in CustomerType.values) {
      customerTypeEntries.add(
        DropdownMenuEntry<CustomerType>(
            value: customerType, label: customerType.label),
      );
    }

    return DropdownMenu<CustomerType>(
      initialSelection: ref.watch(customerTypeProvider),
      enableFilter: false,
      enableSearch: false,
      label: const Text('CustomerType'),
      dropdownMenuEntries: customerTypeEntries,
      onSelected: (CustomerType? customerType) {
        setState(() {
          selectedCustomerType = customerType;
        });
        ref.read(customerTypeProvider.notifier).state = customerType!;
      },
    );
  }
}

class ProductFilterChips extends StatefulWidget {
  const ProductFilterChips({super.key, required this.filters});

  final List<String> filters;

  @override
  _ProductFilterChipsState createState() => _ProductFilterChipsState();
}

class _ProductFilterChipsState extends State<ProductFilterChips> {
  late List<String> filters;
  String selectedFilter = "All"; // Default selected filter

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  void initState() {
    super.initState();
    filters = widget.filters;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Adjust the spacing between filter chips
      children: filters.map((filter) {
        return FilterChip(
          label: Text(filter),
          selected: selectedFilter == filter,
          onSelected: (isSelected) {
            _onFilterSelected(filter);
          },
        );
      }).toList(),
    );
  }
}

class PurchaseOrderItemCard extends StatelessWidget {
  final Item item;

  const PurchaseOrderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(padding: EdgeInsets.only(left: 8.0)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.sku!,
                          style: customTextStyle.titleMedium
                              .copyWith(color: lightColorScheme.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.itemName!,
                          style: customTextStyle.bodyMedium
                              .copyWith(color: lightColorScheme.onSurface),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ItemCardImage(
              imageURL: item.imageURL!,
            ),
            const Padding(padding: EdgeInsets.only(left: 8.0)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.itemName!,
                          style: customTextStyle.titleMedium
                              .copyWith(color: lightColorScheme.onSurface),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.sku!,
                          style: customTextStyle.bodyMedium
                              .copyWith(color: lightColorScheme.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ItemMoreMenuButton(item: item)
          ],
        ),
      ),
    );
  }
}

class ItemCardImage extends StatelessWidget {
  const ItemCardImage({super.key, required this.imageURL});

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        height: constraints.maxHeight,
        width: constraints.maxHeight,
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: imageURL,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
            ),
          ),
          errorWidget: (context, url, error) {
            debugPrint('Error loading image: $error');
            return Image.network(
              defaultMerchantImageUrl,
              fit: BoxFit.cover,
            );
          },
          fit: BoxFit.cover,
        ),
      );
    });
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorMessage));
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ItemCategoryFilterChips extends ConsumerStatefulWidget {
  const ItemCategoryFilterChips(this.categoryFilters, {super.key});

  final List<CategoryFilter> categoryFilters;

  @override
  _ItemCategoryFilterChipsState createState() =>
      _ItemCategoryFilterChipsState();
}

class _ItemCategoryFilterChipsState
    extends ConsumerState<ItemCategoryFilterChips> {
  final GlobalKey _selectedChipKey = GlobalKey();
  final GlobalKey _categoryWrapKey = GlobalKey();

  String? _selectedID = 'All';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: _categoryWrapKey,
      spacing: 8.0,
      runSpacing: 4.0,
      children: widget.categoryFilters
          .map(
            (filter) => FilterChip(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              key: filter.categoryID == _selectedID ? _selectedChipKey : null,
              label: Text(
                filter.categoryName!,
              ),
              selected: filter.categoryID == _selectedID,
              onSelected: (selected) {
                setState(() {
                  _selectedID = selected ? filter.categoryID : null;
                });
                ref
                    .read(categoryIDProvider.notifier)
                    .setCategoryID(filter.categoryID);
              },
            ),
          )
          .toList(),
    );
  }
}

class LocationTypeDropDownMenu extends ConsumerStatefulWidget {
  const LocationTypeDropDownMenu({super.key});

  @override
  _LocationTypeDropDownMenu createState() => _LocationTypeDropDownMenu();
}

class _LocationTypeDropDownMenu
    extends ConsumerState<LocationTypeDropDownMenu> {
  InventoryLocationType? selectedInventoryLocationType;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<InventoryLocationType>>
        inventoryLocationTypeEntries =
        <DropdownMenuEntry<InventoryLocationType>>[];
    for (final InventoryLocationType inventoryLocationType
        in InventoryLocationType.values) {
      inventoryLocationTypeEntries.add(
        DropdownMenuEntry<InventoryLocationType>(
            value: inventoryLocationType, label: inventoryLocationType.label),
      );
    }

    return DropdownMenu<InventoryLocationType>(
      initialSelection: ref.read(inventoryLocationTypeProvider),
      enableFilter: false,
      enableSearch: false,
      label: const Text('Location Type'),
      dropdownMenuEntries: inventoryLocationTypeEntries,
      onSelected: (InventoryLocationType? inventoryLocationType) {
        setState(() {
          selectedInventoryLocationType = inventoryLocationType;
        });
        ref.read(inventoryLocationTypeProvider.notifier).state =
            inventoryLocationType!;
      },
    );
  }
}

class StockLocationCard extends StatelessWidget {
  const StockLocationCard({super.key, required this.stockLocation});

  final StockLocation stockLocation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SubLocationManagement(stockLocation: stockLocation))),
      child: Card(
        borderOnForeground: true,
        child: ListTile(
          title: Text(stockLocation.locationName),
          subtitle: Text(
            stockLocation.type,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class DeleteLocationButton extends ConsumerWidget {
  const DeleteLocationButton(this.stockLocation, {super.key});

  final StockLocation stockLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    var stockLocationList =
        ref.watch(streamSubLocationListProvider(stockLocation.documentPath!));

    return IconButton(
        onPressed: () => user == null
            ? null
            : stockLocationList.value!.isNotEmpty
                ? snackBarController.showSnackBarError(
                    "You cannot delete locations which has sublocations...")
                : dialogController.removeLocationDialog(
                    context: context,
                    uid: user.uid,
                    stockLocation: stockLocation),
        icon: const Icon(Icons.remove_circle_outline));
  }
}

class SupplierMoreMenuButton extends ConsumerWidget {
  const SupplierMoreMenuButton({super.key, required this.supplier});

  final Supplier supplier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return user == null
        ? const SizedBox(
            height: 0.0,
            width: 0.0,
          )
        : MenuAnchor(
            menuChildren: [
              MenuItemButton(
                  onPressed: () => navigationController.navigateToEditSupplier(
                      supplier: supplier),
                  child: const Text('Edit')),
              MenuItemButton(
                  onPressed: () => dialogController.removeSupplierDialog(
                      context: context, uid: user.uid, supplier: supplier),
                  child: const Text('Delete'))
            ],
            builder: (context, controller, child) {
              return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_horiz_outlined));
            },
          );
  }
}

class ItemMoreMenuButton extends ConsumerWidget {
  const ItemMoreMenuButton({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return user == null
        ? const SizedBox(
            height: 0.0,
            width: 0.0,
          )
        : MenuAnchor(
            menuChildren: [
              MenuItemButton(
                  onPressed: () =>
                      navigationController.navigateToEditItem(item: item),
                  child: const Text('Edit')),
              MenuItemButton(
                  onPressed: () =>
                      itemController.removeItem(uid: user.uid, item: item),
                  child: const Text('Delete'))
            ],
            builder: (context, controller, child) {
              return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_horiz_outlined));
            },
          );
  }
}

class StockMoreMenuButton extends StatelessWidget {
  const StockMoreMenuButton({super.key, required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    Item item = Item.fromMap(stock.item!);
    var itemID = item.itemID;
    var uid = item.uid;

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
            onPressed: () =>
                navigationController.navigateToMoveInventory(stock: stock),
            child: const Text('Move')),
        MenuItemButton(
            onPressed: () =>
                navigationController.navigateToAdjustInventory(stock: stock),
            child: const Text('Adjust')),
        MenuItemButton(
            onPressed: () => dialogController.setAsRetailStockDialog(
                context: context, uid: uid!, itemID: itemID!, stock: stock),
            child: const Text('Set As Retail Stock'))
      ],
      builder: (context, controller, child) {
        return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_horiz_outlined));
      },
    );
  }
}

class RetailStockMoreMenuButton extends StatelessWidget {
  const RetailStockMoreMenuButton({super.key, required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    Item item = Item.fromMap(stock.item!);
    var itemID = item.itemID;
    var uid = item.uid;

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
            onPressed: () => dialogController.removeFromRetailStockDialog(
                context: context, uid: uid!, itemID: itemID!, stock: stock),
            child: const Text('Remove From Retail Stock'))
      ],
      builder: (context, controller, child) {
        return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_horiz_outlined));
      },
    );
  }
}

class LocationDropDownMenu extends ConsumerStatefulWidget {
  const LocationDropDownMenu({super.key});

  @override
  _LocationDropDownMenu createState() => _LocationDropDownMenu();
}

class _LocationDropDownMenu extends ConsumerState<LocationDropDownMenu> {
  StockLocation? selectedStockLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var asyncLocationList = ref.watch(streamLocationDataListProvider);

    return asyncLocationList.when(
        data: (data) {
          var locationList = data;
          final List<DropdownMenuEntry<StockLocation>> stockLocationEntries =
              <DropdownMenuEntry<StockLocation>>[];
          for (final StockLocation stockLocation in locationList) {
            stockLocationEntries.add(
              DropdownMenuEntry<StockLocation>(
                  value: stockLocation, label: stockLocation.locationAddress),
            );
          }
          return DropdownMenu<StockLocation>(
            enableFilter: true,
            enableSearch: true,
            label: const Text('Stock Location (Required)'),
            dropdownMenuEntries: stockLocationEntries,
            onSelected: (StockLocation? stockLocation) {
              setState(() {
                selectedStockLocation = stockLocation;
              });
              ref
                  .read(locationSelectionProvider.notifier)
                  .setLocation(stockLocation!);
            },
          );
        },
        error: (e, st) => const SizedBox(
              height: 0.0,
              width: 0.0,
            ),
        loading: () => const SizedBox(
              height: 0.0,
              width: 0.0,
            ));
  }
}

class PerishabilityDropDownMenu extends ConsumerStatefulWidget {
  const PerishabilityDropDownMenu({super.key});

  @override
  _PerishabilityDropDownMenu createState() => _PerishabilityDropDownMenu();
}

class _PerishabilityDropDownMenu
    extends ConsumerState<PerishabilityDropDownMenu> {
  Perishability? selectedPerishability;

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
    final List<DropdownMenuEntry<Perishability>> perishabilityEntries =
        <DropdownMenuEntry<Perishability>>[];
    for (final Perishability perishability in Perishability.values) {
      perishabilityEntries.add(
        DropdownMenuEntry<Perishability>(
            value: perishability, label: perishability.label),
      );
    }

    return DropdownMenu<Perishability>(
      initialSelection: ref.read(perishabilityProvider),
      enableFilter: false,
      enableSearch: false,
      label: const Text('Perishability (Required)'),
      dropdownMenuEntries: perishabilityEntries,
      onSelected: (Perishability? perishability) {
        setState(() {
          selectedPerishability = perishability;
        });
        ref.read(perishabilityProvider.notifier).state = perishability!;
      },
    );
  }
}

class SupplierDropDownMenu extends ConsumerStatefulWidget {
  const SupplierDropDownMenu({super.key});

  @override
  _SupplierDropDownMenuState createState() => _SupplierDropDownMenuState();
}

class _SupplierDropDownMenuState extends ConsumerState<SupplierDropDownMenu> {
  Supplier? selectedSupplier;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var asyncSupplierList = ref.watch(streamSupplierListProvider);

    return asyncSupplierList.when(
        data: (data) {
          var supplierList = data;
          final List<DropdownMenuEntry<Supplier>> supplierEntries =
              <DropdownMenuEntry<Supplier>>[];
          for (final Supplier supplier in supplierList) {
            supplierEntries.add(
              DropdownMenuEntry<Supplier>(
                  value: supplier, label: supplier.supplierName),
            );
          }
          return DropdownMenu<Supplier>(
            enableFilter: false,
            enableSearch: false,
            label: const Text('Supplier (Required)'),
            dropdownMenuEntries: supplierEntries,
            onSelected: (Supplier? supplier) {
              setState(() {
                selectedSupplier = supplier;
              });
              ref
                  .read(supplierSelectionProvider.notifier)
                  .setSupplier(supplier!);
            },
          );
        },
        error: (e, st) => const SizedBox(
              height: 0.0,
              width: 0.0,
            ),
        loading: () => const SizedBox(
              height: 0.0,
              width: 0.0,
            ));
  }
}

class MoveInventoryLocationDropDownMenu extends ConsumerStatefulWidget {
  const MoveInventoryLocationDropDownMenu(this.stockLocationList, {super.key});

  final List<StockLocation> stockLocationList;

  @override
  _MoveInventoryLocationDropDownMenu createState() =>
      _MoveInventoryLocationDropDownMenu();
}

class _MoveInventoryLocationDropDownMenu
    extends ConsumerState<MoveInventoryLocationDropDownMenu> {
  StockLocation? selectedStockLocation;
  late final List<StockLocation> locationList;

  @override
  void initState() {
    super.initState();
    locationList = widget.stockLocationList;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<StockLocation>> stockLocationEntries =
        <DropdownMenuEntry<StockLocation>>[];
    for (final StockLocation stockLocation in locationList) {
      stockLocationEntries.add(
        DropdownMenuEntry<StockLocation>(
            value: stockLocation, label: stockLocation.locationAddress),
      );
    }
    return DropdownMenu<StockLocation>(
      enableFilter: true,
      enableSearch: true,
      label: const Text('New Stock Location (Required)'),
      dropdownMenuEntries: stockLocationEntries,
      onSelected: (StockLocation? stockLocation) {
        setState(() {
          selectedStockLocation = stockLocation;
        });
        ref
            .read(locationSelectionProvider.notifier)
            .setLocation(stockLocation!);
      },
    );
  }
}

class MoveInventoryInformationCard extends StatelessWidget {
  const MoveInventoryInformationCard(
      {super.key,
      required this.currentLocation,
      required this.currentStockLevel,
      required this.retainedStockLevel});

  final String currentLocation;
  final String currentStockLevel;
  final String retainedStockLevel;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 4.0,
          children: [
            InformationWithLabelLarge(
                label: 'Current Stock Location', data: currentLocation),
            InformationWithLabelLarge(
                label: 'Current Stock Level', data: currentStockLevel),
            InformationWithLabelLarge(
                label: 'Retained Stock', data: retainedStockLevel)
          ],
        ),
      ),
    );
  }
}

class InventoryTransactionCard extends StatelessWidget {
  const InventoryTransactionCard(
      {super.key, required this.inventoryTransaction});

  final InventoryTransaction inventoryTransaction;

  @override
  Widget build(BuildContext context) {
    var transactionMadeOn = dateTimeController.formatDateTimeToYMdjm(
        dateTime: inventoryTransaction.transactionMadeOn);
    return Card(
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 4.0,
          children: [
            InformationWithLabel(
                label: 'Transaction',
                data: inventoryTransaction.transactionType),
            InformationWithLabel(
                label: 'Change in Quantity',
                data: inventoryTransaction.quantityChange.toString()),
            InformationWithLabel(
                label: 'Transaction Made On', data: transactionMadeOn),
            InformationWithLabel(
                label: 'Reason', data: inventoryTransaction.reason)
          ],
        ),
      ),
    );
  }
}

class ReceiveOrderButton extends ConsumerWidget {
  const ReceiveOrderButton(this.purchaseOrder, {super.key});

  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    var asyncStreamPurchaseOrder =
        ref.watch(streamPurchaseOrderProvider(purchaseOrder.purchaseOrderID!));

    return asyncStreamPurchaseOrder.when(data: (data) {
      var orderConfirmed = data.orderConfirmed!;
      return orderConfirmed && user != null
          ? FilledButton(
              onPressed: () => dialogController.receivePurchaseOrderDialog(
                  context: context,
                  uid: user.uid,
                  purchaseOrder: purchaseOrder),
              child: const Text('Receive Order'))
          : const FilledButton(onPressed: null, child: Text('Receive Order'));
    }, error: (e, st) {
      return const FilledButton(onPressed: null, child: Text('Receive Order'));
    }, loading: () {
      return const FilledButton(onPressed: null, child: Text('Receive Order'));
    });
  }
}

class PurchaseOrderEditButton extends ConsumerWidget {
  const PurchaseOrderEditButton(this.purchaseOrder, {super.key});

  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncStreamPurchaseOrder =
        ref.watch(streamPurchaseOrderProvider(purchaseOrder.purchaseOrderID!));

    return asyncStreamPurchaseOrder.when(data: (data) {
      var orderPlaced = data.orderPlaced!;
      return !orderPlaced
          ? OutlinedButton(
              onPressed: () => navigationController.navigateToEditPurchaseOrder(
                  purchaseOrder: purchaseOrder),
              child: const Text('Edit Order'))
          : const OutlinedButton(onPressed: null, child: Text('Edit Order'));
    }, error: (e, st) {
      return const OutlinedButton(onPressed: null, child: Text('Edit Order'));
    }, loading: () {
      return const OutlinedButton(onPressed: null, child: Text('Edit Order'));
    });
  }
}

class VoidPurchaseOrderButton extends ConsumerWidget {
  const VoidPurchaseOrderButton(this.purchaseOrder, {super.key});

  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return TextButton(
        onPressed: user == null
            ? null
            : () => dialogController.cancelPurchaseOrderDialog(
                context: context, uid: user.uid, purchaseOrder: purchaseOrder),
        child: Text(
          'Void',
          style: TextStyle(color: lightColorScheme.error),
        ));
  }
}

class EditSupplierDropDownMenu extends ConsumerStatefulWidget {
  const EditSupplierDropDownMenu(this.supplier, {super.key});

  final Supplier supplier;

  @override
  _EditSupplierDropDownMenuState createState() =>
      _EditSupplierDropDownMenuState();
}

class _EditSupplierDropDownMenuState
    extends ConsumerState<EditSupplierDropDownMenu> {
  Supplier? selectedSupplier;

  final TextEditingController dropDownMenuController = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedSupplier = widget.supplier;
    Future.delayed(Duration.zero, () async {
      ref
          .read(supplierSelectionProvider.notifier)
          .setSupplier(selectedSupplier!);
    });
  }

  @override
  void dispose() {
    super.dispose();
    dropDownMenuController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var asyncSupplierList = ref.watch(streamSupplierListProvider);

    return asyncSupplierList.when(
        data: (data) {
          var supplierList = data;
          final List<DropdownMenuEntry<Supplier>> supplierEntries =
              <DropdownMenuEntry<Supplier>>[];
          for (final Supplier supplier in supplierList) {
            supplierEntries.add(
              DropdownMenuEntry<Supplier>(
                  value: supplier, label: supplier.supplierName),
            );
          }

          debugPrint(supplierEntries.length.toString());

          var initialSelection = supplierList.firstWhere(
              (element) => selectedSupplier!.supplierID == element.supplierID);

          return DropdownMenu<Supplier>(
            initialSelection: initialSelection,
            controller: dropDownMenuController,
            enableFilter: false,
            enableSearch: false,
            label: const Text('Supplier (Required)'),
            dropdownMenuEntries: supplierEntries,
            onSelected: (Supplier? supplier) {
              setState(() {
                selectedSupplier = supplier;
              });
              ref
                  .read(supplierSelectionProvider.notifier)
                  .setSupplier(supplier!);
            },
          );
        },
        error: (e, st) => const SizedBox(
              height: 0.0,
              width: 0.0,
            ),
        loading: () => const SizedBox(
              height: 0.0,
              width: 0.0,
            ));
  }
}

class RetailInventoryItemCard extends StatelessWidget {
  final RetailItem retailItem;

  const RetailInventoryItemCard({super.key, required this.retailItem});

  @override
  Widget build(BuildContext context) {
    Item item = Item.fromMap(retailItem.item!);
    var unit = item.unitOfMeasurement!;
    var stockLevel = retailItem.retailStockLevel;
    var pluralizedUnit =
        pluralizationController.pluralize(noun: unit, count: stockLevel!);

    return Card(
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 78,
        width: 244,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName!,
                    style: customTextStyle.titleMedium
                        .copyWith(color: lightColorScheme.onSurface),
                  ),
                  Text(
                    item.sku!,
                    style: customTextStyle.bodyMedium
                        .copyWith(color: lightColorScheme.onSurface),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stock Level:',
                      style: customTextStyle.labelMedium,
                    ),
                    Text(
                      '${stockLevel.toString()} $pluralizedUnit',
                      style: customTextStyle.labelMedium,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
