import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';
import 'package:kickoff/app/modules/tournament_view/tournament_view_controller.dart';
import 'package:kickoff/app/modules/tournament_view/widgets/league_table.dart';
import 'package:kickoff/app/modules/tournament_view/widgets/match_list.dart';
import 'package:kickoff/app/modules/tournament_view/widgets/team_list.dart';

class TournamentViewScreen extends GetView<TournamentViewController> {
  const TournamentViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            controller.tournamentName,
            style: const TextStyle( color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            tabs: const [
              Tab(text: 'Standings'),
              Tab(text: 'Matches'),
              Tab(text: 'Teams'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            if (controller.tournamentType == 'League')
              const LeagueTable()
            else
              _buildComingSoon('Standings'),
            if (controller.tournamentType == 'League')
              const MatchList()
            else
              _buildComingSoon('Matches'),
            const TeamList(),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoon(String feature) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '$feature not available yet\nfor this tournament type.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
