import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/modules/tournament_view/tournament_view_controller.dart';

class LeagueTable extends GetView<TournamentViewController> {
  const LeagueTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => DataTable(
          columns: const [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Team')),
            DataColumn(label: Text('P')),
            DataColumn(label: Text('W')),
            DataColumn(label: Text('D')),
            DataColumn(label: Text('L')),
            DataColumn(label: Text('GF')),
            DataColumn(label: Text('GA')),
            DataColumn(label: Text('GD')),
            DataColumn(label: Text('Pts')),
          ],
          rows: controller.standings.asMap().entries.map((entry) {
            final index = entry.key;
            final standing = entry.value;
            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(Text(standing.team.name.value)),
                DataCell(Text('${standing.played}')),
                DataCell(Text('${standing.won}')),
                DataCell(Text('${standing.drawn}')),
                DataCell(Text('${standing.lost}')),
                DataCell(Text('${standing.goalsFor}')),
                DataCell(Text('${standing.goalsAgainst}')),
                DataCell(Text('${standing.goalDifference}')),
                DataCell(Text('${standing.points}')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
