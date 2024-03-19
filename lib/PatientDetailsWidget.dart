import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/ClinicalDataScreen.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:provider/provider.dart';

class PatientDetailWidget extends StatefulWidget {
  final String patientId;

  const PatientDetailWidget({super.key, required this.patientId});

  @override
  State<StatefulWidget> createState() {
    return PatientDetailWidgetState();
  }
}

class PatientDetailWidgetState extends State<PatientDetailWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Patient Information'),
                Tab(text: 'Clinical Data'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // First tab content: Patient Details
                  FutureBuilder(future: Provider.of<PatientProvider>(context, listen: false)
              .fetchPatientById(widget.patientId),
               builder: (cntx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
                  : Consumer<PatientProvider>(
                    builder: (context, patientProvider, _) {
                      final patient = patientProvider.patient;
                      if (patient == null) {
                        return const Center(
                          child: Text('No Such Patient'),
                        );
                      }
                      return Material(
                        child: Center(
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              ListTile(
                                title: const Text(
                                  'Name',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${patient.firstName} ${patient.lastName}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Address',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  patient.address,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Date of Birth',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  patient.getFormattedDateOfBirth(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Gender',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  patient.gender,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Department',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  patient.department,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'Doctor',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  patient.doctor,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              if (patient.additionalNotes != '')
                                ListTile(
                                  title: const Text(
                                    'Additional Notes',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patient.additionalNotes!,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ),
                  // Second tab content: Clinical Data
                  ClinicalDataScreen(patientId: widget.patientId),
                  
                ],
              )
            )
          ]
        ),
      ),
    );
  }
}