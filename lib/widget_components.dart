// ignore_for_file: library_private_types_in_public_api

import 'package:accustox/color_scheme.dart';
import 'package:accustox/controllers.dart';
import 'package:accustox/sub_location_management.dart';
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

class IncomingInventoryFilterChips extends StatefulWidget {
  const IncomingInventoryFilterChips({super.key});

  @override
  _IncomingInventoryFilterChipsState createState() =>
      _IncomingInventoryFilterChipsState();
}

class _IncomingInventoryFilterChipsState
    extends State<IncomingInventoryFilterChips> {
  List<String> filters = [
    "All",
    "For Placement",
    "For Confirmation",
    "For Delivery"
  ];
  String selectedFilter = "All"; // Default selected filter

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });

    // You can implement filtering logic here based on the selected filter.
    // For now, let's print the selected filter.
    print("Selected Filter: $selectedFilter");
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

class CurrentInventoryFilterChips extends StatefulWidget {
  const CurrentInventoryFilterChips({super.key});

  @override
  _CurrentInventoryFilterChipsState createState() =>
      _CurrentInventoryFilterChipsState();
}

class _CurrentInventoryFilterChipsState
    extends State<CurrentInventoryFilterChips> {
  List<String> filters = ["All", "In Stock", "For Reorder", "Out of Stock"];
  String selectedFilter = "All"; // Default selected filter

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });

    // You can implement filtering logic here based on the selected filter.
    // For now, let's print the selected filter.
    print("Selected Filter: $selectedFilter");
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

class CurrentInventoryItemCard extends StatelessWidget {
  const CurrentInventoryItemCard(
      {super.key,
      required this.itemName,
      required this.sku,
      required this.stockLevel,
      required this.stockLevelState});

  final String itemName;
  final String sku;
  final double stockLevel;
  final StockLevelState stockLevelState;

  @override
  Widget build(BuildContext context) {
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
                    itemName,
                    style: customTextStyle.titleMedium
                        .copyWith(color: lightColorScheme.onSurface),
                  ),
                  Text(
                    sku,
                    style: customTextStyle.bodyMedium
                        .copyWith(color: lightColorScheme.onSurface),
                  ),
                ],
              ),
            ),
            StockLevelNotification(
                stockLevel: stockLevel, stockLevelState: stockLevelState)
          ],
        ),
      ),
    );
  }
}

class StockLevelNotification extends StatelessWidget {
  const StockLevelNotification(
      {super.key, required this.stockLevel, required this.stockLevelState});

  final double stockLevel;
  final StockLevelState stockLevelState;

  @override
  Widget build(BuildContext context) {
    Color? color;
    Color? textColor;

    switch (stockLevelState) {
      case StockLevelState.inStock:
        color = lightColorScheme.tertiaryContainer;
        textColor = lightColorScheme.onTertiaryContainer;
        break;
      case StockLevelState.lowStock:
        color = lightCustomColors.mikadoyellowContainer;
        textColor = lightCustomColors.onMikadoyellowContainer;
        break;
      case StockLevelState.outOfStock:
        color = lightCustomColors.redalertContainer;
        textColor = lightCustomColors.onRedalertContainer;
        break;
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
              stockLevel.toString(),
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
  const ItemDetailsCard({super.key, required this.itemDetailsData});

  final ItemDetailsData itemDetailsData;

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
              ItemPicture(imageURL: itemDetailsData.imageURL),
              const Padding(padding: EdgeInsets.only(left: 8.0)),
              ItemDetails(
                  itemName: itemDetailsData.itemName,
                  sku: itemDetailsData.sku,
                  ean: itemDetailsData.ean,
                  productID: itemDetailsData.productID,
                  manufacturer: itemDetailsData.manufacturer,
                  brand: itemDetailsData.brand,
                  country: itemDetailsData.country,
                  productType: itemDetailsData.productType,
                  unitOfMeasurement: itemDetailsData.unitOfMeasurement,
                  manufacturerPartNumber:
                      itemDetailsData.manufacturerPartNumber)
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
          data,
          style: customTextStyle.bodyMedium
              .copyWith(color: lightColorScheme.onSurface),
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
          data,
          style: customTextStyle.bodyLarge
              .copyWith(color: lightColorScheme.onSurface),
        ),
      ],
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails(
      {super.key,
      required this.itemName,
      required this.sku,
      required this.ean,
      required this.productID,
      required this.manufacturer,
      required this.brand,
      required this.country,
      required this.productType,
      required this.unitOfMeasurement,
      required this.manufacturerPartNumber});

