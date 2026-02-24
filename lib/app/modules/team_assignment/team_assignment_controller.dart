import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/data/models/team_model.dart';
import 'package:kickoff/app/data/models/tournament_model.dart';
import 'package:kickoff/app/data/services/storage_service.dart';
import 'package:kickoff/app/routes/app_pages.dart';
import 'package:uuid/uuid.dart';

class TeamAssignmentController extends GetxController {
  late String tournamentName;
  late String tournamentType;
  late String matchFormat;
  late List<String> players;

  final RxList<Team> teams = <Team>[].obs;
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    tournamentName = args['name'];
    tournamentType = args['type'];
    matchFormat = args['format'];
    players = args['players'];

    assignTeams();
  }

  void assignTeams() {
    players.shuffle();
    final teamSize = int.parse(matchFormat.split('v')[0]);
    final numTeams = (players.length / teamSize).ceil();

    for (var i = 0; i < numTeams; i++) {
      final teamPlayers = players.skip(i * teamSize).take(teamSize).toList();
      teams.add(Team(
        name: 'Team ${i + 1}',
        players: teamPlayers,
      ));
    }
  }

  void renameTeam(int teamIndex, String newName) {
    if (newName.isNotEmpty) {
      teams[teamIndex].name.value = newName;
    }
  }

  void showRenameDialog(int teamIndex) {
    final TextEditingController renameController = TextEditingController();
    Get.defaultDialog(
      title: 'Rename Team',
      content: TextField(
        controller: renameController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'New Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            renameTeam(teamIndex, renameController.text);
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void startTournament() {
    final tournament = Tournament(
      id: const Uuid().v4(),
      name: tournamentName,
      type: tournamentType,
      format: matchFormat,
      teams: teams,
    );

    _storageService.saveTournament(tournament);

    Get.toNamed(Routes.TOURNAMENT_VIEW, arguments: tournament);
  }
}
