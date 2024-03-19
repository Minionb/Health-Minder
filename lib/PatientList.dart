import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/EditPatientScreen.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:mapd722_project_group6/PatientDetailsWidget.dart';
import 'package:mapd722_project_group6/PatientWidget.dart';
import 'package:provider/provider.dart';

enum Item { critical, bad, average, fine, good, all }

class PatientList extends StatefulWidget {
  
  // final Function(Map<String, String>) setQueryParams;

  const PatientList();

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  String firstName = '';
  String lastName = '';

  Item? selectedItem;

  Map<String, String> patientQueryParams = {
    'first_name': '',
    'last_name': '',
    'condition': '',
  };

    Future<void> showDeleteConfirmationDialog(String patientId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<PatientProvider>(context, listen: false)
                .deletePatient(patientId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Minder"),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
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
                      decoration: const InputDecoration(
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
                  },
                ),
                PopupMenuButton<Item>(
                  icon: const Icon(Icons.filter_alt, color: Colors.black,),
                  initialValue: selectedItem,
                  onSelected: (Item item) {
                    String itemString = "";
                    setState(() {
                      selectedItem = item;
                      itemString = selectedItem.toString().split('.')[1];
                      if (item != Item.all) {
                        patientQueryParams = {
                          'condition': itemString
                        };
                      } else {
                        patientQueryParams = {
                          'condition': ''
                        };
                      }
                    });
                    print('Filter clicked with condition: $itemString');
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Item>>[
                    const PopupMenuItem<Item>(
                      value: Item.critical,
                      child: Text('Critical', style: TextStyle(color: Color(0xFF9A1B22))),
                    ),
                    const PopupMenuItem<Item>(
                      value: Item.bad,
                      child: Text('Bad', style: TextStyle(color: Color(0xFFB94723)),)
                    ),
                    const PopupMenuItem<Item>(
                      value: Item.average,
                      child: Text('Average', style: TextStyle(color: Color(0xFFF9E802)),)
                    ),
                    const PopupMenuItem<Item>(
                      value: Item.fine,
                      child: Text('Fine', style: TextStyle(color: Color(0xFF4CC9F0)),)
                    ),
                    const PopupMenuItem<Item>(
                      value: Item.good,
                      child: Text('Good', style: TextStyle(color: Color(0xFF008000)),)
                    ),
                    const PopupMenuItem<Item>(
                      value: Item.all,
                      child: Text('All', style: TextStyle(color: Colors.black),)
                    ),
                  ]
                )
              ],
            ),
          ),
          Expanded(
            
            child: FutureBuilder(
          future: Provider.of<PatientProvider>(context, listen: false)
              .fetchPatients(patientQueryParams),//fetchPatients(patientQueryParams),
          builder: (cntx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<PatientProvider>(
                child: const Center(
                    child: Text('No Patients Yet'),
                  ),
                  builder: (context, PatientProvider, child) =>
                      PatientProvider.patients.isEmpty
                          ? child!
                          : ListView.builder(
              itemCount: PatientProvider.patients.length,
              itemBuilder: (context, index) {
                return PatientWidget(
                  patient: PatientProvider.patients[index],
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPatient(
                          patientID: PatientProvider.patients[index].id,
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    showDeleteConfirmationDialog(PatientProvider.patients[index].id);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailWidget(
                          patientId: PatientProvider.patients[index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        )
      ),
        ],
      ),
    );
  }
}