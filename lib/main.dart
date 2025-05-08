import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:support/comnplaint_details.dart';
import 'package:support/complaint_controller.dart';
import 'package:support/complinat_history.dart';
import 'home_page.dart';
import 'complaint_register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ComplaintController());  
  runApp(const ComplaintApp());
}

class ComplaintApp extends StatelessWidget {
  const ComplaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Complaint Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/register', page: () => RegisterComplaintPage()),
        GetPage(name: '/history', page: () => const ComplaintHistoryPage()),
        GetPage(name: '/details', page: () =>  ComplaintDetailPage(complaintId: Get.arguments)),
      ],
      initialRoute: '/',
    );
  }
}
