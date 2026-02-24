import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';
import 'package:kickoff/app/data/models/match_model.dart';
import 'package:kickoff/app/data/models/standing_model.dart';
import 'package:kickoff/app/data/models/team_model.dart';
import 'package:kickoff/app/data/models/tournament_model.dart';
import 'package:kickoff/app/data/services/storage_service.dart';

class TournamentViewController extends GetxController {
  late Tournament tournament;
  final StorageService _storageService = Get.find<StorageService>();

  late String tournamentName;
  late String tournamentType;
  late String matchFormat;
  late List<Team> teams;

  final RxList<Match> matches = <Match>[].obs;
  final RxList<Standing> standings = <Standing>[].obs;

  @override
  void onInit() {
    super.onInit();
    tournament = Get.arguments as Tournament;
    
    tournamentName = tournament.name;
    tournamentType = tournament.type;
    matchFormat = tournament.format;
    teams = tournament.teams;

    if (tournament.matches.isNotEmpty) {
      matches.assignAll(tournament.matches);
    } else if (tournamentType == 'League') {
      generateLeagueFixtures();
    }

    if (tournament.standings.isNotEmpty) {
      standings.assignAll(tournament.standings);
    } else if (tournamentType == 'League') {
      initializeStandings();
    }
  }

  void generateLeagueFixtures() {
    // Initial fixture: Team 1 vs Team 2
    if (teams.length >= 2) {
      matches.add(Match(homeTeam: teams[0], awayTeam: teams[1]));
    }
    _saveTournamentState();
  }

  void initializeStandings() {
    for (var team in teams) {
      standings.add(Standing(team: team));
    }
    _saveTournamentState();
  }

  void updateStandings(Match match) {
    // Logic needs to find the correct standing based on team name, 
    // because team objects might be different instances if loaded from JSON
    final homeStanding = standings.firstWhere((s) => s.team.name.value == match.homeTeam.name.value);
    final awayStanding = standings.firstWhere((s) => s.team.name.value == match.awayTeam.name.value);

    homeStanding.played++;
    awayStanding.played++;
    homeStanding.goalsFor += match.homeScore!;
    awayStanding.goalsFor += match.awayScore!;
    homeStanding.goalsAgainst += match.awayScore!;
    awayStanding.goalsAgainst += match.homeScore!;
    homeStanding.goalDifference = homeStanding.goalsFor - homeStanding.goalsAgainst;
    awayStanding.goalDifference = awayStanding.goalsFor - awayStanding.goalsAgainst;

    if (match.homeScore! > match.awayScore!) {
      homeStanding.won++;
      homeStanding.points += 3;
      awayStanding.lost++;
    } else if (match.homeScore! < match.awayScore!) {
      awayStanding.won++;
      awayStanding.points += 3;
      homeStanding.lost++;
    } else {
      homeStanding.drawn++;
      awayStanding.drawn++;
      homeStanding.points++;
      awayStanding.points++;
    }

    standings.sort((a, b) {
      if (b.points != a.points) {
        return b.points.compareTo(a.points);
      } else if (b.goalDifference != a.goalDifference) {
        return b.goalDifference.compareTo(a.goalDifference);
      } else {
        return b.goalsFor.compareTo(a.goalsFor);
      }
    });
    standings.refresh();
    _saveTournamentState();
  }

  void _saveTournamentState() {
    // Create a new tournament object with updated matches/standings to save
    final updatedTournament = Tournament(
      id: tournament.id,
      name: tournament.name,
      type: tournament.type,
      format: tournament.format,
      teams: tournament.teams,
      matches: matches.toList(),
      standings: standings.toList(),
      isCompleted: tournament.isCompleted,
      createdDate: tournament.createdDate,
    );
    _storageService.updateTournament(updatedTournament);
  }

  void showScoreEntryDialog(Match match) {
    final TextEditingController homeScoreController = TextEditingController();
    final TextEditingController awayScoreController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter Match Result',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTeamScoreInput(
                    match.homeTeam,
                    homeScoreController,
                    true,
                  ),
                  const Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  _buildTeamScoreInput(
                    match.awayTeam,
                    awayScoreController,
                    false,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (homeScoreController.text.isNotEmpty &&
                            awayScoreController.text.isNotEmpty) {
                          match.homeScore = int.parse(homeScoreController.text);
                          match.awayScore = int.parse(awayScoreController.text);
                          match.completed = true;
                          updateStandings(match);
                          matches.refresh();
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Save Result'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamScoreInput(Team team, TextEditingController controller, bool isHome) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            team.name.value.isNotEmpty ? team.name.value[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          team.name.value,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ),
      ],
    );
  }

  void showAddMatchDialog() {
    Rx<Team?> selectedHomeTeam = Rx<Team?>(null);
    Rx<Team?> selectedAwayTeam = Rx<Team?>(null);

    if (teams.isNotEmpty) selectedHomeTeam.value = teams[0];
    if (teams.length > 1) selectedAwayTeam.value = teams[1];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Schedule New Match',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Obx(() => DropdownButtonFormField<Team>(
                value: selectedHomeTeam.value,
                decoration: InputDecoration(
                  labelText: 'Home Team',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.home_outlined),
                ),
                items: teams.map((team) {
                  return DropdownMenuItem(
                    value: team,
                    child: Text(team.name.value),
                  );
                }).toList(),
                onChanged: (val) => selectedHomeTeam.value = val,
              )),
              const SizedBox(height: 16),
              const Center(
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.background,
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<Team>(
                value: selectedAwayTeam.value,
                decoration: InputDecoration(
                  labelText: 'Away Team',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.flight_outlined),
                ),
                items: teams.map((team) {
                  return DropdownMenuItem(
                    value: team,
                    child: Text(team.name.value),
                  );
                }).toList(),
                onChanged: (val) => selectedAwayTeam.value = val,
              )),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (selectedHomeTeam.value != null && 
                      selectedAwayTeam.value != null && 
                      selectedHomeTeam.value != selectedAwayTeam.value) {
                    
                    matches.add(Match(
                      homeTeam: selectedHomeTeam.value!, 
                      awayTeam: selectedAwayTeam.value!
                    ));
                    _saveTournamentState();
                    Get.back();
                    Get.snackbar('Success', 'Match scheduled successfully', 
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white);
                  } else {
                    Get.snackbar('Error', 'Please select two different teams',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Schedule Match',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
