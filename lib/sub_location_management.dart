import 'controllers.dart';
import 'models.dart';
import 'providers.dart';
import 'widget_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubLocationManagement extends StatelessWidget {
  final StockLocation stockLocation;

  const SubLocationManagement({super.key, required this.stockLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stockLocation.locationAddress),
        actions: [DeleteLocationButton(stockLocation)],
      ),
      floatingActionButton: SubLocationFAB(stockLocation),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SubLocationManagementBody(stockLocation.documentPath!)),
          ],
        ),
      ),
    );
  }
}

class SubLocationManagementBody extends ConsumerWidget {
  const SubLocationManagementBody(this.path, {super.key});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var stockLocationList = ref.watch(streamSubLocationListProvider(path));

    return stockLocationList.when(
        data: (data) => SubLocationsGrid(stockLocationList: data),
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class SubLocationFAB extends ConsumerWidget {
  const SubLocationFAB(this.parentLocation, {super.key});

  final StockLocation parentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FloatingActionButton.extended(
      onPressed: user == null
          ? null
          : () => dialogController.addStockSubLocationDialog(
              context: context, uid: user.uid, parentLocation: parentLocation),
      icon: const Icon(Icons.add_location_outlined),
      label: const Text('New Sublocation'),
    );
  }
}


class SubLocationsGrid extends StatelessWidget {
  const SubLocationsGrid({super.key, required this.stockLocationList});

  final List<StockLocation> stockLocationList;

  @override
  Widget build(BuildContext context) {
    stockLocationList.sort((a, b) =>
        a.locationName.toLowerCase().compareTo(b.locationName.toLowerCase()));

    return stockLocationList.isEmpty
        ? const ErrorMessage(
        errorMessage: 'There are no locations listed yet...')
        : GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
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
