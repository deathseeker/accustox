import 'package:accustox/controllers.dart';
import 'package:accustox/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CustomerTypeDropDownMenu(),
              ),
              const Divider(),
              Consumer(builder: (context, ref, child) {
                var customerType = ref.watch(customerTypeProvider);
                return CustomerTypeBody(customerType: customerType);
              })
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
  final _formKey = GlobalKey<FormState>();

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    customerNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    customerNameFocusNode.dispose();
    contactNumberFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: customerNameController,
                    focusNode: customerNameFocusNode,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Customer'),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter customer name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: contactNumberController,
                    focusNode: contactNumberFocusNode,
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 11,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contact Number',
                        helperText:
                            'Please follow the following format: 09*********'),
                    validator: (String? value) {
                      RegExp numeric = RegExp(r'^[0-9]+$');
                      bool hasMatch = numeric.hasMatch(value!);
                      return hasMatch == false || value.isEmpty
                          ? 'Please enter valid contact number'
                          : null;
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
                        border: OutlineInputBorder(),
                        labelText: 'Email (Optional)'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: addressController,
              focusNode: addressFocusNode,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Address'),
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.done,
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
              Consumer(builder: (context, ref, child) {
                var user = ref.watch(userProvider);
                var customerType = ref.watch(customerTypeProvider);
                return FilledButton(
                    onPressed: user == null
                        ? null
                        : () =>
                            customerController.reviewAndSubmitCustomerProfile(
                                formKey: _formKey,
                                customerName: customerNameController.text,
                                contactPerson: '',
                                email: emailController.text,
                                contactNumber: contactNumberController.text,
                                address: addressController.text,
                                customerType: customerType.label,
                                uid: user.uid),
                    child: const Text('Create Account'));
              })
            ],
          )
        ],
      ),
    );
  }
}

class OrganizationBody extends StatefulWidget {
  const OrganizationBody({super.key});

  @override
  _OrganizationBody createState() => _OrganizationBody();
}

class _OrganizationBody extends State<OrganizationBody> {
  final _formKey = GlobalKey<FormState>();

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    customerNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    customerNameFocusNode.dispose();
    contactNumberFocusNode.dispose();
    emailFocusNode.dispose();
    addressFocusNode.dispose();
    contactPersonController.dispose();
    contactPersonFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: customerNameController,
                    focusNode: customerNameFocusNode,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Business/Organization Name'),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: contactPersonController,
                    focusNode: contactPersonFocusNode,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contact Person'),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
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
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: contactNumberController,
                    focusNode: contactNumberFocusNode,
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 11,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contact Number',
                        helperText:
                            'Please follow the following format: 09*********'),
                    validator: (String? value) {
                      RegExp numeric = RegExp(r'^[0-9]+$');
                      bool hasMatch = numeric.hasMatch(value!);
                      return hasMatch == false || value.isEmpty
                          ? 'Please enter valid contact number'
                          : null;
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
                        border: OutlineInputBorder(),
                        labelText: 'Email (Optional)'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: addressController,
              focusNode: addressFocusNode,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Address'),
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.done,
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
              Consumer(builder: (context, ref, child) {
                var user = ref.watch(userProvider);
                var customerType = ref.watch(customerTypeProvider);
                return FilledButton(
                    onPressed: user == null
                        ? null
                        : () =>
                            customerController.reviewAndSubmitCustomerProfile(
                                formKey: _formKey,
                                customerName: customerNameController.text,
                                contactPerson: contactPersonController.text,
                                email: emailController.text,
                                contactNumber: contactNumberController.text,
                                address: addressController.text,
                                customerType: customerType.label,
                                uid: user.uid),
                    child: const Text('Create Account'));
              })
            ],
          )
        ],
      ),
    );
  }
}
