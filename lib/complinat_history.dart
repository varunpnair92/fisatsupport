import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'complaint_controller.dart';

class ComplaintHistoryPage extends StatefulWidget {
  const ComplaintHistoryPage({super.key});

  @override
  State<ComplaintHistoryPage> createState() => _ComplaintHistoryPageState();
}

class _ComplaintHistoryPageState extends State<ComplaintHistoryPage> {
  final TextEditingController searchController = TextEditingController();
  String searchText = '';

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
              return ListView.separated(
                itemCount: pendingComplaints.length,
                separatorBuilder: (context, index) => const Divider(),
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

            // Completed Complaints with Search
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() => searchText = value.toLowerCase()),
                    decoration: const InputDecoration(
                      labelText: 'Search Completed Complaints',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final completedComplaints = controller.completedComplaints
                        .where((complaint) =>
                            complaint.complaint.toLowerCase().contains(searchText) ||
                            complaint.labName.toLowerCase().contains(searchText) ||
                            complaint.technicianName?.toLowerCase().contains(searchText) == true)
                        .toList();

                    if (completedComplaints.isEmpty) {
                      return const Center(child: Text('No completed complaints found.'));
                    }

                    return ListView.separated(
                      itemCount: completedComplaints.length,
                      separatorBuilder: (context, index) => const Divider(),
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
                          onTap: () => Get.toNamed("/details", arguments: complaint.id),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
