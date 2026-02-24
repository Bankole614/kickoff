import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class TournamentCreationController extends GetxController {
  final TextEditingController tournamentNameController = TextEditingController();
  final RxString tournamentType = 'League'.obs;
  final RxString matchFormat = '5v5'.obs;

  void onTournamentTypeChanged(String? newValue) {
    if (newValue != null) {
      tournamentType.value = newValue;
    }
  }

  void onMatchFormatChanged(String? newValue) {
    if (newValue != null) {
      matchFormat.value = newValue;
    }
  }

  void toPlayerInput() {
    String name = tournamentNameController.text.trim();
    
    if (name.isEmpty) {
      // Set default name with current date, e.g., "Tournament Jan 28"
      final dateStr = DateFormat('MMM d').format(DateTime.now());
      name = 'Tournament $dateStr';
    }

    Get.toNamed(
      Routes.PLAYER_INPUT,
      arguments: {
        'name': name,
        'type': tournamentType.value,
        'format': matchFormat.value,
      },
    );
  }

  @override
  void onClose() {
    tournamentNameController.dispose();
    super.onClose();
  }
}
