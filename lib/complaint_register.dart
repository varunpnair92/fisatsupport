import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:support/complaint_controller.dart';
import 'package:support/support_model.dart';

// ignore: must_be_immutable
class RegisterComplaintPage extends StatelessWidget {
  RegisterComplaintPage({super.key});

  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _stockNoController = TextEditingController();
  final TextEditingController _pcNoController = TextEditingController();

  final List<String> _labs = [
    "L1", "L2", "L3", "L4", "L5", "L6", "L7", "L8", "L9"
  ];

  final String _defaultIncharge = "Varun P Nair";
  final String _defaultDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final ComplaintController _controller = Get.put(ComplaintController());

  // Initialize _selectedLab here, since it's not going to change
  String _selectedLab = "L1";  // Default value

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dropdown for selecting a lab
            DropdownButtonFormField<String>(
              value: _selectedLab,
              items: _labs
                  .map((lab) => DropdownMenuItem(value: lab, child: Text(lab)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  // Using setState to update the _selectedLab value
                  _selectedLab = value;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Select Lab',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _defaultIncharge,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Lab Incharge',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _defaultDate,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _stockNoController,
              decoration: const InputDecoration(
                labelText: 'Enter Stock Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pcNoController,
              decoration: const InputDecoration(
                labelText: 'Enter PC Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _complaintController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Enter your complaint',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_complaintController.text.isNotEmpty &&
                    _stockNoController.text.isNotEmpty &&
                    _pcNoController.text.isNotEmpty) {
                  // Correctly parse the date using the existing format
                  final complaintDate = DateFormat('yyyy-MM-dd').parse(_defaultDate);

                  // Create a new complaint object
                  final newComplaint = Complaint(
                    id: 0,
                    labName: _selectedLab,
                    labIncharge: _defaultIncharge,
                    complaint: _complaintController.text,
                    date: complaintDate,
                    status: "Pending",
                    stockNo: _stockNoController.text,
                    pcNo: _pcNoController.text,
                  );

                  // Save the complaint using the controller
                  _controller.saveComplaint(newComplaint).then((_) {
                    _complaintController.clear();
                    _stockNoController.clear();
                    _pcNoController.clear();
                    
                  }).catchError((error) {
                    Get.snackbar('Error', 'Failed to register complaint.');
                    //print("Error saving complaint: $error");
                  });
                } else {
                  // If any required field is empty, show a snackbar message
                  Get.snackbar('Error', 'Please fill all the fields');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
