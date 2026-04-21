import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ForgotPassword>
    with TickerProviderStateMixin {

  int _step = 0;

  final _emailCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final List<TextEditingController> _otpCtrl =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _otpFocus =
  List.generate(6, (_) => FocusNode());

  final _emailKey = GlobalKey<FormState>();
  final _pwdKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));

    _fadeCtrl.forward();
    _slideCtrl.forward();
  }

  void _nextStep() {
    _fadeCtrl.reset();
    _slideCtrl.reset();
    _fadeCtrl.forward();
    _slideCtrl.forward();
  }

  // ───────────────────────────────────────────────
  // UI COLORS (MATCH LOGIN SCREEN)
  // ───────────────────────────────────────────────
  final primaryColor = const Color(0xFF4F46E5);
  final bgColor = Colors.white;
  final inputBg = const Color(0xFFF8FAFC);
  final textDark = const Color(0xFF1E293B);

  // ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Back Button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      if (_step == 0) {
                        Navigator.pop(context);
                      } else {
                        setState(() => _step--);
                        _nextStep();
                      }
                    },
                  )
                ],
              ),

              const SizedBox(height: 20),

              _buildStepIndicator(),

              const SizedBox(height: 30),

              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // STEP INDICATOR
  // ───────────────────────────────────────────────
  Widget _buildStepIndicator() {
    final steps = ['Email', 'OTP', 'Password'];

    return Row(
      children: List.generate(3, (i) {
        final active = i == _step;

        return Expanded(
          child: Column(
            children: [
              Container(
                height: 4,
                color: i <= _step ? primaryColor : Colors.grey[300],
              ),
              const SizedBox(height: 6),
              Text(
                steps[i],
                style: TextStyle(
                  color: active ? primaryColor : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return _emailStep();
      case 1:
        return _otpStep();
      case 2:
        return _passwordStep();
      case 3:
        return _successStep();
      default:
        return _emailStep();
    }
  }

  // ───────────────────────────────────────────────
  // STEP 1 EMAIL
  // ───────────────────────────────────────────────
  Widget _emailStep() {
    return Form(
      key: _emailKey,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Icon(Icons.lock_reset, size: 70, color: primaryColor),

          const SizedBox(height: 20),
          Text("Reset Password",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textDark)),

          const SizedBox(height: 10),
          const Text("Enter your email"),

          const SizedBox(height: 40),

          _inputField(_emailCtrl, "Email", Icons.email),

          const SizedBox(height: 30),

          _button("Send OTP", () {
            if (_emailKey.currentState!.validate()) {
              setState(() => _step = 1);
              _nextStep();
            }
          })
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // STEP 2 OTP
  // ───────────────────────────────────────────────
  Widget _otpStep() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Icon(Icons.verified, size: 70, color: primaryColor),

        const SizedBox(height: 20),
        const Text("Enter OTP"),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) => _otpBox(i)),
        ),

        const SizedBox(height: 30),

        _button("Verify", () {
          setState(() => _step = 2);
          _nextStep();
        })
      ],
    );
  }

  Widget _otpBox(int i) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: _otpCtrl[i],
        focusNode: _otpFocus[i],
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: inputBg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && i < 5) {
            _otpFocus[i + 1].requestFocus();
          }
        },
      ),
    );
  }

  // ───────────────────────────────────────────────
  // STEP 3 PASSWORD
  // ───────────────────────────────────────────────
  Widget _passwordStep() {
    return Form(
      key: _pwdKey,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Icon(Icons.lock, size: 70, color: primaryColor),

          const SizedBox(height: 20),
          const Text("New Password"),

          const SizedBox(height: 30),

          _inputField(_newPwdCtrl, "New Password", Icons.lock,
              isPass: true),

          _inputField(_confirmCtrl, "Confirm Password", Icons.lock,
              isPass: true),

          const SizedBox(height: 30),

          _button("Reset Password", () {
            setState(() => _step = 3);
            _nextStep();
          })
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // SUCCESS
  // ───────────────────────────────────────────────
  Widget _successStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 90, color: primaryColor),
        const SizedBox(height: 20),
        const Text("Success!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("Password Reset Successfully"),

        const SizedBox(height: 30),

        _button("Back to Login", () {
          Navigator.pop(context);
        })
      ],
    );
  }

  // ───────────────────────────────────────────────
  // COMMON WIDGETS
  // ───────────────────────────────────────────────
  Widget _inputField(TextEditingController ctrl, String hint, IconData icon,
      {bool isPass = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: ctrl,
        obscureText: isPass,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _button(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}