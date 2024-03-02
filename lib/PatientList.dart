import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/Patient.dart';
import 'package:mapd722_project_group6/PatientDetailsWidget.dart';
import 'package:mapd722_project_group6/PatientWidget.dart';

class PatientList extends StatelessWidget {

  final List<Patient> patients;

  final VoidCallback reloadList; // Add the reloadList parameter

  const PatientList(this.patients, {Key? key, required this.reloadList}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Health Minder")),
      drawer: MainDrawer(reloadList: reloadList,),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          return PatientWidget(
            patient: patients[index],
            onEdit: () {
              // TODO: Implement edit functionality
              print('Edit clicked');
            },
            onDelete: () {
              // TODO: Implement delete functionality
              print('Delete clicked');
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailWidget(
                    patientId: patients[index].id,
                  ),
                ),
              );
            },
          );
        },
      )
    );
  }
}
