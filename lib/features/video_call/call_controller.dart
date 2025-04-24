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
    try {
      print('Initializing signaling...');
      signaling = Signaling(userId, peerId);
      await signaling.init(); // Không cần renderer nữa
      print('Signaling initialized successfully');
    } catch (e) {
      print('Error initializing signaling: $e');
    }
  }

  void makeCall() {
    try {
      print('Making call...');
      signaling.makeCall();
      print('Call initiated');
    } catch (e) {
      print('Error making call: $e');
    }
  }

  @override
  void onClose() {
    signaling.dispose();
    super.onClose();
  }
}
