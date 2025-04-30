import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'call_controller.dart';

class CallPage extends GetView<CallController> {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Audio Call")),
      body: const Center(
        child: Text(
          "Calling...",
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "call",
            onPressed: controller.makeCall,
            child: const Icon(Icons.call),
          ),
          const SizedBox(height: 16),
          Obx(() => FloatingActionButton(
            heroTag: "mic",
            onPressed: controller.toggleMic,
            backgroundColor:
            controller.isMicEnabled.value ? Colors.green : Colors.red,
            child: Icon(controller.isMicEnabled.value
                ? Icons.mic
                : Icons.mic_off),
          )),
        ],
      ),
    );
  }
}