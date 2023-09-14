import 'package:accustox/controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create User Profile'),
          automaticallyImplyLeading: false,
        ),
        body: _CreateProfileBody(),
      ),
    );
  }
}

class _CreateProfileBody extends ConsumerStatefulWidget {
  @override
  _CreateProfileBodyState createState() => _CreateProfileBodyState();
}

class _CreateProfileBodyState extends ConsumerState<_CreateProfileBody> {
  late User user;
  late String uid;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final FocusNode businessNameFocusNode = FocusNode();
  final FocusNode ownerNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode contactNumberFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    businessNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    addressController.dispose();
    businessNameFocusNode.dispose();
    ownerNameFocusNode.dispose();
    emailFocusNode.dispose();
    contactNumberFocusNode.dispose();
    addressFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userData = ref.watch(userProvider);

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
                          controller: businessNameController,
                          focusNode: businessNameFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Business Name'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your business name';
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
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: ownerNameController,
                          focusNode: ownerNameFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Owner's name"),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the business owner's name";
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
                          controller: emailController,
                          focusNode: emailFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
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
                      flex: 2,
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
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: addressController,
                          focusNode: addressFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Address'),
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                ButtonBar(
                  children: [
                    FilledButton(
                        onPressed: userData == null
                            ? null
                            : () {
                                user = userData;
                                uid = user.uid;
                                userController.reviewAndSubmitProfile(
                                    formKey: _formKey,
                                    businessName: businessNameController.text,
                                    ownerName: ownerNameController.text,
                                    email: emailController.text,
                                    contactNumber: contactNumberController.text,
                                    address: addressController.text,
                                    uid: uid);
                              },
                        child: const Text('Create Profile'))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
