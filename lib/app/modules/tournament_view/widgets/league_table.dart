import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';
import 'package:kickoff/app/modules/tournament_view/tournament_view_controller.dart';

class LeagueTable extends GetView<TournamentViewController> {
  const LeagueTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 400),
            child: Obx(
              () => DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
                dataRowHeight: 56,
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('#', style: TextStyle(color: Colors.grey))),
                  DataColumn(label: Text('Team')),
                  DataColumn(label: Text('P'), tooltip: 'Played'),
                  DataColumn(label: Text('W'), tooltip: 'Won'),
                  DataColumn(label: Text('D'), tooltip: 'Drawn'),
                  DataColumn(label: Text('L'), tooltip: 'Lost'),
                  DataColumn(label: Text('GD'), tooltip: 'Goal Difference'),
                  DataColumn(label: Text('Pts', style: TextStyle(color: AppColors.primary))),
                ],
                rows: controller.standings.asMap().entries.map((entry) {
                  final index = entry.key;
                  final standing = entry.value;
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (index < 3) return const Color(0xFFF0FDF4); // Highlight top 3
                      return null;
                    }),
                    cells: [
                      DataCell(
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: index < 3
                                ? AppColors.primary
                                : Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: index < 3 ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          standing.team.name.value,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DataCell(Text('${standing.played}')),
                      DataCell(Text('${standing.won}')),
                      DataCell(Text('${standing.drawn}')),
                      DataCell(Text('${standing.lost}')),
                      DataCell(
                        Text(
                          '${standing.goalDifference > 0 ? '+' : ''}${standing.goalDifference}',
                          style: TextStyle(
                            color: standing.goalDifference > 0
                                ? Colors.green
                                : (standing.goalDifference < 0 ? Colors.red : Colors.grey),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${standing.points}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
