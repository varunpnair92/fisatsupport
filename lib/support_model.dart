import 'dart:convert';

// Complaint Model
class Complaint {
  int id;
  String labName;
  String labIncharge;
  String complaint;
  DateTime date;
  String status;
  String? technicianName;
  DateTime? attendedDate;
  DateTime? completedDate;
  String? remark;
  String? stockNo;  // New field
  String? pcNo;     // New field

  Complaint({
    required this.id,
    required this.labName,
    required this.labIncharge,
    required this.complaint,
    required this.date,
    required this.status,
    this.technicianName,
    this.attendedDate,
    this.completedDate,
    this.remark,
    this.stockNo,  // New field
    this.pcNo,     // New field
  });

  // Factory method to create a Complaint from JSON
  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] ?? 0,
      labName: json['lab_name'] ?? '',
      labIncharge: json['lab_incharge'] ?? '',
      complaint: json['complaint'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'Pending',
      technicianName: json['technician_name'] as String?,
      attendedDate: json['attended_date'] != null
          ? DateTime.tryParse(json['attended_date'])
          : null,
      completedDate: json['completed_date'] != null
          ? DateTime.tryParse(json['completed_date'])
          : null,
      remark: json['remark'] as String?,
      stockNo: json['stock_no'] as String?,  // Handle new field
      pcNo: json['pc_no'] as String?,        // Handle new field
    );
  }

  // Method to convert a Complaint object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lab_name': labName,
      'lab_incharge': labIncharge,
      'complaint': complaint,
      'date': date.toIso8601String(),
      'status': status,
      'technician_name': technicianName,
      'attended_date': attendedDate?.toIso8601String(),
      'completed_date': completedDate?.toIso8601String(),
      'remark': remark,
      'stock_no': stockNo,  // Include new field
      'pc_no': pcNo,        // Include new field
    };
  }
}

// Function to parse JSON data into a List of Complaints
List<Complaint> complaintsFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Complaint>.from(jsonData.map((x) => Complaint.fromJson(x)));
}

// Function to convert a List of Complaints into JSON
String complaintsToJson(List<Complaint> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}
