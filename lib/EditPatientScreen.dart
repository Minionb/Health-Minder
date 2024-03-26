import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:provider/provider.dart';

const List<String> genderOpsList = <String>['Male', 'Female', 'Other'];

class EditPatient extends StatefulWidget {

final String patientID;

  EditPatient({required this.patientID});

  @override
  State<EditPatient> createState() => _EditPatient();
}

class _EditPatient extends State<EditPatient> {
  DateTime selectedDate = DateTime.now();
  final nameFirst = TextEditingController();
  final nameLast = TextEditingController();
  final address = TextEditingController();
  String gender = "";
  final department = TextEditingController();
  final doctor = TextEditingController();
  final addNotes = TextEditingController();
  

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
        appBar: AppBar(
        title: Text("Health Minder"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: MainDrawer(),
      body: Padding(padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            const Center(
              child: Text(
                "Edit Patient",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
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
           ElevatedButton(
            onPressed: () {
              List<String> updatedFields = [];
              List<String> updateBody = [];
              if (nameFirst.text != ""){
                String nameFirstText = nameFirst.text;
                updatedFields.add("First Name: $nameFirstText");
                updateBody.add('"first_name": "$nameFirstText"');
              }
              if (nameLast.text != ""){
                String nameLastText = nameLast.text;
                updatedFields.add("Last Name: $nameLastText");
                updateBody.add('"last_name": "$nameLastText"');
              }
              if ("${selectedDate.toLocal()}".split(' ')[0] != DateTime.now().toLocal().toString().split(' ')[0]) {
                String dateOfBirth = "${selectedDate.toLocal()}".split(' ')[0];
                updatedFields.add("Last Name: $dateOfBirth");
                updateBody.add('"date_of_birth": "$dateOfBirth"');
              }
              if (address.text != ""){
                String addressText = address.text;
                updatedFields.add("Address: $addressText");
                updateBody.add('"address": "$addressText"');
              }
              if (gender != ""){
                updatedFields.add("Gender: $gender");
                updateBody.add('"gender": "$gender"');
              }
              if (department.text != ""){
                String departmentText = department.text;
                updatedFields.add("Department: $departmentText");
                updateBody.add('"department": "$departmentText"');
              }
              if (doctor.text != ""){
                String doctorText = doctor.text;
                updatedFields.add("Doctor: $doctorText");
                updateBody.add('"doctor": "$doctorText"');
              }
              if (addNotes.text != ""){
                String addNotesText = addNotes.text;
                updatedFields.add("Additional Notes: $addNotesText");
                updateBody.add('"additional_notes": "$addNotesText"');
              }
              final updateBodyString = "{${updateBody.join(", ")}}";
              print(updateBodyString);

              // Call the editPatient function with the updateBodyString
              Provider.of<PatientProvider>(context, listen: false)
                .editPatient(widget.patientID, updateBodyString);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Patient edtited successfully.'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                        ),
                      ],
                   );
                  },
                );    
              }, child: Text("Submit")),
          ]
        )
      )
    );
  }
}

