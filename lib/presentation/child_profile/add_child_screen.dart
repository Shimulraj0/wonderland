import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../common/widgets/background_scaffold.dart';

class AddChildScreen extends ConsumerStatefulWidget {
  const AddChildScreen({super.key});

  @override
  ConsumerState<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final Set<String> _selectedThemes = {};

  final List<Map<String, dynamic>> _themes = [
    {'name': 'Adventure', 'icon': Icons.explore},
    {'name': 'Animals', 'icon': Icons.pets},
    {'name': 'Space', 'icon': Icons.rocket_launch},
    {'name': 'Fairy Tales', 'icon': Icons.auto_fix_high},
    {'name': 'Ocean', 'icon': Icons.waves},
    {'name': 'Dinosaurs', 'icon': Icons.extension},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _toggleTheme(String theme) {
    setState(() {
      if (_selectedThemes.contains(theme)) {
        _selectedThemes.remove(theme);
      } else {
        _selectedThemes.add(theme);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Add Your Child',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFEFEFE),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us about your little dreamer',
                style: GoogleFonts.poppins(
                  color: const Color(0xCCFEFEFE),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              
              // Child's Name
              _buildLabel('Child’s Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                placeholder: 'Enter their name',
              ),
              
              const SizedBox(height: 24),
              
              // Age
              Row(
                children: [
                  Text(
                    'Age ',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '(3-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.60),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _ageController,
                placeholder: 'Enter age',
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 32),
              
              // Favorite Themes
              Text(
                'Favorite Themes',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              
              // Themes Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                itemCount: _themes.length,
                itemBuilder: (context, index) {
                  final theme = _themes[index];
                  final isSelected = _selectedThemes.contains(theme['name']);
                  return InkWell(
                    onTap: () => _toggleTheme(theme['name']),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: isSelected 
                            ? const Color(0xFFE89C30).withValues(alpha: 0.2) 
                            : Colors.white.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: isSelected ? const Color(0xFFE89C30) : const Color(0x33797979),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            theme['icon'],
                            color: isSelected ? const Color(0xFFE89C30) : Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            theme['name'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // Add Child Button
              InkWell(
                onTap: () {
                  // Navigate to Home or Success
                },
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: ShapeDecoration(
                    gradient: AppColors.buttonGradient,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Add Child',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Skip Button
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to Home
                  },
                  child: Text(
                    'Skip for now',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE89C30),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0x1AFFFFFF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x33797979)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF6B7280),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