  final String itemName;
  final String sku;
  final String ean;
  final String productID;
  final String manufacturer;
  final String brand;
  final String country;
  final String productType;
  final String unitOfMeasurement;
  final String manufacturerPartNumber;

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
            ItemTitle(itemName: itemName),
            EditItemButton(onPressed: () {})
          ],
        ),
        Wrap(
          runSpacing: 4.0,
          spacing: 16.0,
          children: [
            InformationWithLabel(label: 'SKU', data: sku),
            InformationWithLabel(label: 'EAN', data: ean),
            InformationWithLabel(label: 'ProductID', data: productID),
            InformationWithLabel(
                label: 'Manufacturer Part Number',
                data: manufacturerPartNumber),
            InformationWithLabel(label: 'Manufacturer', data: manufacturer),
            InformationWithLabel(label: 'Brand', data: brand),
            InformationWithLabel(label: 'Country', data: country),
            InformationWithLabel(label: 'Product Type', data: productType),
            InformationWithLabel(
                label: 'Unit of Measurement', data: unitOfMeasurement)
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

class ItemInventoryCard extends StatelessWidget {
  const ItemInventoryCard(
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
              TextButton(onPressed: onPressed, child: const Text('Transfer'))
            ],
          ),
        ),
      ),
    );
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
      required this.supplierName,
      required this.purchaseOrderNumber,
      required this.estimatedTotalCost,
      required this.deliveryAddress,
      required this.expectedDeliveryDate,
      required this.purchaseOrderItemList,
      required this.incomingInventoryState});

  final String supplierName;
  final String purchaseOrderNumber;
  final String estimatedTotalCost;
  final String deliveryAddress;
  final String expectedDeliveryDate;
  final List<PurchaseOrderItemListTileData> purchaseOrderItemList;
  final IncomingInventoryState incomingInventoryState;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                              label: 'Supplier', data: supplierName),
                          InformationWithLabel(
                              label: 'Estimated Total Cost',
                              data: estimatedTotalCost),
                          InformationWithLabel(
                              label: 'Purchase Order Number',
                              data: purchaseOrderNumber),
                          InformationWithLabel(
                              label: 'Delivery Address', data: deliveryAddress),
                          InformationWithLabel(
                              label: 'Expected Delivery Date',
                              data: expectedDeliveryDate)
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
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

class PurchaseOrderItemListTileWithEditButton extends StatelessWidget {
  const PurchaseOrderItemListTileWithEditButton(
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
        Flexible(flex: 1, child: LabelButton(onTap: () {}, label: 'Edit'))
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

  final List<PurchaseOrderItemListTileData> purchaseOrderItemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PurchaseOrderItemListTileData data = purchaseOrderItemList[index];
        return PurchaseOrderItemListTile(
            itemName: data.itemName,
            sku: data.sku,
            quantity: data.quantity,
            estimatedPrice: data.estimatedPrice,
            subtotal: data.subtotal);
      },
      itemCount: purchaseOrderItemList.length,
    );
  }
}

class NewPurchaseOrderItemList extends StatelessWidget {
  const NewPurchaseOrderItemList(
      {super.key, required this.purchaseOrderItemList});

  final List<PurchaseOrderItemListTileData> purchaseOrderItemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PurchaseOrderItemListTileData data = purchaseOrderItemList[index];
        return PurchaseOrderItemListTileWithEditButton(
            itemName: data.itemName,
            sku: data.sku,
            quantity: data.quantity,
            estimatedPrice: data.estimatedPrice,
            subtotal: data.subtotal);
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

class PlaceOrderChip extends StatefulWidget {
  const PlaceOrderChip({super.key, required this.placeOrderState});

