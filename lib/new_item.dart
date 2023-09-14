import 'package:flutter/material.dart';
import 'widget_components.dart';

class NewItem extends StatelessWidget {
  const NewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
      ),
      body: const NewItemBody(),
    );
  }
}

class NewItemBody extends StatefulWidget {
  const NewItemBody({super.key});

  @override
  _NewItemBodyState createState() => _NewItemBodyState();
}

class _NewItemBodyState extends State<NewItemBody> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController productTypeController = TextEditingController();
  final TextEditingController manufacturerPartNumberController =
      TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController eanController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController openingStockController = TextEditingController();
  final TextEditingController stockLocationController = TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();
  final TextEditingController batchNumberController = TextEditingController();
  final TextEditingController costPriceController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();

  final FocusNode itemNameFocusNode = FocusNode();
  final FocusNode manufacturerFocusNode = FocusNode();
  final FocusNode unitFocusNode = FocusNode();
  final FocusNode sizeFocusNode = FocusNode();
  final FocusNode brandFocusNode = FocusNode();
  final FocusNode productTypeFocusNode = FocusNode();
  final FocusNode manufacturerPartNumberFocusNode = FocusNode();
  final FocusNode colorFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode skuFocusNode = FocusNode();
  final FocusNode eanFocusNode = FocusNode();
  final FocusNode lengthFocusNode = FocusNode();
  final FocusNode widthFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();
  final FocusNode openingStockFocusNode = FocusNode();
  final FocusNode stockLocationFocusNode = FocusNode();
  final FocusNode expirationDateFocusNode = FocusNode();
  final FocusNode batchNumberFocusNode = FocusNode();
  final FocusNode costPriceFocusNode = FocusNode();
  final FocusNode salePriceFocusNode = FocusNode();
  final FocusNode purchaseDateFocusNode = FocusNode();
  final FocusNode supplierFocusNode = FocusNode();

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: GroupTitle(title: 'Item Information'),
            ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: itemNameController,
                      focusNode: itemNameFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Item Name'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter item name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: manufacturerController,
                      focusNode: manufacturerFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Manufacturer'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter manufacturer';
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: manufacturerPartNumberController,
                      focusNode: manufacturerPartNumberFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'MPN (Manufacturer Part Number)'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter manufacturer part number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: productTypeController,
                      focusNode: productTypeFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Product Type'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product type';
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: unitController,
                      focusNode: unitFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Unit of Measurement'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter unit of measurement';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: sizeController,
                      focusNode: sizeFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Size'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter item size';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: brandController,
                      focusNode: brandFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Brand'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter brand';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: colorController,
                      focusNode: colorFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Color'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product color';
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: skuController,
                      focusNode: skuFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'SKU (Stock Keeping Unit)'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter SKU';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: eanController,
                      focusNode: eanFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'EAN (European Article Number)'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product color';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {}, child: const Icon(Icons.barcode_reader))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      focusNode: descriptionFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: GroupTitle(title: 'Item Dimensions'),
            ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: lengthController,
                      focusNode: lengthFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Length (in cm)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product length';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: widthController,
                      focusNode: widthFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Width (in cm)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product width';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: heightController,
                      focusNode: heightFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Height (in cm)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product height';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: GroupTitle(title: 'Opening Inventory Information'),
            ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: openingStockController,
                      focusNode: openingStockFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Opening Stock'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your starting stock level';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: stockLocationController,
                      focusNode: stockLocationFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Stock Location'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter where the stock is located';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: expirationDateController,
                      focusNode: expirationDateFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Expiration Date'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product expiration date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: batchNumberController,
                      focusNode: batchNumberFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Batch/Lot Number'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter batch lot number';
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: costPriceController,
                      focusNode: costPriceFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cost Price (in Php)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your cost per product unit';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: salePriceController,
                      focusNode: salePriceFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Sale Price (in Php)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your selling price per product unit';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: purchaseDateController,
                      focusNode: purchaseDateFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Purchase Date'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product purchase date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: supplierController,
                      focusNode: supplierFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Supplier'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product supplier';
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
                OutlinedButton(
                    onPressed: () {}, child: const Text('Cancel')),
                FilledButton(
                    onPressed: () {}, child: const Text('Create Item'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
