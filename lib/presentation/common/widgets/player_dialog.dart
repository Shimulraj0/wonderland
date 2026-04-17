import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/story_model.dart';
import 'dart:ui';

class PlayerDialog extends StatelessWidget {
  final StoryModel story;

  const PlayerDialog({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: ShapeDecoration(
              color: const Color(0x33E8A547),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0x33E89C30)),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Art placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.music_note_rounded, color: Colors.white70, size: 48),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  story.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${story.durationMinutes} min • ${story.theme}',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const ShapeDecoration(
                        gradient: AppColors.buttonGradient,
                        shape: OvalBorder(),
                      ),
                      child: const Center(
                        child: Icon(Icons.pause_rounded, color: Colors.white, size: 36),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
