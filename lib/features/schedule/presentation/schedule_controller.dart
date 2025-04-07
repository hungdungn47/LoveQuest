import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../domain/models/game_schedule.dart';

class ScheduleController extends GetxController {
  final RxList<GameSchedule> schedules = <GameSchedule>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final RxString selectedGameType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSchedules();
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
      // TODO: Implement API call to load schedules
      // For now, using sample data
      schedules.value = [
        GameSchedule(
          id: '1',
          userId: 'current_user',
          partnerId: 'partner1',
          partnerName: 'Sarah Johnson',
          partnerAvatar: null,
          scheduledTime: DateTime.now().add(const Duration(days: 1)),
          gameType: 'Lightning Quiz',
          status: 'pending',
          createdAt: DateTime.now(),
        ),
        GameSchedule(
          id: '2',
          userId: 'current_user',
          partnerId: 'partner2',
          partnerName: 'Michael Chen',
          partnerAvatar: null,
          scheduledTime: DateTime.now().add(const Duration(days: 2)),
          gameType: 'Lightning Quiz',
          status: 'accepted',
          createdAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSchedule(String partnerId, String partnerName,
      DateTime scheduledTime, String gameType) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call to create schedule
      final newSchedule = GameSchedule(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        partnerId: partnerId,
        partnerName: partnerName,
        scheduledTime: scheduledTime,
        gameType: gameType,
        status: 'pending',
        createdAt: DateTime.now(),
      );
      schedules.add(newSchedule);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateScheduleStatus(String scheduleId, String status) async {
    try {
      isLoading.value = true;
      // TODO: Implement API call to update status
      final index = schedules.indexWhere((s) => s.id == scheduleId);
      if (index != -1) {
        final schedule = schedules[index];
        schedules[index] = GameSchedule(
          id: schedule.id,
          userId: schedule.userId,
          partnerId: schedule.partnerId,
          partnerName: schedule.partnerName,
          partnerAvatar: schedule.partnerAvatar,
          scheduledTime: schedule.scheduledTime,
          gameType: schedule.gameType,
          status: status,
          createdAt: schedule.createdAt,
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelSchedule(String scheduleId) async {
    await updateScheduleStatus(scheduleId, 'cancelled');
  }

  Future<void> acceptSchedule(String scheduleId) async {
    await updateScheduleStatus(scheduleId, 'accepted');
  }

  Future<void> rejectSchedule(String scheduleId) async {
    await updateScheduleStatus(scheduleId, 'rejected');
  }
}
