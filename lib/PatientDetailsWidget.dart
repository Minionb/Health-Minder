import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/Patient.dart';

class PatientDetailWidget extends StatefulWidget {
  final String patientId;

  PatientDetailWidget({required this.patientId});

  @override
  State<StatefulWidget> createState() {
    return PatientDetailWidgetState();
  }
}

class PatientDetailWidgetState extends State<PatientDetailWidget> {


  late Future<Patient> patient;
    
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
        title: Text('Patient Details'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
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
                              padding: EdgeInsets.all(16),
                              children: [
                                ListTile(
                                  title: Text(
                                    'Name',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${patientData.firstName} ${patientData.lastName}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Address',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.address,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Date of Birth',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.getFormattedDateOfBirth(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Gender',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.gender,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Department',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.department,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Doctor',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    patientData.doctor,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                if (patientData.additionalNotes != '')
                                  ListTile(
                                    title: Text(
                                      'Additional Notes',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      patientData.additionalNotes!,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print(snapshot);
                        return Text('Failed to fetch patient data');
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  // Second tab content: Clinical Data
                  Center(
                    child: Text(
                      'Clinical Data',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}