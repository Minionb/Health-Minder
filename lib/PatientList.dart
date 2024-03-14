import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:mapd722_project_group6/PatientDetailsWidget.dart';
import 'package:mapd722_project_group6/PatientWidget.dart';

class PatientList extends StatefulWidget {
  final List<Patient> patients;
  final Function(Map<String, String>) setQueryParams;

  const PatientList(this.patients,this.setQueryParams);

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  String firstName = '';
  String lastName = '';

  Map<String, String> patientQueryParams = {
    'first_name': '',
    'last_name': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Minder"),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: EdgeInsets.symmetric(horizontal: 8),
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'First Name',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      firstName = firstNameController.text;
                      lastName = lastNameController.text;
                      patientQueryParams = {
                        'first_name': firstName,
                        'last_name': lastName,
                      };
                    });
                    print('Search clicked with firstName: $firstName, lastName: $lastName');
                    widget.setQueryParams(patientQueryParams);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.patients.length,
              itemBuilder: (context, index) {
                return PatientWidget(
                  patient: widget.patients[index],
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
                          patientId: widget.patients[index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}