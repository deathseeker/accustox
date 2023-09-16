import 'package:accustox/categories.dart';
import 'package:accustox/items.dart';
import 'package:accustox/profile.dart';
import 'package:accustox/salespersons.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  int _selectedIndex = 0;

  List<Widget> destinations = [
    const NavigationDrawerDestination(
        icon: Icon(Icons.storefront_outlined), label: Text('Profile')),
    const NavigationDrawerDestination(
        icon: Icon(Icons.group_outlined), label: Text('Salespersons')),
    const NavigationDrawerDestination(
        icon: Icon(Icons.category_outlined), label: Text('Items')),
    const NavigationDrawerDestination(
        icon: Icon(Icons.style_outlined), label: Text('Categories')),
    const NavigationDrawerDestination(
        icon: Icon(Icons.warehouse_outlined), label: Text('Stock Locations')),
    const NavigationDrawerDestination(
        icon: Icon(Icons.local_shipping_outlined), label: Text('Suppliers')),
    const NavigationDrawerDestination(
        icon: Icon(Icons.account_circle_outlined), label: Text('Customers')),
    const NavigationDrawerDestination(
        icon: Icon(Icons.logout_outlined), label: Text('Sign Out')),
  ];

  List<Widget> views = [const Profile(), const Salespersons(), const Items(), const Categories()];

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
    return Scaffold(
        body: SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationDrawer(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: destinations),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: views[_selectedIndex],
            ),
          )
        ],
      ),
    ));
  }
}