  final PlaceOrderState placeOrderState;

  @override
  _PlaceOrderChipState createState() => _PlaceOrderChipState();
}

class _PlaceOrderChipState extends State<PlaceOrderChip> {
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

    switch (widget.placeOrderState) {
      case PlaceOrderState.orderNotPlaced:
        actionChip = ActionChip(
          side: BorderSide(color: lightColorScheme.primary),
          label: Text(
            'Place Order',
            style: TextStyle(color: lightColorScheme.primary),
          ),
          onPressed: () {},
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
          onPressed: () {},
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

class ConfirmOrderChip extends StatefulWidget {
  const ConfirmOrderChip({super.key, required this.confirmOrderState});

  final ConfirmOrderState confirmOrderState;

  @override
  _ConfirmOrderChipState createState() => _ConfirmOrderChipState();
}

class _ConfirmOrderChipState extends State<ConfirmOrderChip> {
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

    switch (widget.confirmOrderState) {
      case ConfirmOrderState.orderNotConfirmed:
        actionChip = ActionChip(
          side: BorderSide(color: lightColorScheme.primary),
          label: Text(
            'Confirm Order',
            style: TextStyle(color: lightColorScheme.primary),
          ),
          onPressed: () {},
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
            'Order Confirmed',
            style: TextStyle(color: lightColorScheme.onTertiaryContainer),
          ),
          backgroundColor: lightColorScheme.tertiaryContainer,
          onPressed: () {},
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
  const PurchaseOrderStatus(
      {super.key,
      required this.placeOrderState,
      required this.confirmOrderState,
      required this.deliveryState});

  final PlaceOrderState placeOrderState;
  final ConfirmOrderState confirmOrderState;
  final DeliveryState deliveryState;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        PlaceOrderChip(placeOrderState: placeOrderState),
        ConfirmOrderChip(confirmOrderState: confirmOrderState),
        ConfirmDeliveryChip(deliveryState: deliveryState)
      ],
    );
  }
}

class PurchaseOrderDetailsItemList extends StatelessWidget {
  const PurchaseOrderDetailsItemList(
      {super.key, required this.purchaseOrderItemList});

  final List<PurchaseOrderItemListTileData> purchaseOrderItemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PurchaseOrderItemListTileData data = purchaseOrderItemList[index];
        return PurchaseOrderItemListTile(
            itemName: data.itemName,
            sku: data.sku,
            quantity: data.quantity,
            estimatedPrice: data.estimatedPrice,
            subtotal: data.subtotal);
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

    // You can implement filtering logic here based on the selected filter.
    // For now, let's print the selected filter.
    print("Selected Filter: $selectedFilter");
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

class OutgoingInventoryCard extends StatelessWidget {
  const OutgoingInventoryCard(
      {super.key,
      required this.customerName,
      required this.totalCost,
      required this.salesOrderNumber,
      required this.salesOrderItemList});

  final String customerName;
  final String totalCost;
  final String salesOrderNumber;
  final List<SalesOrderItemListTileData> salesOrderItemList;

  @override
  Widget build(BuildContext context) {
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
                          label: 'Customer', data: customerName),
                      InformationWithLabel(
                          label: 'Total Cost', data: totalCost),
                      InformationWithLabel(
                          label: 'Sales Order Number', data: salesOrderNumber),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Icon(Icons.info_outline_rounded))
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

class SalesOrderItemList extends StatelessWidget {
  const SalesOrderItemList({super.key, required this.salesOrderItemList});

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

    // You can implement filtering logic here based on the selected filter.
    // For now, let's print the selected filter.
    print("Selected Filter: $selectedFilter");
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

class NewSalesOrderFilterChips extends StatefulWidget {
  const NewSalesOrderFilterChips({super.key, required this.filters});

  final List<String> filters;

