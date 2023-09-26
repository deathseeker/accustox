import 'controllers.dart';
import 'providers.dart';
import 'widget_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

class MoveInventory extends StatelessWidget {
  const MoveInventory({super.key, required this.stock});

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Move Inventory'),
      ),
      body: MoveInventoryBody(stock),
    );
  }
}

class MoveInventoryBody extends ConsumerStatefulWidget {
  const MoveInventoryBody(this.stock, {super.key});

  final Stock stock;

  @override
  _MoveInventoryBodyState createState() => _MoveInventoryBodyState();
}

class _MoveInventoryBodyState extends ConsumerState<MoveInventoryBody> {
  late final Stock stock;
  late final double stockLevel;
  late final StockLocation currentStockLocation;
  late double adjustedStockLevel;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController stockLevelAdjustmentController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    stock = widget.stock;
    stockLevel = stock.stockLevel!;
    adjustedStockLevel = stockLevel;
    currentStockLocation = StockLocation.fromMap(stock.stockLocation!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var asyncLocationList = ref.watch(streamLocationDataListProvider);
    var newStockLocation = ref.watch(locationSelectionProvider);

    return asyncLocationList.when(
        data: (data) {
          data.removeWhere((stockLocation) =>
              stockLocation.locationID == currentStockLocation.locationID);
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MoveInventoryInformationCard(
                          currentLocation:
                              stock.stockLocation?['locationAddress'],
                          currentStockLevel: stockLevel.toString(),
                          retainedStockLevel: adjustedStockLevel.toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MoveInventoryLocationDropDownMenu(data),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: stockLevelAdjustmentController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                'Stock Quantity For Movement (Required)'),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          var adjustmentValue = inventoryController
                              .getAdjustedStockLevelForMovement(
                                  currentStockLevel: stockLevel,
                                  adjustment: double.parse(value));
                          setState(() {
                            adjustedStockLevel = adjustmentValue;
                          });
                        },
                        validator: (value) {
                          var isValid = validatorController
                              .isPositiveDoubleBelowOrEqualToCount(
                                  input: value!, maxCount: stockLevel);

                          if (isValid) {
                            return null;
                          } else {
                            return 'Please enter a number between zero up to current stockLevel...';
                          }
                        },
                      ),
                    ),
                    ButtonBar(
                      children: [
                        FilledButton(
                            onPressed: user == null
                                ? null
                                : () =>
                                    inventoryController.reviewAndMoveInventory(
                                        formKey: _formKey,
                                        uid: user.uid,
                                        newStockLocation: newStockLocation,
                                        movedStockLevel:
                                            stockLevelAdjustmentController.text,
                                        currentStock: stock),
                            child: const Text('Move'))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}
