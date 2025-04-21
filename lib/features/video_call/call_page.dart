import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'call_controller.dart';

class CallPage extends GetView<CallController> {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebRTC Call")),
      body: Stack(
        children: [
          RTCVideoView(controller.remoteRenderer),
          Positioned(
            right: 10,
            bottom: 10,
            width: 100,
            height: 150,
            child: RTCVideoView(controller.localRenderer, mirror: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.makeCall,
        child: const Icon(Icons.call),
      ),
    );
  }
}
