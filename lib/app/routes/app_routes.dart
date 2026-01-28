part of 'app_pages.dart';

abstract class Routes {
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const HOME = _Paths.HOME;
  static const TOURNAMENT_CREATION = _Paths.TOURNAMENT_CREATION;
  static const PLAYER_INPUT = _Paths.PLAYER_INPUT;
  static const TEAM_ASSIGNMENT = _Paths.TEAM_ASSIGNMENT;
  static const TOURNAMENT_VIEW = _Paths.TOURNAMENT_VIEW;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const TOURNAMENT_CREATION = '/tournament-creation';
  static const PLAYER_INPUT = '/player-input';
  static const TEAM_ASSIGNMENT = '/team-assignment';
  static const TOURNAMENT_VIEW = '/tournament-view';
}
