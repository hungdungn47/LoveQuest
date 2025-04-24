import 'package:get/get.dart';
import 'signaling.dart';

class CallController extends GetxController {
  late Signaling signaling;

  final String userId = 'userA';
  final String peerId = 'userB';

  @override
  void onInit() {
    super.onInit();
    _initSignaling();
  }

  Future<void> _initSignaling() async {
    signaling = Signaling(userId, peerId);
    await signaling.init(); // Không cần renderer nữa
  }

  void makeCall() {
    signaling.makeCall();
  }

  @override
  void onClose() {
    signaling.dispose();
    super.onClose();
  }
}
