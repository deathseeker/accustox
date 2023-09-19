import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers.dart';
import 'models.dart';
import 'providers.dart';
import 'widget_components.dart';

class CustomerAccounts extends StatelessWidget {
  const CustomerAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: CustomerAccountsBody()),
      ],
    );
  }
}

class CustomerAccountsBody extends ConsumerWidget {
  const CustomerAccountsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var customerList = ref.watch(streamCustomerListProvider);

    return customerList.when(
        data: (data) => CustomerAccountsList(customerList: data),
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class CustomerAccountsList extends StatelessWidget {
  const CustomerAccountsList({super.key, required this.customerList});

  final List<Customer> customerList;

  @override
  Widget build(BuildContext context) {
    return customerList.isEmpty
        ? const ErrorMessage(
            errorMessage: 'There are no customer accounts listed yet...')
        : ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Customer data = customerList[index];

              return CustomerCard(customer: data);
            },
            itemCount: customerList.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16.0,
              );
            },
          );
  }
}

class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 4.0,
          children: [
            InformationWithLabel(
                label: 'Customer Name', data: customer.customerName),
            customer.customerType == 'Business/Organization'
                ? InformationWithLabel(
                    label: 'Contact Person', data: customer.contactPerson)
                : const SizedBox(
                    height: 0.0,
                    width: 0.0,
                  ),
            InformationWithLabel(
                label: 'Contact Number', data: customer.contactNumber),
            InformationWithLabel(label: 'Email', data: customer.email),
            InformationWithLabel(label: 'Address', data: customer.address),
          ],
        ),
      ),
    );
  }
}

class CustomerAccountsFAB extends ConsumerWidget {
  const CustomerAccountsFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FloatingActionButton.extended(
      onPressed: user == null
          ? null
          : () => navigationController.navigateToNewCustomerAccount(),
      label: const Text('Add Customer'),
      icon: const Icon(Icons.add_circle_outline),
    );
  }
}
