import 'package:kickoff/app/data/models/team_model.dart';

class Match {
  final Team homeTeam;
  final Team awayTeam;
  int? homeScore;
  int? awayScore;
  bool completed;

  Match({
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    this.completed = false,
  });
}
