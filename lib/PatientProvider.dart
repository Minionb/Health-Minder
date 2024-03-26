import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_project_group6/Patient.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> patients = [];

     // String apiURL = "http://127.0.0.1:3000";
  String apiURL = "https://mapd713-project-group7.onrender.com";
  
  Patient patient = Patient(id: "", firstName: "", lastName: "", address: "", dateOfBirth: DateTime.now(), gender: "", department: "", doctor: "", additionalNotes: "", condition: "");
  
  Future<void> fetchPatients(Map<String, String> patientQueryParams) async {
    final url = Uri.parse('$apiURL/patients')
        .replace(queryParameters: patientQueryParams);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      patients =  Patient.parsePatients(response.body);
    } else {
      throw Exception('Failed to fetch patients');
    }
    notifyListeners();
  }

  Future<void> fetchPatientById(String id) async {
    final response = await http.get(Uri.parse('$apiURL/patients/$id'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      patient = Patient.fromJson(data);
      notifyListeners();
    } else {
      throw Exception('Failed to fetch patient');
    }
  }


  Future<void> createPatient(String firstName, String lastName, String address, String dateOfBirth, String gender, String department, String doctor, String additionalNotes) async {
    var url = Uri.parse('$apiURL/patients');

    var response = await http.post(url, 
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'department': department,
        'doctor': doctor,
        'additional_notes': additionalNotes
      }
    );

    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
      patients = fetchPatients({}) as List<Patient>;
      notifyListeners();
    } else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }

  Future<void> deletePatient(String patientId) async {
    final url = '$apiURL/patients/$patientId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Patient deleted successfully');
      //get the deleted patient from the list
      // var todelte = patients.where((p) => p.id == patientId );
      // patients.remove(todelte);
      patients = fetchPatients({}) as List<Patient>;
      notifyListeners();
    } else {
      throw Exception('Failed to delete patient');
    }
  } 

  Future<void> editPatient(String patientID, String updateBodyString) async {
    final url = '$apiURL/patients/$patientID';
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: updateBodyString,
    );
    
    if (response.statusCode == 200) {
      patients = fetchPatients({}) as List<Patient>;
      notifyListeners();
    } else {
      throw Exception('Failed to update patient');
    }
  }
}






