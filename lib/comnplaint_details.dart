import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'complaint_controller.dart';
import 'package:intl/intl.dart';

class ComplaintDetailPage extends StatelessWidget {
  final int complaintId;
  final List<String> technicians = [
    'Shyjith P.',
    'Deepak V. Pillai',
    'Arun Pappan',
    'Varun P. Nair',
    'Jitesh V.'
  ];

  ComplaintDetailPage({Key? key, required this.complaintId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ComplaintController>();
    final complaint = controller.getComplaintById(complaintId);

    // Initialize text controllers with existing complaint data
    final attendedDateController = TextEditingController(
      text: complaint?.attendedDate != null
          ? DateFormat('yyyy-MM-dd').format(complaint!.attendedDate!)
          : "",
    );
    final completedDateController = TextEditingController(
      text: complaint?.completedDate != null
          ? DateFormat('yyyy-MM-dd').format(complaint!.completedDate!)
          : "",
    );
    final remarksController = TextEditingController(text: complaint?.remark ?? "");

    // Set initial technician name
    String selectedTechnician = complaint?.technicianName ?? technicians.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Complaint ID: $complaintId", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Technician Name Dropdown
            DropdownButtonFormField<String>(
              value: selectedTechnician,
              items: technicians.map((technician) {
                return DropdownMenuItem(
                  value: technician,
                  child: Text(technician),
                );
              }).toList(),
              onChanged: (value) {
                selectedTechnician = value!;
              },
              decoration: const InputDecoration(
                labelText: 'Technician Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Attended Date
            TextField(
              controller: attendedDateController,
              readOnly: true,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  attendedDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Attended Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Completed Date
            TextField(
              controller: completedDateController,
              readOnly: true,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  completedDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Completed Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Remarks
            TextField(
              controller: remarksController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Update Details Button
            ElevatedButton(
              onPressed: () async {
                await controller.updateComplaintStatus(
                  complaintId,
                  {
                    'technician_name': selectedTechnician,
                    'attended_date': attendedDateController.text,
                    'completed_date': completedDateController.text,
                    'remark': remarksController.text,
                  },
                );
                Get.back();
              },
              child: const Text('Update Details'),
            ),
            const SizedBox(height: 10),

            // Mark as Resolved Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                try {
                  await controller.updateComplaintStatus(
                    complaintId,
                    {
                      'status': 'Completed',
                      'technician_name': selectedTechnician,
                      'attended_date': attendedDateController.text,
                      'completed_date': completedDateController.text,
                      'remark': remarksController.text,
                    },
                  );

                  // Show the success snackbar
                  Get.snackbar(
                    'Success',
                    'Complaint marked as resolved',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );

                  // Navigate back after a small delay to ensure the snackbar is visible
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Get.back();
                  });
                } catch (e) {
                  // Show the error snackbar
                  Get.snackbar(
                    'Error',
                    'Failed to mark as resolved',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                }
              },
              child: const Text('Mark as Resolved'),
            ),
          ],
        ),
      ),
    );
  }
}
