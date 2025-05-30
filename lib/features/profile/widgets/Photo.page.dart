import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/features/profile/presentations/profile.controller.dart';
import 'package:love_quest/features/profile/widgets/photo.dart';
import '../../../core/config/theme.dart';

// class PhotoPage extends StatelessWidget {
//   final ProfileController controller = Get.find<ProfileController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Photos", style: Styles.bigTextW800),
//           Center(
//             child: Obx(() => Wrap(
//               alignment: WrapAlignment.center,
//               children: [
//                 ...controller.photoUrls.map((url) => PhotoItem(imageUrl: url)).toList(),
//                 GestureDetector(
//                   onTap: controller.pickAndUploadImage,
//                   child: PhotoItem(imageUrl: "", isAddButton: true),
//                 )
//               ],
//             )),
//           )
//         ],
//       ),
//     );
//   }
// }
class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Photos", style: Styles.bigTextW800),
          const SizedBox(height: 12),
          Obx(() => Wrap(
            alignment: WrapAlignment.center,
            children: [
              // Nút Add
              GestureDetector(
                onTap: controller.pickAndUploadImage,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: const Icon(Icons.add_a_photo, size: 40),
                ),
              ),
              // Các ảnh hiện có
              ...controller.photoUrls.map((img) {
                final isSelected = img == controller.avatar.value;
                print('Image URL in Photo page: $img');
                return PhotoItem(
                  imageUrl: img,
                  isSelected: isSelected,
                  onSelect: () => controller.setAvatar(img),
                );
              }).toList(),
            ],
          )),
        ],
      ),
    );
  }
}
