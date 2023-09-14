import 'package:flutter/material.dart';
import 'models.dart';

import 'widget_components.dart';

class ItemSupplierManagement extends StatelessWidget {
  const ItemSupplierManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupTitleWithTextButton(
              title: 'Suppliers',
              onPressed: () {},
              buttonLabel: 'Add Item Supplier'),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          const SupplierList()
        ],
      ),
    );
  }
}

class SupplierList extends StatelessWidget {
  const SupplierList({super.key});

  @override
  Widget build(BuildContext context) {
    List<ItemSupplierData> itemSupplierList = [
      ItemSupplierData(
          'Supplier Name',
          '09123456789',
          'Name',
          'sample@sample.com',
          'Building, Street, Village, Town/City, Province',
          '9999 Units'),
      ItemSupplierData(
          'Supplier Name',
          '09123456789',
          'Name',
          'sample@sample.com',
          'Building, Street, Village, Town/City, Province',
          '9999 Units'),
      ItemSupplierData(
          'Supplier Name',
          '09123456789',
          'Name',
          'sample@sample.com',
          'Building, Street, Village, Town/City, Province',
          '9999 Units'),
      ItemSupplierData(
          'Supplier Name',
          '09123456789',
          'Name',
          'sample@sample.com',
          'Building, Street, Village, Town/City, Province',
          '9999 Units'),
      ItemSupplierData(
          'Supplier Name',
          '09123456789',
          'Name',
          'sample@sample.com',
          'Building, Street, Village, Town/City, Province',
          '9999 Units'),
    ];
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        ItemSupplierData data = itemSupplierList[index];
        return ItemSupplierCard(
            supplierName: data.supplierName,
            contactNumber: data.contactNumber,
            contactPerson: data.contactPerson,
            email: data.email,
            address: data.address,
            minimumOrderQuantity: data.minimumOrderQuantity,
            onPressed: () {});
      },
      itemCount: itemSupplierList.length,
    );
  }
}
