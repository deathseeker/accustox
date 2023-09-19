import 'package:accustox/controllers.dart';
import 'package:accustox/providers.dart';
import 'package:accustox/widget_components.dart';

import 'color_scheme.dart';
import 'text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

class Salespersons extends StatelessWidget {
  const Salespersons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: SalespersonBody()),
      ],
    );
  }
}

class SalespersonBody extends ConsumerWidget {
  const SalespersonBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncSalespersonListProvider = ref.watch(salespersonListStreamProvider);

    return asyncSalespersonListProvider.when(
        data: (data) => SalespersonGrid(salespersonList: data),
        error: (e, st) =>
        const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class SalespersonGrid extends StatelessWidget {
  const SalespersonGrid({super.key, required this.salespersonList});

  final List<Salesperson> salespersonList;

  @override
  Widget build(BuildContext context) {
    return salespersonList.isEmpty
        ? const ErrorMessage(
        errorMessage: 'You currently have no registered salespersons...')
        : GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3.0),
      itemBuilder: (context, index) {
        Salesperson data = salespersonList[index];

        return SalespersonCard(salesperson: data);
      },
      itemCount: salespersonList.length,
    );
  }
}

class SalespersonCard extends StatelessWidget {
  final Salesperson salesperson;

  const SalespersonCard({super.key, required this.salesperson});

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
              salesperson.salespersonName!,
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
                      dialogController.removeSalespersonDialog(
                          context: context, uid: uid, salesperson: salesperson);
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

class SalespersonAddButton extends ConsumerWidget {
  const SalespersonAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FilledButton.icon(
      onPressed: user == null
          ? null
          : () =>
          dialogController.addNewSalespersonDialog(
              context: context, uid: user.uid),
      icon: const Icon(Icons.person_add_alt_outlined),
      label: const Text('New Salesperson'),
    );
  }
}

class SalespersonFAB extends ConsumerWidget {
  const SalespersonFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FloatingActionButton.extended(
      onPressed: user == null
          ? null
          : () =>
          dialogController.addNewSalespersonDialog(
              context: context, uid: user.uid),
      label: const Text('Add Salesperson'),
      icon: const Icon(Icons.person_add_alt_outlined),
    );

  }
}
