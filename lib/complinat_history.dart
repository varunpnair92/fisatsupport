import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'complaint_controller.dart';

class ComplaintHistoryPage extends StatelessWidget {
  const ComplaintHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ComplaintController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complaint History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Complaints
            Obx(() {
              final pendingComplaints = controller.pendingComplaints;
              if (pendingComplaints.isEmpty) {
                return const Center(child: Text('No pending complaints.'));
              }
              return ListView.builder(
                itemCount: pendingComplaints.length,
                itemBuilder: (context, index) {
                  final complaint = pendingComplaints[index];
                  return ListTile(
                    title: Text(complaint.complaint),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lab Name: ${complaint.labName}"),
                        Text("Stock No: ${complaint.stockNo}"),
                        Text("Pc No: ${complaint.pcNo}"),
                        Text("Lab Incharge: ${complaint.labIncharge}"),
                        Text("Registered Date: ${DateFormat('dd-MM-yyyy').format(complaint.date)}"),
                        Text("Status: ${complaint.status}"),
                        Text("Remarks: ${complaint.remark}"),
                      ],
                    ),
                    onTap: () => Get.toNamed("/details", arguments: complaint.id),
                  );
                },
              );
            }),

            // Completed Complaints
            Obx(() {
              final completedComplaints = controller.completedComplaints;
              if (completedComplaints.isEmpty) {
                return const Center(child: Text('No completed complaints.'));
              }
              return ListView.builder(
                itemCount: completedComplaints.length,
                itemBuilder: (context, index) {
                  final complaint = completedComplaints[index];
                  return ListTile(
                    title: Text(complaint.complaint),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lab Name: ${complaint.labName}"),
                        Text("Lab Incharge: ${complaint.labIncharge}"),
                        Text("Registered Date: ${DateFormat('dd-MM-yyyy').format(complaint.date)}"),
                        Text("Attended Date: ${complaint.attendedDate != null ? DateFormat('dd-MM-yyyy').format(complaint.attendedDate!) : 'Not Set'}"),
                        Text("Completed Date: ${complaint.completedDate != null ? DateFormat('dd-MM-yyyy').format(complaint.completedDate!) : 'Not Set'}"),
                        Text("Technician Name: ${complaint.technicianName ?? 'Not Set'}"),
                        Text("Status: ${complaint.status}"),
                         Text("Remarks: ${complaint.remark}"),
                      ],
                    ),
                    onTap: () => Get.offAllNamed("/details", arguments: complaint.id), // Correct route and arguments
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
