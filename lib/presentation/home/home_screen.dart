import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../child_profile/add_child_screen.dart';
import '../common/widgets/background_scaffold.dart';
import '../create/create_story_screen.dart';
import '../library/library_screen.dart';
import '../voice/voice_screen.dart';
import '../profile/profile_screen.dart';
import '../../data/providers/navigation_provider.dart';
import '../../data/providers/child_provider.dart';
import '../../data/providers/story_provider.dart';
import '../../data/models/child_model.dart';
import '../../data/models/story_model.dart';

import '../common/widgets/player_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      body: Stack(
        children: [
          // Tab Content
          _buildTabContent(ref.watch(navigationProvider)),

          // Floating Bottom Navigation
          Positioned(left: 30, right: 30, bottom: 40, child: _buildBottomNav()),
        ],
      ),
    );
  }

  Widget _buildTabContent(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const LibraryScreen();
      case 2:
        return const CreateStoryScreen();
      case 3:
        return const VoiceScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final children = ref.watch(childProvider);
    final stories = ref.watch(storyProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildHeader(context, children, stories),
            const SizedBox(height: 32),
            if (stories.isNotEmpty) ...[
              _buildContinueAdventure(stories.first),
              const SizedBox(height: 32),
            ],
            _buildCreateNewStory(),
            const SizedBox(height: 32),
            _buildRecentStories(stories),
            const SizedBox(height: 120), // Spacer for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<ChildModel> children, List<StoryModel> stories) {
    final displayName = children.isNotEmpty ? children.first.name : 'Parent';
    final storyText = stories.isNotEmpty ? '${stories.first.durationMinutes} min • ${stories.first.theme}' : 'No stories yet';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/profile_image.png'),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $displayName!',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFFEFEFE),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  storyText,
                  style: GoogleFonts.poppins(
                    color: const Color(0xB2FEFEFE),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddChildScreen()),
            );
          },
          borderRadius: BorderRadius.circular(32),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: ShapeDecoration(
              color: const Color(0xFFE89C30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Add Child',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueAdventure(StoryModel story) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Tonight’s Adventure',
          style: GoogleFonts.poppins(
            color: const Color(0xFFFEFEFE),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x28000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: ShapeDecoration(
                      color: const Color(0x33E8A547),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Text(
                            story.title,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFFEFEFE),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${story.durationMinutes} min • ${story.theme}',
                          style: GoogleFonts.poppins(
                            color: const Color(0xB2FEFEFE),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => PlayerDialog(story: story),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          decoration: ShapeDecoration(
                            gradient: AppColors.buttonGradient,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Resume Story',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Floating Animal/Character
            Positioned(
              right: -10,
              bottom: -10,
              child: Image.asset(
                'assets/images/enchanting-white-fox.png',
                width: 200,
                height: 230,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateNewStory() {
    return InkWell(
      onTap: () {
        ref.read(navigationProvider.notifier).setTab(2);
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: ShapeDecoration(
          gradient: AppColors.buttonGradient,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE89C30)),
            borderRadius: BorderRadius.circular(42),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x285E57B6),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_fix_high, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              'Create New Story',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentStories(List<StoryModel> stories) {
    if (stories.isEmpty) return const SizedBox.shrink();

    // Skip the first one if it's shown in "Continue Adventure"
    final recent = stories.length > 1 ? stories.sublist(1) : <StoryModel>[];
    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Stories',
          style: GoogleFonts.poppins(
            color: const Color(0xFFFEFEFE),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ...recent.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildStoryItem(s),
        )),
      ],
    );
  }

  Widget _buildStoryItem(StoryModel story) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: const Color(0x26E89C30),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x19E89C30)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${story.durationMinutes} min • ${story.theme}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xB2FEFEFE),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => PlayerDialog(story: story),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: ShapeDecoration(
                    gradient: AppColors.buttonGradient,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Play',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home', ref),
                _buildNavItem(1, Icons.all_inbox_rounded, 'Library', ref),
                _buildNavItem(2, Icons.auto_awesome, 'Create', ref),
                _buildNavItem(3, Icons.mic_none_rounded, 'Voice', ref),
                _buildNavItem(4, Icons.person_rounded, 'Profile', ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
    final isSelected = currentIndex == index;
    const selectedColor = Color(0xFFE89C30);
    final unselectedColor = Colors.white.withValues(alpha: 0.5);
    const duration = Duration(milliseconds: 400);
    const curve = Curves.easeOutCubic;

    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(navigationProvider.notifier).setTab(index),
        behavior: HitTestBehavior.opaque,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: isSelected ? 1.0 : 0.0),
          duration: duration,
          curve: curve,
          builder: (context, value, _) {
            final color = Color.lerp(unselectedColor, selectedColor, value)!;
            final scale = 1.0 + (0.12 * value);
            final glowOpacity = 0.18 * value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with glow backdrop + scale
                Transform.scale(
                  scale: scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Soft glow behind active icon
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: selectedColor.withValues(alpha: glowOpacity),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      Icon(icon, color: color, size: 28),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
