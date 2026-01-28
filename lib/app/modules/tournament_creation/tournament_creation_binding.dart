import 'package:get/get.dart';
import 'package:kickoff/app/modules/tournament_creation/tournament_creation_controller.dart';

class TournamentCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TournamentCreationController>(() => TournamentCreationController());
  }
}
