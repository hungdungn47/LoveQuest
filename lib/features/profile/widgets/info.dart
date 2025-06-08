import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';
import '../presentations/edit_info.page.dart';
import '../presentations/profile.controller.dart';
import 'info_item.dart';
import 'package:get/get.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  void _navigateToEdit(BuildContext context, String title, RxString valueRx, ProfileController controller) async {
    final result = await Get.to(() => EditFieldPage(title: title, currentValue: valueRx.value));
    if (result != null && result is String && result.trim().isNotEmpty) {
      controller.updateField(title, result.trim());
    }
  }


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: 12, horizontal: 18),
            child: Text(
              "Basic Info",
              style: Styles.bigTextW800,
            )),
        Obx(() => InfoItem(
          icon: Icons.work_sharp,
          title: "Job",
          value: controller.job.value,
          onTap: () => _navigateToEdit(context, "Job", controller.job, controller),
        )),
        Obx(() => InfoItem(
          icon: Icons.public_outlined,
          title: "Country",
          value: controller.country.value,
          onTap: () => _navigateToEdit(context, "Country", controller.country, controller),
        )),
        Obx(() => InfoItem(
          icon: Icons.location_on_outlined,
          title: "Address",
          value: controller.address.value,
          onTap: () => _navigateToEdit(context, "Address", controller.address, controller),
        )),
        Obx(() => InfoItem(
          icon: Icons.email_outlined,
          title: "Email",
          value: controller.email.value,
          onTap: () => _navigateToEdit(context, "Email", controller.email, controller),
        )),
        Obx(() => InfoItem(
          icon: Icons.female_outlined,
          title: "Gender",
          value: controller.gender.value,
          onTap: () => _navigateToEdit(context, "Gender", controller.gender, controller),
        )),
        SizedBox(height: 32,)
      ],
    );
  }
}
//
// Widget _buildInput(String title, TextEditingController textController, RxString valueRx) {
//   switch (title) {
//     case "Gender":
//       return DropdownButtonFormField<String>(
//         value: valueRx.value,
//         items: ["Male", "Female", "Other"]
//             .map((g) => DropdownMenuItem(value: g, child: Text(g)))
//             .toList(),
//         onChanged: (val) {
//           if (val != null) textController.text = val;
//         },
//         decoration: InputDecoration(labelText: "Select gender"),
//       );
//     case "Email":
//       return TextField(
//         controller: textController,
//         keyboardType: TextInputType.emailAddress,
//         decoration: InputDecoration(labelText: "Enter email"),
//       );
//     default:
//       return TextField(
//         controller: textController,
//         decoration: InputDecoration(labelText: "Edit $title"),
//       );
//   }
// }
//
