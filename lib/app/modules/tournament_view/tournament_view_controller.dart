import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/data/models/match_model.dart';
import 'package:kickoff/app/data/models/standing_model.dart';
import 'package:kickoff/app/data/models/team_model.dart';

class TournamentViewController extends GetxController {
  late String tournamentName;
  late String tournamentType;
  late String matchFormat;
  late List<Team> teams;

  final RxList<Match> matches = <Match>[].obs;
  final RxList<Standing> standings = <Standing>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    tournamentName = args['name'];
    tournamentType = args['type'];
    matchFormat = args['format'];
    teams = args['teams'];

    if (tournamentType == 'League') {
      generateLeagueFixtures();
      initializeStandings();
    }
  }

  void generateLeagueFixtures() {
    for (var i = 0; i < teams.length; i++) {
      for (var j = i + 1; j < teams.length; j++) {
        matches.add(Match(homeTeam: teams[i], awayTeam: teams[j]));
      }
    }
  }

  void initializeStandings() {
    for (var team in teams) {
      standings.add(Standing(team: team));
    }
  }

  void updateStandings(Match match) {
    final homeStanding = standings.firstWhere((s) => s.team == match.homeTeam);
    final awayStanding = standings.firstWhere((s) => s.team == match.awayTeam);

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
