import 'package:get/get.dart';

class Team {
  RxString name;
  final List<String> players;

  Team({required String name, required this.players}) : name = name.obs;

  Map<String, dynamic> toJson() => {
    'name': name.value,
    'players': players,
  };

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'],
      players: List<String>.from(json['players']),
    );
  }
}