  @override
  _NewSalesOrderFilterChipsState createState() =>
      _NewSalesOrderFilterChipsState();
}

class _NewSalesOrderFilterChipsState extends State<NewSalesOrderFilterChips> {
  late List<String> filters;
  String selectedFilter = "All"; // Default selected filter

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });

    // You can implement filtering logic here based on the selected filter.
    // For now, let's print the selected filter.
    print("Selected Filter: $selectedFilter");
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

class NewSalesOrderItemCard extends StatelessWidget {
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
        TextButton(onPressed: () {}, child: const Icon(Icons.delete_outline))
      ],
    );
  }
}

class SaleTypeDropDownMenu extends StatefulWidget {
  const SaleTypeDropDownMenu({super.key});

  @override
  _SaleTypeDropDownMenuState createState() => _SaleTypeDropDownMenuState();
}

class _SaleTypeDropDownMenuState extends State<SaleTypeDropDownMenu> {
  SaleType? selectedSaleType;

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
    final List<DropdownMenuEntry<SaleType>> saleTypeEntries =
        <DropdownMenuEntry<SaleType>>[];
    for (final SaleType saleType in SaleType.values) {
      saleTypeEntries.add(
        DropdownMenuEntry<SaleType>(value: saleType, label: saleType.label),
      );
    }

    return DropdownMenu<SaleType>(
      initialSelection: SaleType.retail,
      enableFilter: false,
      enableSearch: false,
      label: const Text('Sale Type'),
      dropdownMenuEntries: saleTypeEntries,
      onSelected: (SaleType? saleType) {
        setState(() {
          selectedSaleType = saleType;
        });
      },
    );
  }
}

class CustomerDropDownMenu extends StatefulWidget {
  const CustomerDropDownMenu({super.key, required this.customerList});

  final List<Customer> customerList;

  @override
  _CustomerDropDownMenuState createState() => _CustomerDropDownMenuState();
}

class _CustomerDropDownMenuState extends State<CustomerDropDownMenu> {
  Customer? selectedCustomer;
  late List<Customer> customerList;

  @override
  void initState() {
    super.initState();
    customerList = widget.customerList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      },
    );
  }
}

class PaymentTermsDropDownMenu extends StatefulWidget {
  const PaymentTermsDropDownMenu({super.key});

  @override
  _PaymentTermsDropDownMenuState createState() =>
      _PaymentTermsDropDownMenuState();
}

class _PaymentTermsDropDownMenuState extends State<PaymentTermsDropDownMenu> {
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
      enableFilter: false,
      enableSearch: false,
      label: const Text('Payment Term'),
      dropdownMenuEntries: paymentTermEntries,
      onSelected: (PaymentTerm? paymentTerm) {
        setState(() {
          selectedPaymentTerm = paymentTerm;
        });
      },
    );
  }
}

class SalespersonDropDownMenu extends StatefulWidget {
  const SalespersonDropDownMenu({super.key, required this.salespersonList});

  final List<Salesperson> salespersonList;

  @override
  _SalespersonDropDownMenuState createState() =>
      _SalespersonDropDownMenuState();
}

class _SalespersonDropDownMenuState extends State<SalespersonDropDownMenu> {
  Salesperson? selectedSalesperson;
  late List<Salesperson> salespersonList;

  @override
  void initState() {
    super.initState();
    salespersonList = widget.salespersonList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      },
    );
  }
}

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

    // You can implement filtering logic here based on the selected filter.
    // For now, let's print the selected filter.
    print("Selected Filter: $selectedFilter");
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

class ItemCard extends StatelessWidget {
  const ItemCard(
      {super.key,
      required this.itemName,
      required this.sku,
      required this.imageURL});

  final String itemName;
  final String sku;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                child: ItemCardImage(
              imageURL: imageURL,
            )),
            const Padding(padding: EdgeInsets.only(left: 8.0)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: customTextStyle.titleMedium
                        .copyWith(color: lightColorScheme.onSurface),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    sku,
                    style: customTextStyle.bodyMedium
                        .copyWith(color: lightColorScheme.onSurface),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
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
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
