import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../child_profile/add_child_screen.dart';
import '../../data/providers/child_provider.dart';
import '../../data/providers/story_provider.dart';
import '../../data/providers/navigation_provider.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  int _selectedChild = 0;
  int _selectedTheme = 0;
  int _selectedDuration = 1; // 0=Short, 1=Medium, 2=Long

  int _selectedVoiceType = 0; // 0=AI Voice, 1=Family Voice
  int _selectedVoice = 0;

  bool _isGenerating = false;


  final List<Map<String, dynamic>> _themes = [
    {'name': 'Adventure', 'icon': Icons.explore},
    {'name': 'Fantasy', 'icon': Icons.auto_fix_high},
    {'name': 'Animals', 'icon': Icons.pets},
    {'name': 'Custom', 'icon': Icons.brush},
  ];

  final List<Map<String, String>> _durations = [
    {'label': 'Short: 3 min', 'value': '3'},
    {'label': 'Medium: 5 min', 'value': '5'},
    {'label': 'Long: 10 min', 'value': '10'},
  ];

  final List<Map<String, dynamic>> _voices = [
    {'name': 'Luna', 'desc': 'Warm & Gentle', 'icon': Icons.nightlight_round},
    {'name': 'Atlas', 'desc': 'Calm & Soothing', 'icon': Icons.nights_stay},
    {'name': 'Willow', 'desc': 'Soft & Whispery', 'icon': Icons.eco},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTitle(),
            const SizedBox(height: 24),
            _buildSectionTitle('Select Child'),
            const SizedBox(height: 12),
            _buildChildSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Story Theme'),
            const SizedBox(height: 12),
            _buildThemeSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Story Theme'),
            const SizedBox(height: 12),
            _buildDurationSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Language'),
            const SizedBox(height: 12),
            _buildLanguageSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Voice Selection'),
            const SizedBox(height: 12),
            _buildVoiceTypeToggle(),
            const SizedBox(height: 16),
            _buildVoiceCards(),
            const SizedBox(height: 32),
            _buildGenerateButton(),
            const SizedBox(height: 140), // Spacer for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        'Create New Story',
        style: GoogleFonts.poppins(
          color: const Color(0xFFFEFEFE),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
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

  // ─── Select Child ─────────────────────────────────────────────────

  Widget _buildChildSelector() {
    final children = ref.watch(childProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: const Color(0x33E8A547),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: children.isEmpty
                    ? [
                        Text(
                          'No children added yet.',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        )
                      ]
                    : children.asMap().entries.map((entry) {
                        final index = entry.key;
                        final child = entry.value;
                        final isSelected = _selectedChild == index;
                        return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedChild = index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: ShapeDecoration(
                          color: isSelected
                              ? const Color(0xFF575757)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: isSelected
                                  ? const Color(0xFFE89C30)
                                  : Colors.white.withValues(alpha: 0.20),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: AssetImage(child.avatarPath),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(73),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              child.name,
                              style: GoogleFonts.poppins(
                                color: isSelected
                                    ? const Color(0xFFE89C30)
                                    : const Color(0x7FFEFEFE),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Add Child button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddChildScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: ShapeDecoration(
                gradient: AppColors.buttonGradient,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }

  // ─── Story Theme ──────────────────────────────────────────────────

  Widget _buildThemeSelector() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _themes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final theme = _themes[index];
          final isSelected = _selectedTheme == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTheme = index),
            child: Container(
              width: 86,
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: isSelected ? const Color(0xFF575757) : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected
                        ? const Color(0xFFE89C30)
                        : Colors.white.withValues(alpha: 0.20),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x28000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      theme['icon'] as IconData,
                      color: isSelected
                          ? const Color(0xFFE89C30)
                          : Colors.white.withValues(alpha: 0.5),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    theme['name'] as String,
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? const Color(0xFFE89C30)
                          : const Color(0x7FFEFEFE),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Duration ─────────────────────────────────────────────────────

  Widget _buildDurationSelector() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _durations.asMap().entries.map((entry) {
        final index = entry.key;
        final duration = entry.value;
        final isSelected = _selectedDuration == index;
        return GestureDetector(
            onTap: () => setState(() => _selectedDuration = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: ShapeDecoration(
                gradient: isSelected ? AppColors.buttonGradient : null,
                color: isSelected ? null : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected
                        ? const Color(0xFFE89C30)
                        : Colors.white.withValues(alpha: 0.20),
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                shadows: isSelected
                    ? const [
                        BoxShadow(
                          color: Color(0x28000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    duration['label']!,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
      }).toList(),
    );
  }

  // ─── Language ─────────────────────────────────────────────────────

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        // English pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: ShapeDecoration(
            gradient: AppColors.buttonGradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text('🇬🇧', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'English',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Select Language dropdown
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.only(left: 10, right: 8, top: 6, bottom: 6),
            decoration: ShapeDecoration(
              gradient: AppColors.buttonGradient,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Language',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.50),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Voice Selection ──────────────────────────────────────────────

  Widget _buildVoiceTypeToggle() {
    return Row(
      children: [
        // AI Voice
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedVoiceType = 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: ShapeDecoration(
                gradient:
                    _selectedVoiceType == 0 ? AppColors.buttonGradient : null,
                color: _selectedVoiceType == 0
                    ? null
                    : Colors.white.withValues(alpha: 0.10),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: _selectedVoiceType == 0
                        ? const Color(0xFFE89C30)
                        : Colors.white.withValues(alpha: 0.20),
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x28000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.volume_up, color: Colors.white, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    'AI Voice',
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
        ),
        const SizedBox(width: 12),
        // Family Voice
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedVoiceType = 1),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: ShapeDecoration(
                    gradient: _selectedVoiceType == 1
                        ? AppColors.buttonGradient
                        : null,
                    color: _selectedVoiceType == 1
                        ? null
                        : Colors.white.withValues(alpha: 0.10),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: _selectedVoiceType == 1
                            ? const Color(0xFFE89C30)
                            : Colors.white.withValues(alpha: 0.20),
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.mic, color: Colors.white, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'Family Voice',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Pro badge
                Positioned(
                  right: 16,
                  top: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: ShapeDecoration(
                      color: const Color(0xCC343434),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFE89C30),
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock,
                          color: Color(0xFFE89C30),
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Pro',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFE89C30),
                            fontSize: 12,
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
      ],
    );
  }

  Widget _buildVoiceCards() {
    return Row(
      children: _voices.asMap().entries.map((entry) {
        final index = entry.key;
        final voice = entry.value;
        final isSelected = _selectedVoice == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < _voices.length - 1 ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedVoice = index),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: ShapeDecoration(
                  color: isSelected
                      ? const Color(0xFF575757)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: isSelected
                          ? const Color(0xFFE89C30)
                          : Colors.white.withValues(alpha: 0.20),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x28000000),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      voice['icon'] as IconData,
                      color: isSelected
                          ? const Color(0xFFE89C30)
                          : Colors.white.withValues(alpha: 0.5),
                      size: 40,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      voice['name'] as String,
                      style: GoogleFonts.poppins(
                        color: isSelected
                            ? const Color(0xFFE89C30)
                            : Colors.white.withValues(alpha: 0.50),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      voice['desc'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.80)
                            : Colors.white.withValues(alpha: 0.50),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Generate Button ──────────────────────────────────────────────

  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: _isGenerating ? null : _generateStory,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: ShapeDecoration(
          gradient: _isGenerating 
              ? LinearGradient(colors: [Colors.grey, Colors.grey.shade700])
              : AppColors.buttonGradient,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1, 
                color: _isGenerating ? Colors.transparent : const Color(0xFFE89C30)),
            borderRadius: BorderRadius.circular(42),
          ),
          shadows: _isGenerating ? null : const [
            BoxShadow(
              color: Color(0x285E57B6),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: _isGenerating
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Generate Story',
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

  Future<void> _generateStory() async {
    final children = ref.read(childProvider);
    if (children.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a child first!')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    final selectedChild = children[_selectedChild].name;
    final theme = _themes[_selectedTheme]['name'] as String;
    final durationStr = _durations[_selectedDuration]['value'] as String;
    final duration = int.tryParse(durationStr) ?? 5;

    await ref.read(storyProvider.notifier).generateStory(
      theme: theme,
      duration: duration,
      childName: selectedChild,
    );

    if (mounted) {
      setState(() => _isGenerating = false);
      // Navigate to library tab
      ref.read(navigationProvider.notifier).setTab(1);
    }
  }
}
