import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart'; // The magic package
import '../controllers/otp_controller.dart';
import '../../../core/theme/app_colors.dart'; // Assuming you have this

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller just for this screen
    final controller = Get.put(OtpController());

    // Pinput Theme (Styling the boxes)
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verification Code",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We sent a code to +91 ${controller.phoneNumber}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // --- OTP INPUT BOXES ---
            Center(
              child: Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: AppColors.primary),
                ),
                // Auto-submit when 6 digits are filled
                onCompleted: (pin) => controller.verifyOtp(pin),
              ),
            ),

            const SizedBox(height: 24),

            // --- ERROR MESSAGE ---
            Obx(
              () => controller.errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const Spacer(),

            // --- VERIFY BUTTON ---
            // Obx(
            //   () => SizedBox(
            //     width: double.infinity,
            //     height: 50,
            //     child: ElevatedButton(
            //       onPressed: controller.isLoading.value ? null : () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: AppColors.primary,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //       ),
            //       child: controller.isLoading.value
            //           ? const CircularProgressIndicator(color: Colors.white)
            //           : const Text("Verify", style: TextStyle(fontSize: 16)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
