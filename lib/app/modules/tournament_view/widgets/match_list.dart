import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';
import 'package:kickoff/app/modules/tournament_view/tournament_view_controller.dart';

class MatchList extends GetView<TournamentViewController> {
  const MatchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.matches.length,
        itemBuilder: (context, index) {
          final match = controller.matches[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${match.homeTeam.name.value} vs ${match.awayTeam.name.value}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  if (match.completed)
                    Text(
                      '${match.homeScore} - ${match.awayScore}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => controller.showScoreEntryDialog(match),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent),
                      child: const Text('Enter Score', style: TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
