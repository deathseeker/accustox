import 'package:accustox/controllers.dart';

import 'new_sales_order.dart';
import 'current_inventory.dart';
import 'incoming_inventory.dart';
import 'navigation_drawer.dart';
import 'outgoing_inventory.dart';
import 'package:flutter/material.dart';
import 'color_scheme.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = true;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  List<NavigationRailDestination> destinations = [
    /*const NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined), label: Text('Dashboard')),*/
    const NavigationRailDestination(
        icon: Icon(Icons.inventory_outlined), label: Text('Current')),
    const NavigationRailDestination(
        icon: Icon(Icons.archive_outlined), label: Text('Incoming')),
    const NavigationRailDestination(
        icon: Icon(Icons.unarchive_outlined), label: Text('Outgoing')),
  ];

  List<Widget> views = [
    /*const Dashboard(),*/
    const CurrentInventory(),
    const IncomingInventory(),
    const OutgoingInventory(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => navigationController.handleSystemBackButton(),
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
            child: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              groupAlignment: groupAlignment,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    MenuButton(),
                    Padding(padding: EdgeInsets.only(top: 8.0)),
                    FloatingActionButtonPOS()
                  ],
                ),
              ),
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: destinations,
              labelType: labelType,
            ),
            const Padding(padding: EdgeInsets.only(left: 36.0)),
            views[_selectedIndex],
            const Padding(padding: EdgeInsets.only(left: 36.0)),
          ],
        )),
      ),
    );
  }
}

class FloatingActionButtonPOS extends StatelessWidget {
  const FloatingActionButtonPOS({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NewSalesOrder())),
      backgroundColor: lightColorScheme.tertiaryContainer,
      child: Icon(
        Icons.point_of_sale_outlined,
        color: lightColorScheme.onTertiaryContainer,
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: 48.0,
      child: Center(
        child: TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const NavDrawer())) /*() => scaffoldKey.currentState!.openDrawer()*/,
            child: Icon(
              Icons.menu,
              color: lightColorScheme.onSurface,
            )),
      ),
    );
  }
}
