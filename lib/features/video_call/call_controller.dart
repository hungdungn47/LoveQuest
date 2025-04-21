import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'signaling.dart';

class CallController extends GetxController {
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  late Signaling signaling;

  final userId = 'userA';
  final peerId = 'userB';

  @override
  void onInit() {
    super.onInit();
    initRenderers();
    signaling = Signaling(userId, peerId);
    signaling.init(localRenderer, remoteRenderer);
  }

  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  void makeCall() {
    signaling.makeCall();
  }

  @override
  void onClose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    signaling.dispose();
    super.onClose();
  }
}
