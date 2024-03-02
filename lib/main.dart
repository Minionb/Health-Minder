import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/AddPatientScreen.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/Patient.dart';
import 'package:mapd722_project_group6/PatientList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

late Future<List<Patient>> patients;

  @override
  void initState() {
    super.initState();
    patients = fetchPatients();
  }

  // Reload the list by fetching the patients again
  void reloadList() {
    setState(() {
      patients = fetchPatients();
    });
  }
  

  // This widget is the root of your application.
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Minder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => FutureBuilder<List<Patient>>(
          future: fetchPatients(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Scaffold(
                body: PatientList(
                  snapshot.data ?? [],
                  reloadList: () {
                    setState(() {
                  patients = fetchPatients();
            });
          },
                  
                ),
              );
            }
          },
        ),
        '/AddPatient': (context) => AddPatient(reloadList: () {
                          setState(() {
                          patients = fetchPatients();
                          });
                      }),
      },
    );
  }
}