import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'complaint_controller.dart';
import 'package:intl/intl.dart';

class ComplaintDetailPage extends StatelessWidget {
  final int complaintId;

  ComplaintDetailPage({Key? key, required this.complaintId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ComplaintController>();
    final complaint = controller.getComplaintById(complaintId);

    // Initialize text controllers with existing complaint data
    final technicianNameController = TextEditingController(text: complaint?.technicianName ?? "");
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
            TextField(
              controller: technicianNameController,
              decoration: const InputDecoration(
                labelText: 'Technician Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
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
            TextField(
              controller: remarksController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await controller.updateComplaintStatus(
                  complaintId,
                  {
                    'technician_name': technicianNameController.text,
                    'attended_date': attendedDateController.text,
                    'completed_date': completedDateController.text,
                    'remark': remarksController.text,
                  },
                );
              },
              child: const Text('Update Details'),
            ),
const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                await controller.updateComplaintStatus(
                  complaintId,
                  {'status': 'Completed',
                  'technician_name': technicianNameController.text,
                    'attended_date': attendedDateController.text,
                    'completed_date': completedDateController.text,
                    'remark': remarksController.text,},
                );
                Get.back(); // Go back to the previous page after resolving
              },
              child: const Text('Mark as Resolved'),
            ),

          ],
        ),
      ),
    );
  }
}
