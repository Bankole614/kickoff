import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';
import 'package:kickoff/app/modules/tournament_view/tournament_view_controller.dart';
import 'package:kickoff/app/modules/tournament_view/widgets/league_table.dart';
import 'package:kickoff/app/modules/tournament_view/widgets/match_list.dart';

class TournamentViewScreen extends GetView<TournamentViewController> {
  const TournamentViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.tournamentName),
          backgroundColor: AppColors.primary,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Standings'),
              Tab(text: 'Matches'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            if (controller.tournamentType == 'League')
              const LeagueTable()
            else
              const Center(child: Text('Standings not available for this tournament type.')),
            if (controller.tournamentType == 'League')
              const MatchList()
            else
              const Center(child: Text('Matches not available for this tournament type.')),
          ],
        ),
      ),
    );
  }
}
