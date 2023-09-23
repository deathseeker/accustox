/*
import 'controllers.dart';
import 'providers.dart';
import 'widget_components.dart';
import 'color_scheme.dart';
import 'text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

class Employees extends StatelessWidget {
  const Employees({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: EmployeesBody()),
      ],
    );
  }
}

class EmployeesBody extends ConsumerWidget {
  const EmployeesBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncEmployeesListProvider = ref.watch(employeeListStreamProvider);

    return asyncEmployeesListProvider.when(
        data: (data) => EmployeesGrid(employeeList: data),
        error: (e, st) =>
        const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class EmployeesGrid extends StatelessWidget {
  const EmployeesGrid({super.key, required this.employeeList});

  final List<Employees> employeeList;

  @override
  Widget build(BuildContext context) {
    return employeeList.isEmpty
        ? const ErrorMessage(
        errorMessage: 'You currently have no registered employees...')
        : GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3.0),
      itemBuilder: (context, index) {
        Employees data = employeeList[index];

        return EmployeesCard(employee: data);
      },
      itemCount: employeeList.length,
    );
  }
}

class EmployeesCard extends StatelessWidget {
  final Employees employee;

  const EmployeesCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              employee.employeeName!,
              style: customTextStyle.titleMedium
                  .copyWith(color: lightColorScheme.onSurface),
            ),
            const Padding(padding: EdgeInsets.only(left: 8.0)),
            Flexible(
              child: Consumer(builder: (context, ref, child) {
                var userData = ref.watch(userProvider);

                return IconButton(
                    onPressed: userData == null
                        ? null
                        : () {
                      var user = userData;
                      var uid = user.uid;
                      dialogController.removeEmployeesDialog(
                          context: context, uid: uid, employee: employee);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: lightColorScheme.primary,
                    ));
              }),
            )
          ],
        ),
      ),
    );
  }
}

class EmployeesAddButton extends ConsumerWidget {
  const EmployeesAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FilledButton.icon(
      onPressed: user == null
          ? null
          : () =>
          dialogController.addNewEmployeesDialog(
              context: context, uid: user.uid),
      icon: const Icon(Icons.person_add_alt_outlined),
      label: const Text('New Employees'),
    );
  }
}

class EmployeesFAB extends ConsumerWidget {
  const EmployeesFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return FloatingActionButton.extended(
      onPressed: user == null
          ? null
          : () =>
          dialogController.addNewEmployeesDialog(
              context: context, uid: user.uid),
      label: const Text('Add Employee'),
      icon: const Icon(Icons.person_add_alt_outlined),
    );

  }
}
*/
