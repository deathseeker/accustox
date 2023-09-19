import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'color_scheme.dart';
import 'controllers.dart';
import 'models.dart';
import 'providers.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: CategoriesBody()),
      ],
    );
  }
}

class CategoryAddButton extends ConsumerWidget {
  const CategoryAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FilledButton.icon(
      onPressed: user == null
          ? null
          : () => dialogController.addCategoryDialog(
              context: context, uid: user.uid),
      icon: const Icon(Icons.new_label_outlined),
      label: const Text('New Category'),
    );
  }
}

class CategoriesBody extends ConsumerWidget {
  const CategoriesBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categoryList = ref.watch(streamCategoryListProvider);

    return categoryList.when(
        data: (data) => CategoryGrid(categoryList: data),
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.categoryList});

  final List<Category> categoryList;

  @override
  Widget build(BuildContext context) {
    return categoryList.isEmpty
        ? const ErrorMessage(
            errorMessage: 'There are no categories listed yet...')
        : GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 3.0),
            itemBuilder: (context, index) {
              Category data = categoryList[index];

              return CategoryCard(category: data);
            },
            itemCount: categoryList.length,
          );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.categoryName!,
              style: customTextStyle.titleMedium
                  .copyWith(color: lightColorScheme.onSurface),
            ),
            const Padding(padding: EdgeInsets.only(left: 8.0)),
            Flexible(
              child: Consumer(builder: (context, ref, child) {
                var userData = ref.watch(userProvider);

                return IconButton(
                    onPressed: userData == null
                        ? null
                        : () {
                            var user = userData;
                            var uid = user.uid;
                            dialogController.removeCategoryDialog(
                                context: context, uid: uid, category: category);
                          },
                    icon: Icon(
                      Icons.delete_outline,
                      color: lightColorScheme.primary,
                    ));
              }),
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesFAB extends ConsumerWidget {
  const CategoriesFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FloatingActionButton.extended(
      onPressed: user == null
          ? null
          : () =>
          dialogController.addCategoryDialog(
              context: context, uid: user.uid),
      label: const Text('Add Category'),
      icon: const Icon(Icons.new_label_outlined),
    );

  }
}
