import 'package:get/get.dart';
import 'package:kickoff/app/data/models/tournament_model.dart';
import 'package:kickoff/app/data/services/storage_service.dart';
import 'package:kickoff/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final RxList<Tournament> tournaments = <Tournament>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTournaments();
    _storageService.listenToTournaments(loadTournaments);
  }

  void loadTournaments() {
    // getTournaments returns a new list, so assignAll updates the observable correctly
    tournaments.assignAll(_storageService.getTournaments());
  }

  void deleteTournament(String id) {
    _storageService.deleteTournament(id);
    // loadTournaments will be called automatically by the listener
  }

  void openTournament(Tournament tournament) {
    Get.toNamed(Routes.TOURNAMENT_VIEW, arguments: tournament);
  }
}
