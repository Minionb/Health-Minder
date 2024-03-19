import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/ClinicalData.dart';
import 'package:mapd722_project_group6/PatientDetailsWidget.dart';

enum Item { edit, delete }

class ClinicalDataWidget extends StatefulWidget {
  final ClinicalData clinicalData;

  const ClinicalDataWidget({
    Key? key, 
    required this.clinicalData
  }) : super(key: key);

  @override
  State<ClinicalDataWidget> createState() => _ClinicalDataWidget();
}
class _ClinicalDataWidget extends State<ClinicalDataWidget> {

  @override
  Widget build(BuildContext context) {
    Color conditionColor;
    Color textColor;
    Item? selectedItem;

    switch (widget.clinicalData.condition) {
      case 'critical':
        conditionColor = const Color(0xFF9A1B22);
        textColor = Colors.white;
        break;
      case 'bad':
        conditionColor = const Color(0xFFB94723);
        textColor = Colors.white;
        break;
      case 'average':
        conditionColor = const Color(0xFFF9E802);
        textColor = Colors.black;
        break;
      case 'fine':
        conditionColor = const Color(0xFF4CC9F0);
        textColor = Colors.black;
        break;
      case 'good':
        conditionColor = const Color(0xFF008000);
        textColor = Colors.white;
        break;
      default:
        conditionColor = const Color(0xFFCCCCCC);
        textColor = Colors.black;
    }

    return Card(
      color: conditionColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0)
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(widget.clinicalData.dataType, style: TextStyle(
                  fontSize: 25,
                  fontWeight:FontWeight.bold, 
                  color: textColor,// Set the text color to white for better visibility
                )),
                const Expanded(child: Spacer()),
                PopupMenuButton<Item>(
                  icon: Icon(Icons.menu, color: textColor,),
                  initialValue: selectedItem,
                  onSelected: (Item item) {
                    setState(() {
                      selectedItem = item;
                    });
                    if (selectedItem == Item.delete) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Clinical Data?"),
                            content: const Text("Are you sure?"),                                    
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                }, 
                                child: const Text("Cancel")
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteClinicalDataById(widget.clinicalData.id);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PatientDetailWidget(patientId: widget.clinicalData.patientID)));
                                }, 
                                child: const Text("DELETE")
                              )
                            ],
                          );
                        }
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Item>>[
                    const PopupMenuItem<Item>(
                      value: Item.edit,
                      child: Text('edit')
                    ),
                    const PopupMenuItem<Item>(
                      value: Item.delete,
                      child: Text('DELETE', style: TextStyle(color: Colors.red),)
                    ),
                  ]
                )
              ],
            ),
            SizedBox(height: 8.0),
            Text(widget.clinicalData.readingValue, style: TextStyle(
              fontSize: 18,
              fontWeight:FontWeight.bold, 
              color: textColor,// Set the text color to white for better visibility
            ),),
            Text(widget.clinicalData.getFormattedDateOfRecording(), style: TextStyle(
              fontSize: 18,
              fontWeight:FontWeight.bold, 
              color: textColor,// Set the text color to white for better visibility
            ),)
          ],
        ),
      ),
    );
  }
}