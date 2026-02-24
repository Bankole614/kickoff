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
  }

  void loadTournaments() {
    tournaments.assignAll(_storageService.getTournaments());
  }

  void deleteTournament(String id) {
    _storageService.deleteTournament(id);
    loadTournaments();
  }

  void openTournament(Tournament tournament) {
    Get.toNamed(Routes.TOURNAMENT_VIEW, arguments: tournament);
  }
  
  // Refresh the list when returning to this screen
  @override
  void onReady() {
    super.onReady();
    loadTournaments();
  }
}
