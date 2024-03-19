import 'package:flutter/material.dart';
import 'package:mapd722_project_group6/Patient.dart';
import 'package:mapd722_project_group6/PatientProvider.dart';

class PatientWidget extends StatelessWidget {
  final Patient patient;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PatientWidget({
    Key? key,
    required this.patient,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color conditionColor;
    Color textColor;

    // Determine the color based on the patient's condition
    switch (patient.condition) {
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

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: conditionColor, // Set the background color of the card
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            '${patient.firstName} ${patient.lastName}',
            style: TextStyle(
              fontWeight:FontWeight.bold, 
              color: textColor,// Set the text color to white for better visibility
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}