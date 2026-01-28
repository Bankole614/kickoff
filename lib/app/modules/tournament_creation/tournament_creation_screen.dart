import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';
import 'package:kickoff/app/modules/tournament_creation/tournament_creation_controller.dart';

class TournamentCreationScreen extends GetView<TournamentCreationController> {
  const TournamentCreationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Tournament'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.tournamentNameController,
              decoration: const InputDecoration(
                labelText: 'Tournament Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => _buildDropdown(
                'Tournament Type',
                ['League', 'Knockout', 'Groups + Knockout'],
                controller.tournamentType.value,
                controller.onTournamentTypeChanged,
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => _buildDropdown(
                'Match Format',
                [
                  '4v4',
                  '5v5',
                  '6v6',
                  '7v7',
                  '8v8',
                  '9v9',
                  '10v10',
                  '11v11'
                ],
                controller.matchFormat.value,
                controller.onMatchFormatChanged,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: controller.toPlayerInput,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Next: Add Players',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    void Function(String?)? onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
