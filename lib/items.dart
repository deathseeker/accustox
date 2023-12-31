import 'controllers.dart';
import 'models.dart';
import 'providers.dart';
import 'widget_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    return const ItemsBody();
  }
}

class ItemGrid extends ConsumerWidget {
  const ItemGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var itemList = ref.watch(streamItemsListByCategoryFilterProvider);

    return itemList.when(
        data: (data) {
          var list = data;

          list.sort((a, b) =>
              a.itemName!.toLowerCase().compareTo(b.itemName!.toLowerCase()));

          return list.isEmpty
              ? const ErrorMessage(
                  errorMessage: 'There are no items listed yet...')
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 4),
                  itemBuilder: (context, index) {
                    Item data = list[index];
                    return ItemCard(
                      item: data,
                    );
                  },
                  itemCount: list.length,
                );
        },
        error: (e, st) => ErrorMessage(
            errorMessage: 'Something went wrong... ${e.toString()}'),
        loading: () => const LoadingWidget());
  }
}

class ItemsBody extends ConsumerStatefulWidget {
  const ItemsBody({super.key});

  @override
  _ItemsBodyState createState() => _ItemsBodyState();
}

class _ItemsBodyState extends ConsumerState<ItemsBody> {
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
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var categoryFilterList = ref.watch(asyncCategoryFilterListProvider);

    return categoryFilterList.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ItemCategoryFilterChips(data),
              ),
              const Expanded(child: ItemGrid())
            ],
          );
        },
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class ItemsFAB extends StatelessWidget {
  const ItemsFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => navigationController.navigateToNewItem(),
      label: const Text('Add Item'),
      icon: const Icon(Icons.add_circle_outline),
    );
  }
}
