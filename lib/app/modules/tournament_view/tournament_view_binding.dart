import 'package:get/get.dart';
import 'package:kickoff/app/modules/tournament_view/tournament_view_controller.dart';

class TournamentViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TournamentViewController>(() => TournamentViewController());
  }
}
