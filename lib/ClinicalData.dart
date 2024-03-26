import 'dart:convert';
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

