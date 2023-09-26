import 'package:accustox/controllers.dart';
import 'package:accustox/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'enumerated_values.dart';
import 'models.dart';
import 'widget_components.dart';

class CurrentInventory extends StatelessWidget {
  const CurrentInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: GroupTitle(title: 'Current Inventory'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: CurrentInventoryFilterChips(),
        ),
        Expanded(child: CurrentInventoryList())
      ],
    ));
  }
}

class CurrentInventoryList extends ConsumerWidget {
  const CurrentInventoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncCurrentInventoryList =
        ref.watch(asyncCurrentInventoryDataListProvider);

    return asyncCurrentInventoryList.when(
        data: (currentInventoryList) {
          return currentInventoryList.isEmpty
              ? const ErrorMessage(
                  errorMessage: 'You have no items under this category...')
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 3.0),
                  itemBuilder: (context, index) {
                    CurrentInventoryData data = currentInventoryList[index];

                    return CurrentInventoryItemCard(
                      currentInventoryData: data,
                    );
                  },
                  itemCount: currentInventoryList.length,
                );
        },
        error: (e, st) {
          debugPrint(e.toString());
          debugPrint(st.toString());
          return const ErrorMessage(errorMessage: 'Something went wrong...');
        },
        loading: () => const LoadingWidget());
  }
}
