import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/brand_wordmark.dart';
import '../../core/widgets/wash_background.dart';
import 'auth_controller.dart';

/// Student sign-in: the college already enrolled the mobile number.
/// OTP is entered here; a live SMS gateway is not wired yet, so any
/// 6-digit code completes the local session and opens that student's home.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobileCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;
  String? _formError;
  String _otpMobile = '';

  @override
  void initState() {
    super.initState();
    _mobileCtrl.addListener(_onMobileChanged);
  }

  @override
  void dispose() {
    _mobileCtrl.removeListener(_onMobileChanged);
    _mobileCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  String get _mobileDigits => _mobileCtrl.text.replaceAll(RegExp(r'\D'), '');

  void _onMobileChanged() {
    if (!_otpSent || _mobileDigits == _otpMobile) return;
    setState(() {
      _otpSent = false;
      _otpMobile = '';
      _otpCtrl.clear();
      _formError = null;
    });
  }

  bool get _mobileOk => RegExp(r'^[6-9]\d{9}$').hasMatch(_mobileDigits);

  String _prettyMobile(String digits) {
    if (digits.length != 10) return digits;
    return '${digits.substring(0, 5)} ${digits.substring(5)}';
  }

  void _sendOtp() {
    if (!_mobileOk) {
      setState(() {
        _formError =
            'Enter the 10-digit mobile number your college registered.';
      });
      return;
    }
    setState(() {
      _otpSent = true;
      _otpMobile = _mobileDigits;
      _formError = null;
      _loading = false;
    });
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('OTP sent to +91 ${_prettyMobile(_mobileDigits)}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _verifyOtp() async {
    if (!_otpSent || _mobileDigits != _otpMobile) {
      setState(() {
        _formError = 'Send an OTP to this mobile number first.';
      });
      return;
    }
    final otp = _otpCtrl.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      setState(() {
        _formError = 'Enter the 6-digit OTP sent to your mobile.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _formError = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 350));
    await ref.read(authControllerProvider.notifier).loginStudent();
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WashBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              const BrandWordmark(logoSize: 36, fontSize: 18),
              const SizedBox(height: 28),
              Text(
                'Login with OTP',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Use the mobile number your college registered for you.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.4,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Mobile number',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textFaint,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _mobileCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                inputFormatters: [_MobileNumberFormatter()],
                decoration: const InputDecoration(
                  hintText: '10-digit mobile number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 14, right: 8),
                    child: _CountryPrefix(),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter OTP',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textFaint,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (_) {
                  if (_otpSent) _verifyOtp();
                },
                decoration: const InputDecoration(
                  hintText: '6-digit OTP',
                  counterText: '',
                ),
              ),
              if (_formError != null) ...[
                const SizedBox(height: 10),
                Text(
                  _formError!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.35,
                    color: AppColors.danger,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _loading
                    ? null
                    : (_otpSent ? _verifyOtp : _sendOtp),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_otpSent ? 'Verify & continue' : 'Send OTP'),
              ),
              if (_otpSent) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _loading ? null : _sendOtp,
                    child: const Text('Resend OTP'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryPrefix extends StatelessWidget {
  const _CountryPrefix();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '+91',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 1,
          height: 22,
          color: AppColors.border,
        ),
      ],
    );
  }
}

class _MobileNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > 10 ? digits.substring(0, 10) : digits;
    final pretty = clipped.length > 5
        ? '${clipped.substring(0, 5)} ${clipped.substring(5)}'
        : clipped;
    return TextEditingValue(
      text: pretty,
      selection: TextSelection.collapsed(offset: pretty.length),
    );
  }
}
