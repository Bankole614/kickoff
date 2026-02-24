import 'package:kickoff/app/data/models/team_model.dart';

class Standing {
  final Team team;
  int played;
  int won;
  int drawn;
  int lost;
  int goalsFor;
  int goalsAgainst;
  int goalDifference;
  int points;

  Standing({
    required this.team,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.goalDifference = 0,
    this.points = 0,
  });

  Map<String, dynamic> toJson() => {
    'team': team.toJson(),
    'played': played,
    'won': won,
    'drawn': drawn,
    'lost': lost,
    'goalsFor': goalsFor,
    'goalsAgainst': goalsAgainst,
    'goalDifference': goalDifference,
    'points': points,
  };

  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      team: Team.fromJson(json['team']),
      played: json['played'],
      won: json['won'],
      drawn: json['drawn'],
      lost: json['lost'],
      goalsFor: json['goalsFor'],
      goalsAgainst: json['goalsAgainst'],
      goalDifference: json['goalDifference'],
      points: json['points'],
    );
  }
}
