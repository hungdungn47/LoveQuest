import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:love_quest/features/schedule/domain/models/game_schedule.dart';
import 'schedule_controller.dart';

class ScheduleScreen extends GetView<ScheduleController> {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Schedules', style: TextStyle(
          color: Colors.white
        ),),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () => _showCreateScheduleDialog(context),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.error.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.loadSchedules,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.schedules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No game schedules yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.loadSchedules();
                    },
                    child: const Text('Reload schedules'),
                  ),
                ],
              ),
            );
          }

          return Container(
            height: 500,
            width: 500,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) =>
                  _buildScheduleCard(controller.schedules[index]),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScheduleCard(GameSchedule schedule) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.users.first,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(schedule.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${DateFormat('dd/MM/yyyy').format(schedule.scheduleAt!)}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${DateFormat('HH:mm').format(schedule.scheduleAt!)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            if (schedule.status == 'pending' ||
                schedule.status == 'accepted') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to game screen
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Join Game'),
                    ),
                  ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'accepted':
        color = Colors.green;
        label = 'Accepted';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rejected';
        break;
      case 'cancelled':
        color = Colors.grey;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // void _showCreateScheduleDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Create Game Schedule'),
  //       content: SizedBox(
  //         width: double.maxFinite,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextField(
  //                 controller: controller.dateController,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Date',
  //                   hintText: 'Select date',
  //                   prefixIcon: Icon(Icons.calendar_today),
  //                 ),
  //                 readOnly: true,
  //                 onTap: () async {
  //                   final date = await showDatePicker(
  //                     context: context,
  //                     initialDate: DateTime.now(),
  //                     firstDate: DateTime.now(),
  //                     lastDate: DateTime.now().add(const Duration(days: 30)),
  //                   );
  //                   if (date != null) {
  //                     controller.dateController.text =
  //                         '${date.day}/${date.month}/${date.year}';
  //                   }
  //                 },
  //               ),
  //               const SizedBox(height: 16),
  //               TextField(
  //                 controller: controller.timeController,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Time',
  //                   hintText: 'Select time',
  //                   prefixIcon: Icon(Icons.access_time),
  //                 ),
  //                 readOnly: true,
  //                 onTap: () async {
  //                   final time = await showTimePicker(
  //                     context: context,
  //                     initialTime: TimeOfDay.now(),
  //                   );
  //                   if (time != null) {
  //                     controller.timeController.text =
  //                         '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  //                   }
  //                 },
  //               ),
  //               const SizedBox(height: 16),
  //               DropdownButtonFormField<String>(
  //                 value: controller.selectedGameType.value.isEmpty
  //                     ? null
  //                     : controller.selectedGameType.value,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Game Type',
  //                   hintText: 'Select game type',
  //                   prefixIcon: Icon(Icons.games),
  //                 ),
  //                 items: const [
  //                   DropdownMenuItem(
  //                     value: 'Lightning Quiz',
  //                     child: Text('Lightning Quiz'),
  //                   ),
  //                   DropdownMenuItem(
  //                     value: 'Word Chain',
  //                     child: Text('Word Chain'),
  //                   ),
  //                   DropdownMenuItem(
  //                     value: 'Memory Match',
  //                     child: Text('Memory Match'),
  //                   ),
  //                 ],
  //                 onChanged: (value) {
  //                   controller.selectedGameType.value = value ?? '';
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Parse date and time from controllers
  //             final dateParts = controller.dateController.text.split('/');
  //             final timeParts = controller.timeController.text.split(':');
  //
  //             if (dateParts.length == 3 && timeParts.length == 2) {
  //               final scheduledTime = DateTime(
  //                 int.parse(dateParts[2]), // year
  //                 int.parse(dateParts[1]), // month
  //                 int.parse(dateParts[0]), // day
  //                 int.parse(timeParts[0]), // hour
  //                 int.parse(timeParts[1]), // minute
  //               );
  //             }
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Create'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
