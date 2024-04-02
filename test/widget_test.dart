// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapd722_project_group6/AddPatientScreen.dart';
import 'package:mapd722_project_group6/NewClinicalDataScreen.dart';
import 'package:mapd722_project_group6/PatientDetailsWidget.dart';
import 'package:mapd722_project_group6/PatientList.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:mapd722_project_group6/PatientWidget.dart';

import 'package:mapd722_project_group6/main.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// class MockHttpClient extends Mock implements HttpClient {}

void main() {

  testWidgets('finds instance of NewClinicalDataScreen', (widgetTester) async {
    const childWidget = MaterialApp(
      title: 'Health Minder'
    );
    
    await widgetTester.pumpWidget(childWidget);

    expect(find.byWidget(childWidget), findsOneWidget);
  });

  testWidgets('find textfields in NewClinicalData', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: NewClinicalData(patientId: '653bff257990b371f8120443')));

    var textField = find.byType(TextField);

    expect(textField, findsNWidgets(2));
  });

  // testWidgets('find textfields in AddPatient', (widgetTester) async {
  //   await widgetTester.pumpWidget(MaterialApp(home: AddPatient()));

  //   var textField = find.byType(TextField);

  //   expect(textField, findsNWidgets(6));
  // });

  // testWidgets('Search patient', (widgetTester) async {
  //   final mockClient = MockHttpClient();

  //   when(mockClient.get(Uri.parse('https://mapd713-project-group7.onrender.com/p')))

  //   var childWidget = ChangeNotifierProvider<PatientProvider>(
  //     create: (context) => PatientProvider(), 
  //     child: const PatientList(),
  //   );

  //   await widgetTester.pumpWidget(childWidget);

  //   await widgetTester.enterText(find.byType(TextField), 'Jenny');

  //   await widgetTester.tap(find.byType(IconButton));

  //   await widgetTester.pump();

  //   expect(find.byType(PatientWidget), findsOneWidget);
  // });

  // testWidgets('finds instance of Add Patient', (widgetTester) async {
  //   var childWidget = ChangeNotifierProvider<PatientProvider>(
  //     create: (context) => PatientProvider(), 
  //     child: const PatientList(),
  //   );

  //   await widgetTester.pumpWidget(childWidget);

  //   expect(find.byWidget(childWidget), findsOneWidget);
  // });
}
