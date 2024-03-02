import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final DateTime? dateOfBirth;
  final String gender;
  final String department;
  final String doctor;
  final String additionalNotes;
  final String condition;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
    required this.department,
    required this.doctor,
    required this.additionalNotes,
    required this.condition,
  });

  static List<Patient> parsePatients(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Patient>((json) => Patient(
      id: json["_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      address: json["address"],
      dateOfBirth: DateTime.parse(json["date_of_birth"]),
      gender: json["gender"],
      department: json["department"],
      doctor: json["doctor"],
      additionalNotes: json["additional_notes"],
      condition: json["condition"],
    )).toList();
  }

    factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: json['date_of_birth'] != null
            ? DateFormat('yyyy-MM-dd').parse(json['date_of_birth'] as String) : null,
      gender: json['gender'] ?? '',
      department: json['department'] ?? '',
      doctor: json['doctor'] ?? '',
      additionalNotes: json['additional_notes'] ?? '',
      condition: json['condition'] ?? '',
    );
  }

  String getFormattedDateOfBirth() {
      if (dateOfBirth != null) {
        return DateFormat('yyyy-MM-dd').format(dateOfBirth!);
      }
      return '';
  }
}

Future<List<Patient>> fetchPatients() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:3000/patients'));

  if (response.statusCode == 200) {
    return Patient.parsePatients(response.body);
  } else {
    throw Exception('Failed to fetch patients');
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



Future<void> createPatient(String firstName, String lastName, String address, String dateOfBirth, String gender, String department, String doctor, String additionalNotes) async {
  var url = Uri.parse('http://127.0.0.1:3000/patients');
  //var headers = {'Content-Type': 'application/json'};
  //var body = newPatient;

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
  } else {
    // Request failed, handle the error
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }
}