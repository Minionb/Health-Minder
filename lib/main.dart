import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/AddPatientScreen.dart';
import 'package:mapd722_project_group6/ClinicalDataProvider.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:mapd722_project_group6/PatientList.dart';
import 'package:provider/provider.dart';

void main() {
runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PatientProvider>(
        create: (context) => PatientProvider(),
      ),
      
      ChangeNotifierProvider<ClinicalDataProvider>(
        create: (context) => ClinicalDataProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

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
        '/': (context) =>  const PatientList(),
        '/AddPatient': (context) => AddPatient(),
      },
    );
  }
}