import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';
import 'package:kickoff/app/modules/home/home_controller.dart';
import 'package:kickoff/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tournaments'),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(
        () {
          if (controller.tournaments.isEmpty) {
            return const Center(
              child: Text(
                'No tournaments yet. Tap + to create one.',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: controller.tournaments.length,
              itemBuilder: (context, index) {
                final tournament = controller.tournaments[index];
                return Dismissible(
                  key: Key(tournament.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    controller.deleteTournament(tournament.id);
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(tournament.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          '${tournament.type} - ${tournament.format} • ${DateFormat.yMMMd().format(tournament.createdDate)}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => controller.openTournament(tournament),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.TOURNAMENT_CREATION);
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
