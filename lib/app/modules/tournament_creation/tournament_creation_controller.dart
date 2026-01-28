import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/routes/app_pages.dart';

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
    if (tournamentNameController.text.isNotEmpty) {
      Get.toNamed(
        Routes.PLAYER_INPUT,
        arguments: {
          'name': tournamentNameController.text,
          'type': tournamentType.value,
          'format': matchFormat.value,
        },
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter a tournament name.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    tournamentNameController.dispose();
    super.onClose();
  }
}
