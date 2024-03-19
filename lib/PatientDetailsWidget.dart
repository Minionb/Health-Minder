import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/ClinicalData.dart';
import 'package:mapd722_project_group6/ClinicalDataProvider.dart';
import 'package:mapd722_project_group6/ClinicalDataScreen.dart';
import 'package:mapd722_project_group6/Patient.dart';
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

  late Future<Patient> patient;
  late Future<List<ClinicalData>> clinicalData;
    
  @override
  void initState() {
    super.initState();
    fetchPatientData();
  
  }

  void fetchPatientData() {
    patient = fetchPatientById(widget.patientId);
  }



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
                  FutureBuilder<Patient>(
                    future: patient,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final patientData = snapshot.data!;
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
                                    '${patientData.firstName} ${patientData.lastName}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Address',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.address,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Date of Birth',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.getFormattedDateOfBirth(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Gender',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.gender,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Department',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.department,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Doctor',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.doctor,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                if (patientData.additionalNotes != '')
                                  ListTile(
                                    title: const Text(
                                      'Additional Notes',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      patientData.additionalNotes!,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Failed to fetch patient data');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  // Second tab content: Clinical Data
                  ClinicalDataScreen(patientId: widget.patientId)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}