import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/Patient.dart';

const List<String> genderOpsList = <String>['Male', 'Female', 'Other'];

class AddPatient extends StatefulWidget {
  final VoidCallback reloadList; // Add the reloadList parameter

  const AddPatient({Key? key, required this.reloadList}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Health Minder")),
      drawer: MainDrawer(reloadList: widget.reloadList,),
      body: Padding(padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text("First Name:"),
            TextField(
              controller: nameFirst,
            ),
            Text("Last Name:"),
            TextField(
              controller: nameLast,
            ),
            Text("Address:"),
            TextField(
              controller: address,
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Date of Birth:"),
                  Spacer(),
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
                  Text("Gender:"),
                  Spacer(),
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
            Text("Department:"),
            TextField(
              controller: department,
            ),
            Text("Doctor"),
            TextField(
              controller: doctor,
            ),
            Text("Additional Notes:"),
            TextField(
              controller: addNotes,
            ),
            ElevatedButton(onPressed: () => {
              print("Submit Tapped"),
              print(nameFirst.text),
              print(nameLast.text),

              if (nameFirst.text != "" && nameLast.text != "" && address.text != "" && gender != "" && department.text != "" && doctor.text != "" && addNotes.text != "") {
                createPatient(
                  nameFirst.text,
                  nameLast.text,
                  address.text,
                  "${selectedDate.toLocal()}".split(' ')[0],
                  gender,
                  department.text,
                  doctor.text,
                  addNotes.text
                ),
                Navigator.of(context).pushNamed('/')
              }
              
            }, child: Text("Submit")),
          ]
        )
      )
    );
  }
}

