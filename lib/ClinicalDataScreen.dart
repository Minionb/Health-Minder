import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/ClinicalDataProvider.dart';
import 'package:mapd722_project_group6/ClinicalDataWidget.dart';
import 'package:mapd722_project_group6/NewClinicalDataScreen.dart';
import 'package:provider/provider.dart';

class ClinicalDataScreen extends StatefulWidget {
  final String patientId;

  const ClinicalDataScreen({super.key, required this.patientId});

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
          Expanded(
            child: FutureBuilder(
              future: Provider.of<ClinicalDataProvider>(context, listen: false)
                  .fetchClinicalDataByPatient(widget.patientId),
              builder: (cntx, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<ClinicalDataProvider>(
                      child: const Center(
                        child: Text('No Clinical Data Yet'),
                      ),
                      builder: (context, ClinicalDataProvider, child) =>
                          ClinicalDataProvider.clinicalDataList.isEmpty
                              ? child!
                              : ListView.builder(
                                  itemCount:
                                      ClinicalDataProvider.clinicalDataList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: ClinicalDataWidget(
                                        clinicalData: ClinicalDataProvider
                                            .clinicalDataList[index],
                                      ),
                                    );
                                  },
                                ),
                    ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewClinicalData(patientId: widget.patientId),
                ),
              );
            },
            child: const Text("New Record", style: TextStyle(fontSize: 20)),
          ),
          const Padding(padding: EdgeInsets.all(20)),
        ],
      ),
    );
  }
}