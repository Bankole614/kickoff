import 'package:get/get.dart';

class Team {
  RxString name;
  final List<String> players;

  Team({required String name, required this.players}) : name = name.obs;
}
