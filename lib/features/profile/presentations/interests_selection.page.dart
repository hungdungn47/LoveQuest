import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile.controller.dart';

class SelectInterestPage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Interests")),
      body: ListView.builder(
        itemCount: controller.allInterests.length,
        itemBuilder: (context, index) {
          final interest = controller.allInterests[index];
          return Obx(() => CheckboxListTile(
            title: Text(interest),
            value: controller.selectedInterests.contains(interest),
            onChanged: (_) => controller.toggleInterest(interest),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.back(),
        child: Icon(Icons.check),
      ),
    );
  }
}
