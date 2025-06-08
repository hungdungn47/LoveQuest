import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:love_quest/features/schedule/domain/data/schedule_api_service.dart';
import '../domain/models/game_schedule.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ScheduleController extends GetxController {
  final RxList<GameSchedule> schedules = <GameSchedule>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final RxString selectedGameType = ''.obs;
  final Logger logger = Logger();
  @override
  void onInit() {
    super.onInit();
    loadSchedules();
    _connectSocket();
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }

  Future<void> loadSchedules() async {
    try {
      isLoading.value = true;
      final ScheduleApiService apiService = Get.find<ScheduleApiService>();
      final res = await apiService.getSchedules();
      logger.i(res);
      res.map((item) {
        logger.i(item);
      });
      schedules.value = res;
      logger.i("Schedules length: ${schedules.length}");

    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  final GlobalController globalController = Get.find<GlobalController>();
  final SocketService _socketService = SocketService();

  var selectedDateTime = Rxn<DateTime>();
  var isWaiting = false.obs;
  var message = RxnString();

  void _connectSocket() {

    _socketService.listenToMessages('scheduleOffer', (data) {
      final DateTime time = DateFormat('HH:mm dd/MM/yyyy').parse(data['scheduleAt']);
      final String msg = data['message'];
      selectedDateTime.value = time;
      Get.dialog(
        AlertDialog(
          title: Text("Schedule request"),
          content: Text("$msg\nLúc: ${DateFormat('HH:mm dd/MM').format(time)}"),
          actions: [
            TextButton(
              onPressed: () {
                _respondToOffer(false, null);
                Get.back();
              },
              child: Text("Decline"),
            ),
            ElevatedButton(
              onPressed: () {
                _respondToOffer(true, time);
                Get.back();
              },
              child: Text("Đồng ý"),
            ),
          ],
        ),
      );
    });

    _socketService.listenToMessages('scheduleResponse', (data) {
      isWaiting.value = false;
      message.value = data['message'];
    });
  }

  void sendOffer() {
    if (selectedDateTime.value == null) return;

    _socketService.sendMessage('scheduleOffer', {
      'roomId': globalController.roomId.value,
      'scheduleAt':  DateFormat('HH:mm dd/MM/yyyy').format(selectedDateTime.value!),
      'message':
      'Let\'s play at ${DateFormat('HH:mm dd/MM').format(selectedDateTime.value!)}!',
    });

    isWaiting.value = true;
  }

  void _respondToOffer(bool accepted, DateTime? time) {
    if(accepted) {
      message.value = 'The schedule has been confirmed. Looking forward to seeing you at the selected time!';
    } else {
      message.value = 'You have declined the invitation';
    }
    _socketService.sendMessage('scheduleResponse', {
      'roomId': globalController.roomId.value,
      'accepted': accepted,
      'scheduleAt':  DateFormat('HH:mm dd/MM/yyyy').format(selectedDateTime.value!),
    });
  }
}
