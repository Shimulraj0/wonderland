import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../common/widgets/background_scaffold.dart';
import '../home/home_screen.dart';

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
    {
      'name': 'Adventure',
      'icon': 'assets/images/mountain.png',
      'isAsset': true
    },
    {
      'name': 'Animals',
      'icon': 'assets/images/Lion.png',
      'isAsset': true
    },
    {
      'name': 'Space',
      'icon': 'assets/images/Rocket.png',
      'isAsset': true
    },
    {
      'name': 'Fairy Tales',
      'icon': 'assets/images/fairy.png',
      'isAsset': true
    },
    {
      'name': 'Ocean',
      'icon': 'assets/images/Wave.png',
      'isAsset': true
    },
    {
      'name': 'Dinosaurs',
      'icon': 'assets/images/dinosor.png',
      'isAsset': true
    },
  ];

  bool _isLoading = false;

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

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    
    // Simulate API call to create child profile
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Add Your Child',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFEFEFE),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 223,
                child: Text(
                  'Tell us about your little dreamer',
                  style: GoogleFonts.poppins(
                    color: const Color(0xCCFEFEFE),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 52),

              // Child's Name
              _buildLabel('Child’s Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                placeholder: 'Enter their name',
              ),

              const SizedBox(height: 32),

              // Age
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Age ',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '(3-10)',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.60),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
                  childAspectRatio: 164 / 64,
                ),
                itemCount: _themes.length,
                itemBuilder: (context, index) {
                  final theme = _themes[index];
                  final isSelected = _selectedThemes.contains(theme['name']);
                  return InkWell(
                    onTap: () => _toggleTheme(theme['name']),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: isSelected
                            ? const Color(0xFFE89C30).withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.10),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: isSelected
                                ? const Color(0xFFE89C30)
                                : const Color(0x33797979),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 16),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(),
                            child: theme['isAsset']
                                ? Image.asset(
                                    theme['icon'] as String,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white24,
                                      size: 20,
                                    ),
                                  )
                                : Icon(
                                    theme['icon'] as IconData,
                                    color: isSelected
                                        ? const Color(0xFFE89C30)
                                        : Colors.white.withValues(alpha: 0.6),
                                    size: 24,
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              theme['name'],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Add Child Button
              Center(
                child: InkWell(
                  onTap: _isLoading ? null : _submit,
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    width: 338,
                    height: 48,
                    decoration: ShapeDecoration(
                      gradient: _isLoading
                          ? LinearGradient(
                              colors: [Colors.grey, Colors.grey.shade700],
                            )
                          : const LinearGradient(
                              begin: Alignment(0.47, 0.52),
                              end: Alignment(0.45, 1.12),
                              colors: [Color(0xFFE89C30), Color(0xFFFFDBA7)],
                            ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add,
                                    color: Colors.white, size: 24),
                                const SizedBox(width: 6),
                                Text(
                                  'Add Child',
                                  textAlign: TextAlign.center,
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
              ),

              const SizedBox(height: 16),

              // Skip Button
              Center(
                child: InkWell(
                  onTap: _isLoading ? null : _submit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        color: const Color(0x33F9FAFB),
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
