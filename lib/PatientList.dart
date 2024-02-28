import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';

class PatientList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Health Minder")),
      drawer: MainDrawer(),
      body: Text("No Data Shown")
      // GridView(
      //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //       maxCrossAxisExtent: 200,
      //       childAspectRatio: 3 / 2,
      //       crossAxisSpacing: 100,
      //       mainAxisExtent: 100,
      //       mainAxisSpacing: 20),
      //   children: const ["123","456"],
      // ),
    );
  }
}
