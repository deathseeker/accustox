import 'controllers.dart';
import 'providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';
import 'widget_components.dart';

class CustomerAccountDetails extends StatelessWidget {
  const CustomerAccountDetails({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.customerName),
        /*actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined))
        ],*/
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: CustomerCard(customer: customer)),
                ],
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GroupTitle(title: 'Transaction History'),
              ),
              TransactionList(customer)
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Wrap(
          spacing: 16.0,
          runSpacing: 4.0,
          children: [
            customer.customerType == 'Business/Organization'
                ? InformationWithLabelLarge(
                    label: 'Contact Person', data: customer.contactPerson)
                : const SizedBox(
                    height: 0.0,
                    width: 0.0,
                  ),
            InformationWithLabelLarge(
                label: 'Contact Number', data: customer.contactNumber),
            InformationWithLabelLarge(label: 'Email', data: customer.email),
            InformationWithLabelLarge(label: 'Address', data: customer.address),
          ],
        ),
      ),
    );
  }
}

class TransactionList extends ConsumerWidget {
  const TransactionList(this.customer, {super.key});

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncCustomerAccount =
        ref.watch(streamCustomerAccountProvider(customer.customerID));

    return asyncCustomerAccount.when(
        data: (data) {
          CustomerAccount customerAccount = data;
          List<CustomerSalesTransaction> customerSalesTransaction =
              customerAccount.getCustomerSalesTransactionList();
          return customerSalesTransaction.isEmpty
              ? const ErrorMessage(
                  errorMessage:
                      'This account has no listed transactions yet...')
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    CustomerSalesTransaction transaction =
                        customerSalesTransaction[index];
                    var transactionMadeOn =
                        dateTimeController.formatDateTimeToYMdjm(
                            dateTime: transaction.transactionMadeOn);

                    return Card(
                      borderOnForeground: true,
                      child: InkWell(
                        onTap: () =>
                            navigationController.navigateToSalesOrderDetails(
                                salesOrderID: transaction.salesOrderID),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 4.0,
                            children: [
                              InformationWithLabel(
                                  label: 'Transaction Made On',
                                  data: transactionMadeOn),
                              InformationWithLabel(
                                  label: 'Sales Order Number',
                                  data: transaction.salesOrderNumber),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8.0,
                    );
                  },
                  itemCount: customerSalesTransaction.length);
        },
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}
