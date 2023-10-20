import 'package:flutter/material.dart';

class PointOfSaleSettings extends StatelessWidget {
  const PointOfSaleSettings({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text('Settings'),
    ),);
  }
}

/*
class SettingsBody extends ConsumerWidget {
  const SettingsBody({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const POSSettingsItemGrid();
  }
}

class POSSettingsItemGrid extends ConsumerWidget {
  const POSSettingsItemGrid({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.7657,
      ),
      itemBuilder: (context, index) {

        return RetailInventoryItemCard(retailItem: retailItem);
      },
      itemCount: 1,
    );
  }
}*/
