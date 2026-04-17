import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/story_provider.dart';
import '../../data/models/story_model.dart';
import '../common/widgets/player_dialog.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showPlayer(BuildContext context, StoryModel story) {
    showDialog(
      context: context,
      builder: (context) => PlayerDialog(story: story),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(storyProvider);
    final filteredStories = stories.where((story) {
      return story.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             story.theme.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTitle(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 24),
            if (_searchQuery.isEmpty && stories.isNotEmpty) ...[
              _buildSectionTitle('Recently Listen'),
              const SizedBox(height: 12),
              _buildFeaturedCard(stories.first),
              const SizedBox(height: 28),
            ],
            _buildSectionTitle(_searchQuery.isEmpty ? 'All Stories' : 'Search Results'),
            const SizedBox(height: 12),
            if (filteredStories.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No stories found',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
              )
            else
              ...filteredStories.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildStoryCard(s),
                  )),
            const SizedBox(height: 140), // Spacer for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        'Library',
        style: GoogleFonts.poppins(
          color: const Color(0xFFFEFEFE),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(42),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.white.withValues(alpha: 0.5),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
              decoration: InputDecoration(
                hintText: 'Search stories...',
                border: InputBorder.none,
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0x7FFEFEFE),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Icon(Icons.close, color: Colors.white70, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: const Color(0xFFFEFEFE),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFeaturedCard(StoryModel story) {
    return Stack(
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
                      onTap: () => _showPlayer(context, story),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: ShapeDecoration(
                          gradient: AppColors.buttonGradient,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0x33E89C30),
                            ),
                            borderRadius: BorderRadius.circular(23),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Resume Story',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFFEFEFE),
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
        // Floating Character
        Positioned(
          right: -10,
          bottom: -10,
          child: Image.asset(
            'assets/images/enchanting-white-fox.png',
            width: 180,
            height: 220,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildStoryCard(StoryModel story) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            color: const Color(0x26E89C30),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x19E89C30)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            children: [
              // Story info
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
                    const SizedBox(height: 4),
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
              // Play button
              GestureDetector(
                onTap: () => _showPlayer(context, story),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: ShapeDecoration(
                    gradient: AppColors.buttonGradient,
                    shape: const OvalBorder(
                      side: BorderSide(width: 1, color: Color(0x33E89C30)),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x285E57B6),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
