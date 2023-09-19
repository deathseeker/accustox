import 'models.dart';
import 'widget_components.dart';
import 'package:flutter/material.dart';

class SupplierProfile extends StatelessWidget {
  const SupplierProfile({super.key, required this.supplier});

  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supplier.supplierName),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16.0, 32, 0),
        child: Wrap(
          runSpacing: 8.0,
          spacing: 16.0,
          children: [
            InformationWithLabelLarge(
                label: 'Contact Person', data: supplier.contactPerson),
            InformationWithLabelLarge(
                label: 'Contact Number', data: supplier.contactNumber),
            InformationWithLabelLarge(label: 'Email', data: supplier.email),
            InformationWithLabelLarge(label: 'Address', data: supplier.address),
          ],
        ),
      ),
    );
  }
}
