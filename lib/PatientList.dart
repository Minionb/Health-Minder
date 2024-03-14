import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:mapd722_project_group6/PatientDetailsWidget.dart';
import 'package:mapd722_project_group6/PatientWidget.dart';

enum Item { critical, bad, average, fine, good, all }

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

  Item? selectedItem;

  Map<String, String> patientQueryParams = {
    'first_name': '',
    'last_name': '',
    'condition': '',
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
                    widget.setQueryParams(patientQueryParams);
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