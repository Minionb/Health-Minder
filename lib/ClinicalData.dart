import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ClinicalData {
  final String id;
  final String patientID;
  final DateTime dateRecord;
  final String dataType;
  final String readingValue;
  final String condition;
  final bool isLatest;

  ClinicalData({
    required this.id,
    required this.patientID,
    required this.dateRecord,
    required this.dataType,
    required this.readingValue,
    required this.condition,
    required this.isLatest
  });

  static List<ClinicalData> parseClinicalData(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ClinicalData>((json) => ClinicalData(
      id: json["_id"], 
      patientID: json["patient_id"], 
      dateRecord: DateTime.parse(json["date_time"]), 
      dataType: json["data_type"], 
      readingValue: json["reading_value"], 
      condition: json["condition"], 
      isLatest: json["isLatest"]
    )).toList();
  }

  factory ClinicalData.fromJson(Map<String, dynamic> json) {
    return ClinicalData(
      id: json['id'] ?? '', 
      patientID: json['patient_id'] ?? '', 
      dateRecord: DateFormat('dd/MM/yyyy').parse(json['date_time'] as String), 
      dataType: json['data_type'] ?? '', 
      readingValue: json['reading_value'] ?? '', 
      condition: json['condition'] ?? '', 
      isLatest: json['isLatest'] ?? ''
    );
  }

  String getFormattedDateOfRecording() {
    return DateFormat('dd/MM/yyyy').format(dateRecord);
  }
}

Future<List<ClinicalData>> fetchClinicalDataByPatient(String id) async {
  final response = await http.get(Uri.parse('http://127.0.0.1:3000/patients/$id/testdata'));

  if (response.statusCode == 200) {
    return ClinicalData.parseClinicalData(response.body);
  } else {
    throw Exception('Failed to fetch clinical data by patient');
  }
}

Future<void> createClinicalData(String patientID, String dateRecord, String dataType, String readingValue) async {
  var url = Uri.parse('http://127.0.0.1:3000/patients/testdata');

  var response = await http.post(url,
    body: {
      'patient_id': patientID, 
      'date_time': dateRecord,
      'data_type': dataType,
      'reading_value': readingValue
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

Future<void> deleteClinicalDataById(String clinicalDataId) async {
  var url = Uri.parse('http://127.0.0.1:3000/patients/testdata/$clinicalDataId');

  var response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Data Deleted");
  }
  else {
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }
}

Future<void> deleteClinicalDataByPatient(String patientId) async {
  var url = Uri.parse('http://127.0.0.1:3000/patients/$patientId/testdata');

  var response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Data Deleted");
  }
  else {
    print('Request failed with status: ${response.statusCode}');
    print(response.body);
  }
}