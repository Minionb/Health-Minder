import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/ClinicalData.dart';
import 'package:mapd722_project_group6/ClinicalDataProvider.dart';
import 'package:mapd722_project_group6/PatientDetailsWidget.dart';
import 'package:provider/provider.dart';

const List<String> readingType = <String>['Blood Pressure', 'Respiratory Rate', 'Blood Oxygen Level', 'Heartbeat Rate'];

class NewClinicalData extends StatefulWidget {
  final String patientId;

  const NewClinicalData({super.key, required this.patientId});

  @override
  State<NewClinicalData> createState() => _NewClinicalData();
}

class _NewClinicalData extends State<NewClinicalData> {
  String selectedReadingType = "";
  final _readingValueCrtl = TextEditingController();
  DateTime selectedDate = DateTime.now();

  late ClinicalData newClinicalData;

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("New Record"),),
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
                  DropDownMenu(onValueChanged: handleDropdownValueChanged,),
                ],
              ),
            ),
            // Center(
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       const Text("Reading:"),
            //       TextField(controller: _readingValueCrtl,)
            //     ],
            //   ),
            // ),
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
            Spacer(),
            ElevatedButton(
              onPressed: () => {
                if (selectedReadingType != "" && _readingValueCrtl.text != "") {
                  if (selectedReadingType == "Blood Pressure") {
                    _readingValueCrtl.text += " mmHg"
                  }
                  else if (selectedReadingType == "Respiratory Rate") {
                    _readingValueCrtl.text += "/min"
                  }
                  else if (selectedReadingType == "Blood Oxygen Level") {
                    _readingValueCrtl.text += " %"
                  }
                  else {
                    _readingValueCrtl.text += " /min"
                  },
                  showDialog(
                    context: context,
                    builder: (BuildContext context1) {
                      return AlertDialog(
                        title: const Text("Save New Clinical Data?"),
                        content: Text("Are you sure you want to save a new clinical data with values:\nTest: $selectedReadingType\nReading: ${_readingValueCrtl.text}\nDate Recorded: ${"${selectedDate.toLocal()}".split(' ')[0]}"),
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
                              .createClinicalData(
                                // context1,
                                widget.patientId, 
                                "${selectedDate.toLocal()}".split(' ')[0], 
                                selectedReadingType,
                                _readingValueCrtl.text
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
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientDetailWidget(patientId: widget.patientId)));
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
                  )
                }
              }, 
              child: const Text("Save")
            ),
            Spacer()
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