import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/brand_wordmark.dart';
import '../../core/widgets/wash_background.dart';
import 'auth_controller.dart';
import 'auth_messages.dart';
import 'auth_repository.dart';
import 'phone_number.dart';

/// Mobile OTP sign-in. The number must already be enrolled. Enrolled numbers
/// receive a Firebase SMS code. The screen does not list codes, roles, or
/// other enrolled numbers.
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
  OtpSession? _session;

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
      _session = null;
      _otpCtrl.clear();
      _formError = null;
    });
  }

  Future<void> _sendOtp() async {
    final resendToken = (_otpSent && _mobileDigits == _otpMobile)
        ? _session?.resendToken
        : null;
    setState(() {
      _loading = true;
      _formError = null;
    });
    final result = await ref
        .read(authControllerProvider.notifier)
        .requestOtp(_mobileDigits, forceResendingToken: resendToken);
    if (!mounted) return;
    switch (result) {
      case OtpCodeSent(:final session):
        setState(() {
          _loading = false;
          _otpSent = true;
          _otpMobile = _mobileDigits;
          _session = session;
          _formError = null;
        });
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text('OTP sent to ${prettyIndianMobile(_mobileDigits)}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      case OtpAutoSignedIn():
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        context.go('/home');
      case OtpRequestRejected(:final reason, :final message):
        setState(() {
          _loading = false;
          _formError = message;
          final dropSession =
              reason == OtpRejection.notEnrolled ||
              reason == OtpRejection.invalidNumber ||
              reason == OtpRejection.notConfigured ||
              _session == null;
          if (dropSession) {
            _otpSent = false;
            _otpMobile = '';
            _session = null;
          }
        });
    }
  }

  Future<void> _verifyOtp() async {
    final session = _session;
    if (!_otpSent || session == null || _mobileDigits != _otpMobile) {
      setState(() {
        _formError = AuthMessages.sendFirst;
      });
      return;
    }
    final otp = _otpCtrl.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      setState(() {
        _formError = AuthMessages.enterOtp;
      });
      return;
    }
    setState(() {
      _loading = true;
      _formError = null;
    });
    final result = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(session: session, code: otp);
    if (!mounted) return;
    switch (result) {
      case OtpVerified():
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        context.go('/home');
      case OtpVerifyRejected(:final message):
        setState(() {
          _loading = false;
          _formError = message;
        });
    }
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
                onPressed: _loading ? null : (_otpSent ? _verifyOtp : _sendOtp),
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
        Container(width: 1, height: 22, color: AppColors.border),
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
