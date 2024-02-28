import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 120,
            width: double.infinity,
            child: Text(
              "",
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View All Patients'),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Patients'),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed('/filters-screen');
            },
          ),
          ListTile(
            leading: const Icon(Icons.filter),
            title: const Text('Filter Patients by Conditions'),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed('/favorit-screen');
            },
          ),
        ], 
      ),
    );
  }
}
