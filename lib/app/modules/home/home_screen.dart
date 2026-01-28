import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickoff/app/core/utils/app_colors.dart';
import 'package:kickoff/app/modules/home/home_controller.dart';
import 'package:kickoff/app/routes/app_pages.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Tournaments'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to Tournament History
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'No active tournaments yet.',
        ),
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
