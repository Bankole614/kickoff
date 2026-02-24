import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    for (var i = 0; i < teams.length; i++) {
      for (var j = i + 1; j < teams.length; j++) {
        matches.add(Match(homeTeam: teams[i], awayTeam: teams[j]));
      }
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

    Get.defaultDialog(
      title: 'Enter Score',
      content: Column(
        children: [
          TextField(
            controller: homeScoreController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: match.homeTeam.name.value),
          ),
          TextField(
            controller: awayScoreController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: match.awayTeam.name.value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
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
          child: const Text('Save'),
        ),
      ],
    );
  }
}
