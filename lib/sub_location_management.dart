import 'models.dart';
import 'providers.dart';
import 'widget_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_management.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add Location'),
        icon: const Icon(Icons.add_location_outlined),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubLocationManagementBody(stockLocation.documentPath!),
        ],
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
        data: (data) => LocationsGrid(stockLocationList: data),
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}
