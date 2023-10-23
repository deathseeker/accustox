// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers.dart';
import 'image_container.dart';
import 'models.dart';
import 'providers.dart';
import 'text_theme.dart';
import 'widget_components.dart';

class EditItem extends StatelessWidget {
  const EditItem({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: EditItemBody(item),
    );
  }
}

class EditItemBody extends ConsumerStatefulWidget {
  const EditItemBody(this.item, {super.key});

  final Item item;

  @override
  _EditItemBodyState createState() => _EditItemBodyState();
}

class _EditItemBodyState extends ConsumerState<EditItemBody> {
  ImageFile imageFile = ImageFile();
  ImageStorageUploadData imageStorageUploadData = ImageStorageUploadData();
  ItemChangeNotifier itemChangeNotifier = ItemChangeNotifier();

  final _formKey = GlobalKey<FormState>();

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
    super.initState();
    var item = widget.item;
    itemChangeNotifier = ItemChangeNotifier.fromItem(widget.item);
    itemNameController.text = item.itemName!;
    manufacturerController.text = item.manufacturer!;
    manufacturerPartNumberController.text = item.manufacturerPartNumber!;
    productTypeController.text = item.productType!;
    unitController.text = item.unitOfMeasurement!;
    sizeController.text = item.size!;
    brandController.text = item.brand!;
    colorController.text = item.color!;
    skuController.text = item.sku!;
    eanController.text = item.ean!;
    descriptionController.text = item.itemDescription!;
    lengthController.text = item.length!;
    widthController.text = item.width!;
    heightController.text = item.height!;
  }

  @override
  void dispose() {
    super.dispose();
    itemNameController.dispose();
    manufacturerController.dispose();
    manufacturerPartNumberController.dispose();
    productTypeController.dispose();
    unitController.dispose();
    sizeController.dispose();
    brandController.dispose();
    colorController.dispose();
    skuController.dispose();
    eanController.dispose();
    descriptionController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    itemNameFocusNode.dispose();
    manufacturerPartNumberFocusNode.dispose();
    manufacturerFocusNode.dispose();
    productTypeFocusNode.dispose();
    unitFocusNode.dispose();
    sizeFocusNode.dispose();
    brandFocusNode.dispose();
    colorFocusNode.dispose();
    skuFocusNode.dispose();
    eanFocusNode.dispose();
    descriptionFocusNode.dispose();
    lengthFocusNode.dispose();
    widthFocusNode.dispose();
    heightFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(asyncCategorySelectionDataProvider.notifier).resetState();
        ref.read(categorySelectionProvider.notifier).resetState();
        navigationController.navigateToPreviousPage();
        return false;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      EditImageContainer(
                        imageFile: imageFile,
                        imageURL: widget.item.imageURL,
                      ),
                      Text(
                        "(*Item image is required.)",
                        style: customTextStyle.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: GroupTitle(title: 'Item Information'),
                ),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: itemNameController,
                          focusNode: itemNameFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Item Name (Required)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter item name';
                            }
                            return null;
                          },
                          onChanged: (String? value) {
                            itemChangeNotifier.update(itemName: value);
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(manufacturer: value);
                          },
                          /*    validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter manufacturer';
                            }
                            return null;
                          },*/
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(
                                manufacturerPartNumber: value);
                          },
                          /* validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter manufacturer part number';
                            }
                            return null;
                          },*/
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(productType: value);
                          },
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product type';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: unitController,
                          focusNode: unitFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Unit of Measurement (Required)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter unit of measurement';
                            }
                            return null;
                          },
                          onChanged: (String? value) {
                            itemChangeNotifier.update(unitOfMeasurement: value);
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(size: value);
                          },
                          /* validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter item size';
                            }
                            return null;
                          },*/
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(brand: value);
                          },
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter brand';
                            }
                            return null;
                          },*/
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(color: value);
                          },
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product color';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: skuController,
                          focusNode: skuFocusNode,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  'SKU (Stock Keeping Unit)  (Required)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter SKU';
                            }
                            return null;
                          },
                          onChanged: (String? value) {
                            itemChangeNotifier.update(sku: value);
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
                              labelText:
                                  'Barcode/EAN (European Article Number)'),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(ean: value);
                          },
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product color';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          String barcodeData =
                              await scannerController.scanBarCode();

                          if (barcodeData == '-1') {
                            null;
                          } else {
                            setState(() {
                              eanController.text = barcodeData;
                            });

                            itemChangeNotifier.update(ean: barcodeData);
                          }
                        },
                        child: const Icon(Icons.barcode_reader))
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(itemDescription: value);
                          },
                          /*  validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product description';
                            }
                            return null;
                          },*/
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(length: value);
                          },
                          /* validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product length';
                            }
                            return null;
                          },*/
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
                          textInputAction: TextInputAction.next,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(width: value);
                          },
                          /*validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product width';
                            }
                            return null;
                          },*/
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
                          textInputAction: TextInputAction.done,
                          onChanged: (String? value) {
                            itemChangeNotifier.update(height: value);
                          },
                          /*  validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter product height';
                            }
                            return null;
                          },*/
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: GroupTitle(
                      title: 'Item Category (Please select all that apply)'),
                ),
                _CategoryTags(widget.item),
                const Divider(),
                ButtonBar(
                  children: [
                    FilledButton(
                        onPressed: user == null
                            ? null
                            : () {
                                itemController.reviewAndSubmitItemUpdate(
                                    formKey: _formKey,
                                    ref: ref,
                                    itemChangeNotifier: itemChangeNotifier,
                                    oldItem: widget.item,
                                    imageFile: imageFile,
                                    uid: user.uid,
                                    imageStorageUploadData:
                                        imageStorageUploadData);
                              },
                        child: const Text('Update Item'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTags extends ConsumerStatefulWidget {
  const _CategoryTags(this.item, {Key? key}) : super(key: key);
  final Item item;

  @override
  _CategoryTagsState createState() => _CategoryTagsState();
}

class _CategoryTagsState extends ConsumerState<_CategoryTags> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await ref
          .read(categorySelectionProvider.notifier)
          .updateCategories(widget.item.categoryTags!, widget.item.uid!);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncCategorySelectionList = ref.watch(
        getSelectionListForItemCategoryProvider(widget.item.categoryTags!));

    return asyncCategorySelectionList.when(data: (data) {
      var list = data;

      return list.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('There are no categories listed yet...'),
              ),
            )
          : Wrap(
              runSpacing: 8.0,
              spacing: 8.0,
              children: List.generate(list.length, (index) {
                CategorySelectionData data = list[index];
                return FilterChip(
                  label: Text(
                    data.categoryName!,
                  ),
                  selected: data.isSelected!,
                  onSelected: (bool value) {
                    setState(() {
                      data.isSelected = value;
                    });
                    value
                        ? ref
                            .read(categorySelectionProvider.notifier)
                            .addCategory(Category(
                              categoryName: null,
                              categoryID: data.categoryID,
                              uid: data.uid,
                            ))
                        : ref
                            .read(categorySelectionProvider.notifier)
                            .removeCategory(data.categoryID!);
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            );
    }, error: (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      return const Center(child: Text('Something went wrong...'));
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    });
  }
}
