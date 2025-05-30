import 'dart:io';

import 'package:dio/dio.dart' as myDio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:love_quest/features/auth/domain/usecases/update_user.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  var job = "".obs;
  var country = "".obs;
  var address = "".obs;
  var email = "".obs;
  var gender = "".obs;
  var avatar = "".obs;
  final List<String> allInterests = [
    "Books", "Gym", "Cycling", "Traveling", "Cooking", "Movies", "Music",
    "Dancing", "Photography", "Gaming", "Hiking", "Writing", "Drawing",
    "Swimming", "Yoga", "Fishing", "Shopping", "Technology", "Art", "Sports"
  ];
  final AuthController authController = Get.find<AuthController>();
  final UpdateUserUseCase updateUserUseCase = Get.find<UpdateUserUseCase>();
  var selectedInterests = <String>[].obs;
  var photoUrls = <String>[].obs;
  final ImagePicker _picker = ImagePicker();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    job.value = authController.user.value.job ?? '';
    country.value = authController.user.value.country ?? '';
    address.value = authController.user.value.address ?? '';
    email.value = authController.user.value.email ?? '';
    gender.value = authController.user.value.gender ?? '';
    avatar.value = authController.user.value.avatar ?? '';
    selectedInterests.value = authController.user.value.interests ?? [];
    photoUrls.value = authController.user.value.profileImages ?? [];
  }
  Future<void> pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final url = await uploadToCloudinary(File(pickedFile.path));
      if (url != null) {
        photoUrls.add(url);
        await updateUserUseCase.call(UpdateParams(profileImages: photoUrls));
      }
    }
  }

  Future<String?> uploadToCloudinary(File file) async {
    final dio = myDio.Dio();
    final cloudName = 'dan6wlrgq';
    final uploadPreset = 'ml_default';

    final formData = myDio.FormData.fromMap({
      'file': await myDio.MultipartFile.fromFile(file.path),
      'upload_preset': uploadPreset,
    });

    final response = await dio.post(
      'https://api.cloudinary.com/v1_1/$cloudName/upload',
      data: formData,
    );

    if (response.statusCode == 200) {
      return response.data['secure_url'];
    } else {
      print('Upload failed: ${response.data}');
      return null;
    }
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  void updateInterests() async {
    await updateUserUseCase.call(UpdateParams(interests: selectedInterests.value));
  }

  void setAvatar(String imageUrl) {
    print('Avatar url: $imageUrl');
    avatar.value = imageUrl;
    updateUserUseCase.call(UpdateParams(avatar: imageUrl));
  }

  void updateField(String field, String newValue) async {
    switch (field) {
      case "Job":
        job.value = newValue;
        await updateUserUseCase.call(UpdateParams(job: job.value));
        break;
      case "Country":
        country.value = newValue;
        await updateUserUseCase.call(UpdateParams(country: country.value));
        break;
      case "Address":
        address.value = newValue;
        await updateUserUseCase.call(UpdateParams(address: address.value));
        break;
      case "Email":
        email.value = newValue;
        await updateUserUseCase.call(UpdateParams(email: email.value));
        break;
      case "Gender":
        gender.value = newValue;
        await updateUserUseCase.call(UpdateParams(gender: gender.value.toUpperCase()));
        break;
    }
  }
}