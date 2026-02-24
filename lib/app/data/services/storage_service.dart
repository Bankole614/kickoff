import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kickoff/app/data/models/tournament_model.dart';

class StorageService extends GetxService {
  final _box = GetStorage();

  Future<StorageService> init() async {
    return this;
  }

  void saveTournament(Tournament tournament) {
    List<dynamic> storedTournaments = _box.read('tournaments') ?? [];
    storedTournaments.add(tournament.toJson());
    _box.write('tournaments', storedTournaments);
  }

  void updateTournament(Tournament tournament) {
    List<dynamic> storedTournaments = _box.read('tournaments') ?? [];
    int index = storedTournaments.indexWhere((t) => t['id'] == tournament.id);
    if (index != -1) {
      storedTournaments[index] = tournament.toJson();
      _box.write('tournaments', storedTournaments);
    }
  }

  List<Tournament> getTournaments() {
    List<dynamic> storedTournaments = _box.read('tournaments') ?? [];
    return storedTournaments
        .map((t) => Tournament.fromJson(t))
        .toList();
  }

  void deleteTournament(String id) {
    List<dynamic> storedTournaments = _box.read('tournaments') ?? [];
    storedTournaments.removeWhere((t) => t['id'] == id);
    _box.write('tournaments', storedTournaments);
  }

  void listenToTournaments(VoidCallback callback) {
    _box.listenKey('tournaments', (value) {
      callback();
    });
  }
}
