import 'models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers.dart';
import 'providers.dart';

class EditSupplier extends StatelessWidget {
  const EditSupplier({super.key, required this.supplier});

  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Supplier'),
      ),
      body: EditSupplierBody(
        supplier: supplier,
      ),
    );
  }
}

class EditSupplierBody extends StatefulWidget {
  const EditSupplierBody({super.key, required this.supplier});

  final Supplier supplier;

  @override
  _EditSupplierBodyState createState() => _EditSupplierBodyState();
}

class _EditSupplierBodyState extends State<EditSupplierBody> {
  final _formKey = GlobalKey<FormState>();
  late SupplierChangeNotifier supplierChangeNotifier;

  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final FocusNode supplierNameNode = FocusNode();
  final FocusNode contactNumberNode = FocusNode();
  final FocusNode contactPersonNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode addressNode = FocusNode();

  @override
  void initState() {
    super.initState();
    supplierNameController.text = widget.supplier.supplierName;
    contactNumberController.text = widget.supplier.contactNumber;
    contactPersonController.text = widget.supplier.contactPerson;
    emailController.text = widget.supplier.email;
    addressController.text = widget.supplier.address;
    supplierChangeNotifier =
        SupplierChangeNotifier.fromSupplier(widget.supplier);
  }

  @override
  void dispose() {
    super.dispose();
    supplierNameController.dispose();
    contactNumberController.dispose();
    contactPersonController.dispose();
    emailController.dispose();
    addressController.dispose();
    supplierNameNode.dispose();
    contactNumberNode.dispose();
    contactPersonNode.dispose();
    emailNode.dispose();
    addressNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: supplierNameController,
                          focusNode: supplierNameNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Supplier Name'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter supplier name';
                            }
                            return null;
                          },
                          onChanged: (String? value) {
                            supplierChangeNotifier.update(supplierName: value);
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: contactPersonController,
                          focusNode: contactPersonNode,
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
                          onChanged: (String? value) {
                            supplierChangeNotifier.update(contactPerson: value);
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: contactNumberController,
                          focusNode: contactNumberNode,
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
                          onChanged: (String? value) {
                            supplierChangeNotifier.update(contactNumber: value);
                          },
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: emailController,
                          focusNode: emailNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email (Optional)'),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            supplierChangeNotifier.update(email: value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: addressController,
                          focusNode: addressNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Address'),
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          onChanged: (String? value) {
                            supplierChangeNotifier.update(address: value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                ButtonBar(
                  children: [
                    Consumer(builder: (context, ref, child) {
                      var user = ref.watch(userProvider);

                      return FilledButton(
                          onPressed: user == null
                              ? null
                              : () {
                                  supplierController
                                      .reviewAndSubmitSupplierUpdate(
                                          formKey: _formKey,
                                          uid: user.uid,
                                          originalSupplier: widget.supplier,
                                          notifier: supplierChangeNotifier);
                                },
                          child: const Text('Update'));
                    })
                  ],
                )
              ],
            )),
      ),
    );
  }
}
