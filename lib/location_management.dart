import 'package:accustox/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers.dart';
import 'providers.dart';
import 'widget_components.dart';

class LocationManagement extends StatelessWidget {
  const LocationManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocationManagementBody(),
      ],
    );
  }
}

class LocationAddButton extends ConsumerWidget {
  const LocationAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);


    return FilledButton.icon(
      onPressed: user == null
          ? null
          : () => dialogController.addStockLocationDialog(
              context: context, uid: user.uid),
      icon: const Icon(Icons.add_location_outlined),
      label: const Text('New Location'),
    );
  }
}

class LocationManagementBody extends ConsumerWidget {
  const LocationManagementBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var stockLocationList = ref.watch(streamLocationListProvider);

    return stockLocationList.when(
        data: (data) => LocationsGrid(stockLocationList: data),
        error: (e, st) =>
        const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class LocationsGrid extends StatelessWidget {
  const LocationsGrid({super.key, required this.stockLocationList});

  final List<StockLocation> stockLocationList;

  @override
  Widget build(BuildContext context) {
    return stockLocationList.isEmpty
        ? const ErrorMessage(
        errorMessage: 'There are no locations listed yet...')
        : GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3.0),
      itemBuilder: (context, index) {
        StockLocation data = stockLocationList[index];

        return StockLocationCard(stockLocation: data);
      },
      itemCount: stockLocationList.length,
    );
  }
}

class LocationManagementFAB extends ConsumerWidget {
  const LocationManagementFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FloatingActionButton.extended(
      onPressed: user == null
          ? null
          : () =>
          dialogController.addStockLocationDialog(
              context: context, uid: user.uid),
      label: const Text('Add Location'),
      icon: const Icon(Icons.add_location_outlined),
    );

  }
}


