import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final controller = Get.find<ProfileController>();

    // Trigger the fetch immediately when screen builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfileData();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("My Profile")),
      body: Obx(() {
        if (controller.isLoadingProfile.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.userProfile;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Profile Picture
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // 2. REAL NAME (No more hardcoding!)
              Text(
                data['full_name'] ?? "User",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 3. REAL EMAIL
              Text(
                data['email'] ?? "No Email",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 30),

              // 4. INFO CARD
              _buildInfoRow(
                Icons.work,
                "Employment",
                data['employment_type'] ?? "N/A",
              ),
              _buildInfoRow(
                Icons.currency_rupee,
                "Income",
                "₹${data['monthly_income']}",
              ),
              _buildInfoRow(Icons.badge, "PAN", data['pan_number'] ?? "N/A"),

              const SizedBox(height: 40),

              // 5. BUTTONS
              ElevatedButton.icon(
                onPressed: () {
                  // Since we pre-filled the controller in fetchProfileData(),
                  // the Edit screen will already have their data!
                  Get.toNamed(Routes.PROFILE_CREATE);
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
              ),

              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN); // Logout
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
