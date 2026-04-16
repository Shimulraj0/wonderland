import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/states/auth_state.dart';
import '../common/widgets/background_scaffold.dart';
import '../verify_email/verify_email_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  bool _acceptTerms = false;

  final List<String> _days = List.generate(31, (i) => (i + 1).toString());
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> _years = List.generate(100, (i) => (2024 - i).toString());

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms and Conditions')),
      );
      return;
    }

    final birthDate =
        (_selectedDay != null &&
            _selectedMonth != null &&
            _selectedYear != null)
        ? '$_selectedDay $_selectedMonth $_selectedYear'
        : null;

    ref
        .read(authProvider.notifier)
        .signUp(
          email: email,
          password: password,
          username: username,
          birthDate: birthDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (next is AuthUnverified) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerifyEmailScreen(email: _emailController.text.trim()),
          ),
        );
      }
    });

    return BackgroundScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/dreamnest-logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Create your Account',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(_emailController, 'name@example.com', !isLoading),

              const SizedBox(height: 20),
              _buildLabel('Username'),
              const SizedBox(height: 8),
              _buildTextField(_usernameController, 'Bonnie Green', !isLoading),

              const SizedBox(height: 20),
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(
                _passwordController,
                '••••••••••',
                !isLoading,
                obscureText: true,
              ),

              const SizedBox(height: 20),
              _buildLabel('Birth Date'),
              const SizedBox(height: 10),
              _buildDropdown(
                'Day',
                _selectedDay,
                _days,
                (v) => setState(() => _selectedDay = v),
                !isLoading,
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                'Month',
                _selectedMonth,
                _months,
                (v) => setState(() => _selectedMonth = v),
                !isLoading,
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                'Year',
                _selectedYear,
                _years,
                (v) => setState(() => _selectedYear = v),
                !isLoading,
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: isLoading
                    ? null
                    : () => setState(() => _acceptTerms = !_acceptTerms),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: ShapeDecoration(
                        color: _acceptTerms
                            ? Colors.blue.withValues(alpha: 0.5)
                            : const Color(0x33F9FAFB),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 0.50,
                            color: Color(0x33D1D5DB),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _acceptTerms
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'I accept the ',
                              style: GoogleFonts.inter(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1C64F2),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              InkWell(
                onTap: isLoading ? null : _handleRegister,
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: ShapeDecoration(
                    gradient: isLoading
                        ? LinearGradient(
                            colors: [Colors.grey, Colors.grey.shade700],
                          )
                        : AppColors.buttonGradient,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Create account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Already have an account?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1C64F2),
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: AppColors.textMuted,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String placeholder,
    bool enabled, {
    bool obscureText = false,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0x33797979),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x33D1D5DB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: GoogleFonts.poppins(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
    bool enabled,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: const Color(0x33797979),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x33D1D5DB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
          ),
          dropdownColor: const Color(0xFF000D1A),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF6B7280),
            size: 20,
          ),
          isExpanded: true,
          onChanged: enabled ? onChanged : null,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
