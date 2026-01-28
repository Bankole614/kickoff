import 'package:get/get.dart';
import 'package:kickoff/app/modules/team_assignment/team_assignment_controller.dart';

class TeamAssignmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeamAssignmentController>(() => TeamAssignmentController());
  }
}
