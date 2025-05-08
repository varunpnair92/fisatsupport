import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:support/complaint_controller.dart';
import 'package:support/complaint_register.dart';
import 'package:support/complinat_history.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller once, not inside the Obx to avoid unnecessary reinitializations
    final controller = Get.put(ComplaintController());

    return Scaffold(
      body: Obx(() {
        // Now you can safely access controller.pageIndex
        final pageIndex = controller.pageIndex.value;
        return IndexedStack(
          index: pageIndex,
          children: [
            RegisterComplaintPage(),
            const ComplaintHistoryPage(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.pageIndex.value,
          onTap: (index) => controller.pageIndex.value = index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Register',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        );
      }),
    );
  }
}
