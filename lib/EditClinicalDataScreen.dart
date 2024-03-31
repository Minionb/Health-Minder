import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/ClinicalDataProvider.dart';
import 'package:mapd722_project_group6/ClinicalData.dart';
import 'package:provider/provider.dart';
import 'package:mapd722_project_group6/PatientDetailsWidget.dart';

const List<String> readingType = <String>['Blood Pressure', 'Respiratory Rate', 'Blood Oxygen Level', 'Heartbeat Rate'];

class EditClinicalData extends StatefulWidget {
  final String dataID;
  final String patientID;
  const EditClinicalData({super.key, required this.dataID, required this.patientID});

  @override
  State<EditClinicalData> createState() => _EditClinicalDataState();
}

class _EditClinicalDataState extends State<EditClinicalData> {
  String selectedReadingType = "";
  final _readingValueCrtl = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool inputVal = true;

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

  void handleDropdownValueChanged(String newValue) {
    setState(() {
      selectedReadingType = newValue;
    });
  }

  void handleBool(bool input) {
    setState(() {
      inputVal = input;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Record"),),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Spacer(),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Test:"),
                  Spacer(),
                  DropDownMenu(onValueChanged: handleDropdownValueChanged),
                ],
              ),
            ),
            Spacer(),
            const Text("Reading:"),
            TextField(controller: _readingValueCrtl,),
            Spacer(),
            Center(
              child: Row(
                children: [
                  const Text("Date Recorded:"),
                  Spacer(),
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  IconButton(
                    onPressed: () => _selectDate(context), 
                    icon: const Icon(Icons.calendar_month_outlined)
                  )
                ],
              ),
            ),
            Text("None of the fields contain new values!", style: TextStyle(color: inputVal ? Colors.white : Colors.red),),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (selectedReadingType == "" && _readingValueCrtl.text == "" && selectedDate == DateTime.now()) {
                  handleBool(false);
                }
                else {
                  handleBool(true);
                  List<String> updatedFields = [];
                  List<String> updatedBody = [];
                  if (selectedReadingType != "" && _readingValueCrtl.text != "") {
                    if (selectedReadingType == "Blood Pressure") {
                      if (!_readingValueCrtl.text.contains(" mmHg")) {
                        _readingValueCrtl.text += " mmHg";
                      }
                    }
                    else if (selectedReadingType == "Respiratory Rate") {
                      if (!_readingValueCrtl.text.contains("/min")) {
                        _readingValueCrtl.text += "/min";
                      }
                      
                    }
                    else if (selectedReadingType == "Blood Oxygen Level") {
                      if (!_readingValueCrtl.text.contains(" %")) {
                        _readingValueCrtl.text += " %";
                      }
                      
                    }
                    else {
                      if (!_readingValueCrtl.text.contains(" /min")) {
                        _readingValueCrtl.text += " /min";
                      }
                      
                    }
                    updatedFields.add("Reading Type: $selectedReadingType");
                    updatedBody.add('"data_type": "$selectedReadingType"');
                    updatedFields.add("Reading Value: ${_readingValueCrtl.text}");
                    updatedBody.add('"reading_value": "${_readingValueCrtl.text}"');
                    
                  }
                  if (selectedDate != DateTime.now()) {
                    updatedFields.add("Reading Date: $selectedDate");
                    updatedBody.add('"data_time": "$selectedDate"');
                  }
                  final updateBodyString = "{${updatedBody.join(", ")}}";
                  print(updateBodyString);
                  
                  showDialog(
                    context: context,
                    builder: (BuildContext context1) {
                      return AlertDialog(
                        title: const Text("Save Clinical Data?"),
                        content: Text("Are you sure you want to save this clinical data with values:\nTest: $selectedReadingType\nReading: ${_readingValueCrtl.text}\nDate Recorded: ${"${selectedDate.toLocal()}".split(' ')[0]}"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _readingValueCrtl.text = "";
                              Navigator.pop(context1);
                            }, 
                            child: const Text("Cancel")
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<ClinicalDataProvider>(context1, listen: false)
                              .editClinicalData(
                                widget.dataID,
                                widget.patientID,
                                updateBodyString
                              );
                              Navigator.pop(context1);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("New Clinical Data Saved Successfully!"),                                    
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientDetailWidget(patientId: widget.patientID)));
                                        }, 
                                        child: const Text("Ok")
                                      )
                                    ],
                                  );
                                }
                              );
                              
                            }, 
                            child: const Text("YES")
                          )
                        ],
                      );
                    }
                  );
                }
              }, 
              child: const Text("Save")
            ),
          ],
        ),
      ),
    );
  }
}

class DropDownMenu extends StatefulWidget {
  final void Function(String)? onValueChanged;

  const DropDownMenu({this.onValueChanged});

  @override
  State<DropDownMenu> createState() => _DropDownMenu();
}

class _DropDownMenu extends State<DropDownMenu> {
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: "None",
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });

        if (widget.onValueChanged != null) {
          widget.onValueChanged!(dropdownValue);
        }
      },
      dropdownMenuEntries: readingType.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}