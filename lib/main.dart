import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/AddPatientScreen.dart';
import 'package:mapd722_project_group6/MainDrawer.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
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

Map<String, String> productQueryParams = {
    'first_name': '',
    'last_name': '',
  };

  @override
  void initState() {
    super.initState();
    patients = fetchPatients(productQueryParams);
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
          future: fetchPatients(productQueryParams),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Scaffold(
                body: PatientList(
                  snapshot.data ?? [],
                ),
              );
            }
          },
        ),
        '/AddPatient': (context) => AddPatient(),
      },
    );
  }
}