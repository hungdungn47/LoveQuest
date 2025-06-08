import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'schedule_controller.dart';

class ScheduleOfferScreen extends StatelessWidget {

  ScheduleOfferScreen();

  final ScheduleController scheduleController = Get.find<ScheduleController>();

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
      initialDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    scheduleController.selectedDateTime.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set up a schedule', style: TextStyle(
        color: Colors.white
      ),), 
        leading: IconButton(onPressed: () => Get.back(), icon: Icon(CupertinoIcons.back, color: Colors.white,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final selected = scheduleController.selectedDateTime.value;
          final formattedTime = selected != null
              ? DateFormat('HH:mm dd/MM/yyyy').format(selected)
              : "You haven't chosen time";

          return Column(
            children: [
              Text("Scheduled time: $formattedTime", style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),),
              ElevatedButton(
                onPressed: _pickDateTime,
                child: Text("Select time"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: selected != null ? scheduleController.sendOffer : null,
                child: Text("Send offer"),
              ),
              SizedBox(height: 16),
              if (scheduleController.isWaiting.value) CircularProgressIndicator(),
              if (scheduleController.message.value != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    scheduleController.message.value!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
