import 'package:kickoff/app/data/models/team_model.dart';

class Standing {
  final Team team;
  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;
  int goalDifference = 0;
  int points = 0;

  Standing({required this.team});
}
