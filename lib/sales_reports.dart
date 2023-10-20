import 'color_scheme.dart';
import 'controllers.dart';
import 'providers.dart';
import 'text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widget_components.dart';

class SalesReports extends StatelessWidget {
  const SalesReports({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportGrid();
  }
}

class ReportGrid extends ConsumerWidget {
  const ReportGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncSalesReportMasterList = ref.watch(salesReportMasterListProvider);

    return asyncSalesReportMasterList.when(
        data: (data) {
          var masterList = data.salesReports;
          return masterList!.isEmpty
              ? const ErrorMessage(
                  errorMessage: 'There are no sales reports listed yet...')
              : GridView.builder(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 56.0),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150.0,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    String date = masterList[index];
                    DateTime dateTime = DateTime.parse(date);
                    String formattedDate = dateTimeController
                        .formatDateTimeToYMd(dateTime: dateTime);

                    return SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: Card(
                        child: InkWell(
                          onTap: () =>
                              navigationController.navigateToSalesReportDetails(
                                  dateInYYYYMMDD: date),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                color: lightColorScheme.onSurface,
                                size: 70.0,
                              ),
                              Text(
                                formattedDate,
                                style: customTextStyle.titleMedium.copyWith(
                                    color: lightColorScheme.onSurface),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: masterList.length,
                );
        },
        error: (e, st) => ErrorMessage(
            errorMessage: 'Something went wrong... ${e.toString()}'),
        loading: () => const LoadingWidget());
  }
}
