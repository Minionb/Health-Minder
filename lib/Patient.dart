import 'dart:convert';
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

    const Patient({
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