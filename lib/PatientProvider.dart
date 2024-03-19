import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_project_group6/Patient.dart';
import 'package:provider/provider.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> patients = [];
  
  Future<void> fetchPatients(Map<String, String> patientQueryParams) async {
    final url = Uri.parse('http://127.0.0.1:3000/patients')
        .replace(queryParameters: patientQueryParams);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      patients =  Patient.parsePatients(response.body);
    } else {
      throw Exception('Failed to fetch patients');
    }
    notifyListeners();
  }



  Future<void> createPatient(String firstName, String lastName, String address, String dateOfBirth, String gender, String department, String doctor, String additionalNotes) async {
    var url = Uri.parse('http://127.0.0.1:3000/patients');

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
      // Request successful, parse the response
      var data = response.body;
      // Process the data or update your UI accordingly
      print(data);
      patients.add({
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'department': department,
        'doctor': doctor,
        'additional_notes': additionalNotes
      } as Patient);
      notifyListeners();
    } else {
      // Request failed, handle the error
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }

  Future<void> deletePatient(String patientId) async {
    final url = 'http://127.0.0.1:3000/patients/$patientId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Patient deleted successfully');
      //get the deleted patient from the list
      var todelte = patients.where((p) => p.id == patientId );
      patients.remove(todelte);
      notifyListeners();

    } else {
      throw Exception('Failed to delete patient');
    }
  } 

  Future<void> editPatient(String patientID, String updateBodyString) async {
    final url = 'http://127.0.0.1:3000/patients/$patientID';
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: updateBodyString,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Do something with the response data
    } else {
      // Handle any errors or failure cases
    }
  }

}




  Future<Patient> fetchPatientById(String id) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:3000/patients/$id'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      final Patient patient = Patient.fromJson(data);
      return patient;
    } else {
      throw Exception('Failed to fetch patient');
    }
  }






