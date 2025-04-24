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
      floatingActionButton: FloatingActionButton(
        onPressed: controller.makeCall,
        child: const Icon(Icons.call),
      ),
    );
  }
}
