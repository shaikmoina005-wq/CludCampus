import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/models.dart';
import '../../core/widgets/demo_banner.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  UserRole _role = UserRole.student;
  final _collegeCtrl = TextEditingController(text: 'ASN-TENALI');
  final _idCtrl = TextEditingController(text: 'Y21CS045');
  bool _loading = false;

  @override
  void dispose() {
    _collegeCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    await ref.read(authControllerProvider.notifier).login(
          role: _role,
          collegeCode: _collegeCtrl.text.trim().isEmpty
              ? 'ASN-TENALI'
              : _collegeCtrl.text.trim(),
        );
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const DemoBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/branding/cludcampus-logo-header-on-white.png',
                        height: 56,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Welcome to ${AppStrings.appName}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Demo login — pick a role and continue. No password required.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'I am a',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: UserRole.values.map((role) {
                        final selected = _role == role;
                        return ChoiceChip(
                          label: Text(role.label),
                          selected: selected,
                          onSelected: (_) => setState(() => _role = role),
                          selectedColor: AppColors.accent.withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.accent
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide(
                            color: selected
                                ? AppColors.accent
                                : AppColors.border,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _collegeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'College code',
                        hintText: 'ASN-TENALI',
                        prefixIcon: Icon(Icons.apartment_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _idCtrl,
                      decoration: InputDecoration(
                        labelText: _role == UserRole.student
                            ? 'Roll number'
                            : 'Staff ID',
                        hintText: 'Y21CS045',
                        prefixIcon: const Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _loading ? null : _continue,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Continue to demo'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Student experience is fully built. Other roles open the same shell with a demo badge.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
