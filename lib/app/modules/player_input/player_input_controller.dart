import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/routes/app_pages.dart';

class PlayerInputController extends GetxController {
  final TextEditingController playerController = TextEditingController();
  final RxList<String> players = <String>[].obs;

  late String tournamentName;
  late String tournamentType;
  late String matchFormat;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    tournamentName = args['name'];
    tournamentType = args['type'];
    matchFormat = args['format'];
  }

  void addPlayer() {
    if (playerController.text.isNotEmpty) {
      players.add(playerController.text);
      playerController.clear();
    }
  }

  void removePlayer(int index) {
    players.removeAt(index);
  }

  void toTeamAssignment() {
    final minPlayers = int.parse(matchFormat.split('v')[0]) * 2;
    if (players.length < minPlayers) {
      Get.snackbar(
        'Error',
        'You need at least $minPlayers players for a $matchFormat match.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.toNamed(
        Routes.TEAM_ASSIGNMENT,
        arguments: {
          'name': tournamentName,
          'type': tournamentType,
          'format': matchFormat,
          'players': players.toList(),
        },
      );
    }
  }

  @override
  void onClose() {
    playerController.dispose();
    super.onClose();
  }
}
