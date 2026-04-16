import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2), // Pushes content down
                // Logo Image
                Center(
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          '/Users/shimulrajdas/Documents/RAJ/Wonderland/wonderland/assets/images/dreamnest-logo.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Wonder Tales',
                        style: GoogleFonts.poppins(
                          color: AppColors.accent,
                          fontSize: 22, // Adjusted up slightly for visibility
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' Hub',
                        style: GoogleFonts.poppins(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description 1
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 42.0),
                  child: Text(
                    'Personalized bedtime stories where your child becomes the hero- narrated by AI or the voices they love',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description 2
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44.0),
                  child: Text(
                    'Replay anytime or continue the adventure.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 24.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      // TODO: Handle get started action
                    },
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      width: double.infinity,
                      height: 56, // Slightly taller for better touch target
                      decoration: ShapeDecoration(
                        gradient: AppColors.buttonGradient,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        shadows: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
