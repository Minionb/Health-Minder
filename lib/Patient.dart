import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final DateTime dateOfBirth;
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
}

Future<List<Patient>> fetchPatients() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:3000/patients'));

  if (response.statusCode == 200) {
    return Patient.parsePatients(response.body);
  } else {
    throw Exception('Failed to fetch patients');
  }
}