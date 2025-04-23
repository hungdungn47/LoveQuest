import 'package:get/get.dart';

class ProfileController extends GetxController {
  var job = "Software Engineer".obs;
  var country = "Vietnam".obs;
  var address = "Thai Binh, Vietnam".obs;
  var email = "hungdungn47@gmail.com".obs;
  var gender = "Male".obs;
  final List<String> allInterests = [
    "Books", "Gym", "Cycling", "Traveling", "Cooking", "Movies", "Music",
    "Dancing", "Photography", "Gaming", "Hiking", "Writing", "Drawing",
    "Swimming", "Yoga", "Fishing", "Shopping", "Technology", "Art", "Sports"
  ];

  var selectedInterests = <String>[].obs;

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  void updateField(String field, String newValue) {
    switch (field) {
      case "Job":
        job.value = newValue;
        break;
      case "Country":
        country.value = newValue;
        break;
      case "Address":
        address.value = newValue;
        break;
      case "Email":
        email.value = newValue;
        break;
      case "Gender":
        gender.value = newValue;
        break;
    }
  }
}