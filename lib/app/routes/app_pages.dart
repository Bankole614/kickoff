import 'package:get/get.dart';
import 'package:kickoff/app/modules/home/home_binding.dart';
import 'package:kickoff/app/modules/home/home_screen.dart';
import 'package:kickoff/app/modules/onboarding/onboarding_binding.dart';
import 'package:kickoff/app/modules/onboarding/onboarding_screen.dart';
import 'package:kickoff/app/modules/player_input/player_input_binding.dart';
import 'package:kickoff/app/modules/player_input/player_input_screen.dart';
import 'package:kickoff/app/modules/splash/splash_screen.dart';
import 'package:kickoff/app/modules/team_assignment/team_assignment_binding.dart';
import 'package:kickoff/app/modules/team_assignment/team_assignment_screen.dart';
import 'package:kickoff/app/modules/tournament_creation/tournament_creation_binding.dart';
import 'package:kickoff/app/modules/tournament_creation/tournament_creation_screen.dart';
import 'package:kickoff/app/modules/tournament_view/tournament_view_binding.dart';
import 'package:kickoff/app/modules/tournament_view/tournament_view_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TOURNAMENT_CREATION,
      page: () => const TournamentCreationScreen(),
      binding: TournamentCreationBinding(),
    ),
    GetPage(
      name: _Paths.PLAYER_INPUT,
      page: () => const PlayerInputScreen(),
      binding: PlayerInputBinding(),
    ),
    GetPage(
      name: _Paths.TEAM_ASSIGNMENT,
      page: () => const TeamAssignmentScreen(),
      binding: TeamAssignmentBinding(),
    ),
    GetPage(
      name: _Paths.TOURNAMENT_VIEW,
      page: () => const TournamentViewScreen(),
      binding: TournamentViewBinding(),
    ),
  ];
}
