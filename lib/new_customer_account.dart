import 'package:flutter/material.dart';
import 'enumerated_values.dart';
import 'widget_components.dart';

class NewCustomerAccount extends StatelessWidget {
  const NewCustomerAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Customer Account'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomerTypeDropDownMenu(),
              ),
              Divider(),
              CustomerTypeBody(customerType: CustomerType.individual)
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerTypeBody extends StatelessWidget {
  const CustomerTypeBody({super.key, required this.customerType});

  final CustomerType customerType;

  @override
  Widget build(BuildContext context) {
    Widget? customerTypeBody;

    switch (customerType) {
      case CustomerType.individual:
        customerTypeBody = const IndividualBody();
        break;
      case CustomerType.organization:
        customerTypeBody = const OrganizationBody();
        break;
    }

    return customerTypeBody;
  }
}

class IndividualBody extends StatefulWidget {
  const IndividualBody({super.key});

  @override
  _IndividualBodyState createState() => _IndividualBodyState();
}

class _IndividualBodyState extends State<IndividualBody> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode contactNumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: customerNameController,
                  focusNode: customerNameFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Customer'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 16.0)),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: contactNumberController,
                  focusNode: contactNumberFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter contact number';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 16.0)),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: addressController,
            focusNode: addressFocusNode,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Address'),
            keyboardType: TextInputType.streetAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter address';
              }
              return null;
            },
          ),
        ),
        ButtonBar(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
            FilledButton(onPressed: () {}, child: const Text('Create Account'))
          ],
        )
      ],
    );
  }
}

class OrganizationBody extends StatefulWidget {
  const OrganizationBody({super.key});

  @override
  _OrganizationBody createState() => _OrganizationBody();
}

class _OrganizationBody extends State<OrganizationBody> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();

  final FocusNode customerNameFocusNode = FocusNode();
  final FocusNode contactNumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode contactPersonFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: customerNameController,
                  focusNode: customerNameFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Business/Organization Name'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter business or organization name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 16.0)),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: contactPersonController,
                  focusNode: contactPersonFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact Person'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter contact person';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: contactNumberController,
                  focusNode: contactNumberFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter contact number';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 16.0)),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: addressController,
            focusNode: addressFocusNode,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Address'),
            keyboardType: TextInputType.streetAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter address';
              }
              return null;
            },
          ),
        ),
        ButtonBar(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
            FilledButton(onPressed: () {}, child: const Text('Create Account'))
          ],
        )
      ],
    );
  }
}
