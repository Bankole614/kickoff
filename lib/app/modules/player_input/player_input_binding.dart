import 'package:get/get.dart';
import 'package:kickoff/app/modules/player_input/player_input_controller.dart';

class PlayerInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerInputController>(() => PlayerInputController());
  }
}
