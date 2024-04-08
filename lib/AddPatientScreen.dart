import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/Patient.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:provider/provider.dart';

const List<String> genderOpsList = <String>['Male', 'Female', 'Other'];

class AddPatient extends StatefulWidget {


  @override
  State<AddPatient> createState() => _AddPatient();
}

class _AddPatient extends State<AddPatient> {
  DateTime selectedDate = DateTime.now();
  final nameFirst = TextEditingController();
  final nameLast = TextEditingController();
  final address = TextEditingController();
  String gender = "";
  final department = TextEditingController();
  final doctor = TextEditingController();
  final addNotes = TextEditingController();
  bool inputVal = true;

  late Patient newPatient;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void handleBool(bool input) {
    setState(() {
      inputVal = input;
    });
  }

    Future showAlert(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (cnx) => AlertDialog(
                title: const Text('Duplicated Patient!!!'),
                content: const Text("This patient is already in your Patient List!!"),
                actions: [
                  ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                       Navigator.of(context).pushReplacementNamed('/AddPatient');
                      })
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Minder")),
      drawer: MainDrawer(),
      body: Padding(padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Center(
              child: Text(
                "Add Patient",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("First Name:"),
            TextField(
              controller: nameFirst,
            ),
            const Text("Last Name:"),
            TextField(
              controller: nameLast,
            ),
            const Text("Address:"),
            TextField(
              controller: address,
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text("Date of Birth:"),
                  const Spacer(),
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  const SizedBox(height: 20.0,),
                  IconButton(
                    onPressed: () => _selectDate(context), 
                    icon: const Icon(Icons.calendar_month_outlined)
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text("Gender:"),
                  const Spacer(),
                  DropdownMenu<String>(
                    initialSelection: "Not Selected",
                    onSelected: (String? value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                    dropdownMenuEntries: genderOpsList.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                  )
                ],
              ),
            ),
            const Text("Department:"),
            TextField(
              controller: department,
            ),
            const Text("Doctor"),
            TextField(
              controller: doctor,
            ),
            const Text("Additional Notes:"),
            TextField(
              controller: addNotes,
            ),
            Text("One or more of the fields is empty!", style: TextStyle(color: inputVal ? Colors.white : Colors.red),),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (nameFirst.text != "" &&
                    nameLast.text != "" &&
                    address.text != "" &&
                    gender != "" &&
                    department.text != "" &&
                    doctor.text != "" &&
                    addNotes.text != "") {
                  handleBool(true);
                  
                  var added = await Provider.of<PatientProvider>(context, listen: false)
                      .createPatient(
                        nameFirst.text,
                        nameLast.text,
                        address.text,
                        "${selectedDate.toLocal()}".split(' ')[0],
                        gender,
                        department.text,
                        doctor.text,
                        addNotes.text,
                      );

                      print(added);

                  if (added == false) {
                      showAlert(context);
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Patient created successfully.'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  handleBool(false);
                }
              },
              child: const Text("Submit"),
            ),
          ]
        )
      )
    );
  }
}

