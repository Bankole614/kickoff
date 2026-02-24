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

  Map<String, dynamic> toJson() => {
    'homeTeam': homeTeam.toJson(),
    'awayTeam': awayTeam.toJson(),
    'homeScore': homeScore,
    'awayScore': awayScore,
    'completed': completed,
  };

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      homeTeam: Team.fromJson(json['homeTeam']),
      awayTeam: Team.fromJson(json['awayTeam']),
      homeScore: json['homeScore'],
      awayScore: json['awayScore'],
      completed: json['completed'],
    );
  }
}
