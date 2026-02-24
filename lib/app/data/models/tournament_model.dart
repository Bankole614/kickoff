import 'package:kickoff/app/data/models/match_model.dart';
import 'package:kickoff/app/data/models/standing_model.dart';
import 'package:kickoff/app/data/models/team_model.dart';

class Tournament {
  final String id;
  final String name;
  final String type;
  final String format;
  final List<Team> teams;
  final List<Match> matches;
  final List<Standing> standings;
  bool isCompleted;
  final DateTime createdDate;

  Tournament({
    required this.id,
    required this.name,
    required this.type,
    required this.format,
    required this.teams,
    this.matches = const [],
    this.standings = const [],
    this.isCompleted = false,
    DateTime? createdDate,
  }) : createdDate = createdDate ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'format': format,
    'teams': teams.map((team) => team.toJson()).toList(),
    'matches': matches.map((match) => match.toJson()).toList(),
    'standings': standings.map((standing) => standing.toJson()).toList(),
    'isCompleted': isCompleted,
    'createdDate': createdDate.toIso8601String(),
  };

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      format: json['format'],
      teams: (json['teams'] as List).map((i) => Team.fromJson(i)).toList(),
      matches: (json['matches'] as List).map((i) => Match.fromJson(i)).toList(),
      standings:
          (json['standings'] as List).map((i) => Standing.fromJson(i)).toList(),
      isCompleted: json['isCompleted'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}
