import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/ClinicalData.dart';
import 'package:mapd722_project_group6/ClinicalDataWidget.dart';
import 'package:mapd722_project_group6/NewClinicalDataScreen.dart';

class ClinicalDataScreen extends StatefulWidget {
  final String patientId;
  final List<ClinicalData> clinicalData;

  const ClinicalDataScreen({super.key, required this.patientId, required this.clinicalData});

  @override
  State<ClinicalDataScreen> createState() => _ClinicalDataScreen();
}

class _ClinicalDataScreen extends State<ClinicalDataScreen> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.clinicalData.isNotEmpty ? 
          Expanded(
            child: ListView.builder(
              itemCount: widget.clinicalData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: ClinicalDataWidget(clinicalData: widget.clinicalData[index]),
                );
              }
            )
          )
          :
          const Expanded(
            child: Center(
              child: Text(
                'No Clinical Data',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewClinicalData(patientId: widget.patientId)));
            },
            child: const Text("New Record", style: TextStyle(fontSize: 20)),
          ),
          const Padding(padding: EdgeInsets.all(20)),
          // Row(
          //   children: [
          //     const Expanded(child: Spacer()),
          //     FloatingActionButton(onPressed: () {
                  
          //       },
          //       child: const Text("+", style: TextStyle(fontSize: 25)),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

}