import 'package:accustox/controllers.dart';
import 'package:accustox/supplier_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'color_scheme.dart';
import 'models.dart';
import 'providers.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class Suppliers extends StatelessWidget {
  const Suppliers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 16.0)),
        Expanded(child: SuppliersBody())
      ],
    );
  }
}

class SuppliersBody extends ConsumerWidget {
  const SuppliersBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var supplierList = ref.watch(streamSupplierListProvider);

    return supplierList.when(
        data: (data) => SupplierGrid(supplierList: data),
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class SupplierGrid extends StatelessWidget {
  const SupplierGrid({super.key, required this.supplierList});

  final List<Supplier> supplierList;

  @override
  Widget build(BuildContext context) {
    return supplierList.isEmpty
        ? const ErrorMessage(
            errorMessage: 'There are no suppliers listed yet...')
        : ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Supplier data = supplierList[index];

              return SupplierCard(supplier: data);
            },
            itemCount: supplierList.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16.0,
              );
            },
          );
  }
}

class SupplierCard extends StatelessWidget {
  final Supplier supplier;

  const SupplierCard({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: 16.0,
                runSpacing: 4.0,
                children: [
                  InformationWithLabel(
                      label: 'Supplier Name', data: supplier.supplierName),
                  InformationWithLabel(
                      label: 'Contact Number', data: supplier.contactNumber),
                  InformationWithLabel(
                      label: 'Contact Person', data: supplier.contactPerson),
                  InformationWithLabel(label: 'Email', data: supplier.email),
                  InformationWithLabel(
                      label: 'Address', data: supplier.address),
                ],
              ),
            ),
            SupplierMoreMenuButton(supplier: supplier)
          ],
        ),
      ),
    );
  }
}

class SuppliersFAB extends ConsumerWidget {
  const SuppliersFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FloatingActionButton.extended(
      onPressed: user == null
          ? null
          : () => navigationController.navigateToNewSupplier(),
      label: const Text('Add Supplier'),
      icon: const Icon(Icons.add_circle_outline),
    );
  }
}
