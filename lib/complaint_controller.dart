import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'support_model.dart'; // Import the Complaint model
import 'shared.dart'; // Use this for IP and API path configuration

class ComplaintController extends GetxController {
  // Observable lists for pending and completed complaints
  var pendingComplaints = <Complaint>[].obs;
  var completedComplaints = <Complaint>[].obs;

  // Current complaint for registration
  var complaintData = Complaint(
    id: 0,
    labName: "L1", // default lab
    labIncharge: "Varun P Nair", // default lab incharge
    complaint: "",
    date: DateTime.now(),
    status: "Pending", // default status
  ).obs;

  // Page index for bottom navigation
  var pageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchComplaints(); // Ensure complaints are loaded at startup
  }

  // Fetch all complaints and categorize them as pending or completed
  Future<void> fetchComplaints() async {
    var url = "${Sharedvariable().ip}/complaints";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Complaint> complaints = complaintsFromJson(response.body);
        pendingComplaints.value =
            complaints.where((c) => c.status == "Pending").toList();
        completedComplaints.value =
            complaints.where((c) => c.status == "Completed").toList();
        //print("Complaints fetched successfully");
      } else {
        Get.snackbar("Error",
            "Failed to fetch complaints. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // print("Exception: $e");
      Get.snackbar("Error", "An error occurred while fetching complaints.");
    }
  }

  // Save a new complaint
  Future<void> saveComplaint(Complaint newComplaint) async {
    var url = "${Sharedvariable().ip}/complaints";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newComplaint.toJson()),
      );

      if (response.statusCode == 201) {
        sendEmailNotification({
          "labName": newComplaint.labName ?? "",
          "stockNo": newComplaint.stockNo ?? "",
          "registeredBy": newComplaint.labIncharge ?? "",
          "complaint": newComplaint.complaint ?? "",
        });

        //print("Complaint saved successfully");
        Get.snackbar("Success", "Complaint registered successfully.");
        fetchComplaints(); // Refresh the complaint list after saving
      } else {
        Get.snackbar("Error",
            "Failed to register complaint. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // print("Exception: $e");
      Get.snackbar("Error", "An error occurred while saving the complaint.");
    }
  }

  // Update the status of a complaint
  // Update the status of a complaint
  Future<void> updateComplaintStatus(
      int id, Map<String, dynamic> updatedData) async {
    var url = "${Sharedvariable().ip}/complaints/$id/";
    // print(updatedData);

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        //print("Complaint updated successfully");
        fetchComplaints(); // Refresh the list
        Get.snackbar("Success", "Complaint updated successfully.");
      } else {
        //print("Error updating complaint: ${response.statusCode}");
        Get.snackbar("Error", "Failed to update complaint. Please try again.");
      }
    } catch (e) {
      //print("Exception: $e");
      Get.snackbar("Error", "An error occurred while updating the complaint.");
    }
  }

  // Get a complaint by ID
  Complaint? getComplaintById(int id) {
    try {
      return pendingComplaints.firstWhere((complaint) => complaint.id == id,
          orElse: () => completedComplaints.firstWhere(
              (complaint) => complaint.id == id,
              orElse: () => throw Exception("Complaint not found")));
    } catch (e) {
      return null;
    }
  }

  Future<void> sendEmailNotification(Map<String, String> details) async {
    try {

  //     var body = jsonEncode({
  //   "emailid": "varunpnair92@gmail.com",
  //   "subject": "Complaint Notification",
  //   "message": "Location: LAB-2\nStock No: FISATPC1614\nComplaint Registered by: VARUN P NAIR\nComplaint: NO TERMINAL(PC 21)"
  // });
      final response = await http.post(
        Uri.parse("${Sharedvariable().ip}/emailAny"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "emailid": "varunpnair92@gmail.com",
          "subject": "Complaint Registered from ${details["labName"]}",
          "message": """
        
          Location : ${details["labName"]} \n
          Stock No : ${details["stockNo"]}\n
          Pc No : ${details[""]}\n
          Complaint Registered by : ${details["registeredBy"]}\n
          Complaint : ${details["complaint"]}
        
        """
        }),
        
      );

      if (response.statusCode == 200) {
        Get.snackbar("Email Sent", "Notification sent successfully.",
            backgroundColor: Colors.green);
      } else {
        print("Failed to send email: ${response.body}");
        Get.snackbar("Error", "Failed to send email.",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Error sending email: $e");
      Get.snackbar("Error", "Failed to send email.",
          backgroundColor: Colors.red);
    }
  }
}
