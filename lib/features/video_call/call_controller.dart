import 'package:get/get.dart';
import 'signaling.dart';

class CallController extends GetxController {
  late Signaling signaling;

  final String userId = 'userB';
  final String peerId = 'userA';

  final RxBool isMicEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initSignaling();
  }

  void toggleMic() {
    final audioTracks = signaling.localStream.getAudioTracks();
    if (audioTracks.isNotEmpty) {
      final enabled = isMicEnabled.value;
      audioTracks.forEach((track) {
        track.enabled = !enabled;
      });
      isMicEnabled.value = !enabled;
    }
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
