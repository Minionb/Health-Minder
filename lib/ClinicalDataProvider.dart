

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapd722_project_group6/ClinicalData.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';
import 'package:provider/provider.dart';

class ClinicalDataProvider extends ChangeNotifier{
   List<ClinicalData> clinicalDataList = [];

   // String apiURL = "http://127.0.0.1:3000";
   String apiURL = "https://mapd713-project-group7.onrender.com";


  Future<void> fetchClinicalDataByPatient(String id) async {
    final response = await http.get(Uri.parse('$apiURL/patients/$id/testdata'));

    if (response.statusCode == 200) {
        clinicalDataList = ClinicalData.parseClinicalData(response.body);
        notifyListeners();
    } else {
      throw Exception('Failed to fetch clinical data by patient');
    }
  }

  Future<void> createClinicalData(
    // BuildContext context,
    String patientID, 
    String dateRecord,
    String dataType, 
    String readingValue
    ) async {
    var url = Uri.parse('$apiURL/patients/testdata');

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
      clinicalDataList = fetchClinicalDataByPatient(patientID) as List<ClinicalData>;
      notifyListeners();

      // final patientProvider = Provider.of<PatientProvider>(context as BuildContext , listen: false);
      // await patientProvider.fetchPatients({});
      // patientProvider.notifyListeners();
      print(data);

    } else {
      // Request failed, handle the error
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }

  Future<void> deleteClinicalDataById(String clinicalDataId, String patientID) async {
    var url = Uri.parse('$apiURL/patients/testdata/$clinicalDataId');

    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Data Deleted");
      clinicalDataList = fetchClinicalDataByPatient(patientID) as List<ClinicalData>;
      notifyListeners();

      // final patientProvider = Provider.of<PatientProvider>(context as BuildContext, listen: false);
      // await patientProvider.fetchPatients({});
      // patientProvider.notifyListeners();
    }
    else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }
}