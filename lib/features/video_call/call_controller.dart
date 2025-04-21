import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'signaling.dart';

class CallController extends GetxController {
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  late Signaling signaling;

  final String userId = 'userA';
  final String peerId = 'userB';

  @override
  void onInit() {
    super.onInit();
    _initRenderersAndSignaling();
  }

  Future<void> _initRenderersAndSignaling() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    signaling = Signaling(userId, peerId);
    await signaling.init(); // Không cần truyền local/remote renderer nữa
    signaling.localRenderer.srcObject = localRenderer.srcObject;
    signaling.remoteRenderer.srcObject = remoteRenderer.srcObject;
  }

  void makeCall() {
    signaling.makeCall();
  }

  @override
  void onClose() {
    signaling.dispose();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.onClose();
  }
}
