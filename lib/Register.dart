import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_track/Log%20in.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {

  int _step = 0;

  // Step 1 — Personal Info
  final _step1Key = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final empIdCtrl = TextEditingController();
  String _selectedRole = 'user';

  // Step 2 — Contact & Password
  final _step2Key = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  // Step 3 — Photo
  final _picker = ImagePicker();
  File? _image;

  bool isLoading = false;

  // ── COLORS ──
  final primaryColor = const Color(0xFF4F46E5);
  final bgColor = Colors.white;
  final inputBg = const Color(0xFFF8FAFC);
  final textDark = const Color(0xFF1E293B);

  // ── ANIMATIONS ──
  AnimationController? _fadeCtrl;
  AnimationController? _slideCtrl;
  Animation<double>? _fadeAnim;
  Animation<Offset>? _slideAnim;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl!, curve: Curves.easeIn);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl!, curve: Curves.easeOut));

    _fadeCtrl!.forward();
    _slideCtrl!.forward();
  }

  @override
  void dispose() {
    _fadeCtrl?.dispose();
    _slideCtrl?.dispose();
    nameCtrl.dispose();
    empIdCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _fadeCtrl?.reset();
    _slideCtrl?.reset();
    _fadeCtrl?.forward();
    _slideCtrl?.forward();
  }

  Future<void> _registerUser() async {
    if (_image == null) {
      _showSnack("Please capture a photo first", isError: true);
      return;
    }

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullname', nameCtrl.text);
    await prefs.setString('emp_id', empIdCtrl.text);
    await prefs.setString('user_image', _image!.path);

    setState(() {
      isLoading = false;
      _step = 3;
    });
    _playAnimation();
  }

  Future<void> _handleCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
      if (file != null) setState(() => _image = File(file.path));
    } else {
      _showSnack("Camera permission required", isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
  }

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

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      if (_step == 0) {
                        Navigator.pop(context);
                      } else if (_step < 3) {
                        setState(() => _step--);
                        _playAnimation();
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (_step < 3) _buildStepIndicator(),

              const SizedBox(height: 30),

              Expanded(
                child: (_fadeAnim == null || _slideAnim == null)
                    ? _buildCurrentStep()
                    : FadeTransition(
                  opacity: _fadeAnim!,
                  child: SlideTransition(
                    position: _slideAnim!,
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

  // ─────────────────────────────────────────────
  // FIX: Removed Expanded from inside Column's children.
  // Use a Row with fixed-width containers + flexible spacers instead.
  // ─────────────────────────────────────────────
  Widget _buildStepIndicator() {
    final steps = ['Personal', 'Contact', 'Photo'];

    return Row(
      children: List.generate(steps.length, (i) {
        final active = i == _step;
        // ✅ FIX: Wrap the Column in Expanded directly as a Row child —
        // no extra Container/Padding wrapping Expanded.
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ FIX: Use a plain Container here — no Expanded inside Column
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
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return _personalStep();
      case 1:
        return _contactStep();
      case 2:
        return _photoStep();
      case 3:
        return _successStep();
      default:
        return _personalStep();
    }
  }

  Widget _roleChip(String role, IconData icon, String label) {
    final size = MediaQuery.of(context).size;
    final selected = _selectedRole == role;

    return GestureDetector(
      onTap: () => setState(() {
        _selectedRole = role;
        if (role == 'admin') empIdCtrl.clear();
      }),
      child: AnimatedContainer(
        width: size.width * 0.28,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? primaryColor.withOpacity(0.08) : inputBg,
          border: Border.all(
            color: selected ? primaryColor : Colors.grey.shade300,
            width: selected ? 1.8 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? primaryColor : Colors.grey, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STEP 1 — PERSONAL INFO
  // ─────────────────────────────────────────────
  Widget _personalStep() {
    // ✅ FIX: Make position a state-level variable or use a local StatefulBuilder
    // to avoid it resetting on every rebuild. Using StatefulBuilder here.
    String position = "Nursing";
    final List<String> poList = ["Nursing", "Doctor"];

    return Form(
      key: _step1Key,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Icon(Icons.person_outline_rounded, size: 70, color: primaryColor),

            const SizedBox(height: 20),
            Text("Personal Info",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textDark)),
            const SizedBox(height: 10),
            Text("Tell us about yourself",
                style: TextStyle(color: Colors.grey[500])),

            const SizedBox(height: 28),

            // ── Role Toggle ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roleChip('user', Icons.person_outline_rounded, 'User'),
                const SizedBox(width: 20),
                _roleChip('admin', Icons.admin_panel_settings_outlined, 'Admin'),
              ],
            ),

            const SizedBox(height: 24),

            _inputField(nameCtrl, "Full Name", Icons.person_outline_rounded),

            if (_selectedRole == 'user') ...[
              _inputField(empIdCtrl, "Employee ID", Icons.badge_outlined),
              const SizedBox(height: 8),

              // ✅ FIX: Wrap dropdown in StatefulBuilder so position state is local
              StatefulBuilder(
                builder: (context, setLocalState) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade100,
                          Colors.purple.shade100
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: position,
                        isExpanded: true,
                        items: poList.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(p),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setLocalState(() => position = value!);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 30),

            _button("Continue", () {
              if (_step1Key.currentState!.validate()) {
                setState(() => _step = 1);
                _playAnimation();
              }
            }),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STEP 2 — CONTACT & PASSWORD
  // ─────────────────────────────────────────────
  Widget _contactStep() {
    return Form(
      key: _step2Key,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Icon(Icons.contact_mail_outlined, size: 70, color: primaryColor),

            const SizedBox(height: 20),
            Text("Contact & Security",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textDark)),

            const SizedBox(height: 10),
            Text("Set your email & password",
                style: TextStyle(color: Colors.grey[500])),

            const SizedBox(height: 40),

            _inputField(emailCtrl, "Email Address", Icons.email_outlined),
            _inputField(phoneCtrl, "Phone Number", Icons.phone_outlined,
                keyboardType: TextInputType.phone),

            _inputField(passCtrl, "Password", Icons.lock_outline,
                isPass: true,
                obscure: _obscurePass,
                onToggle: () =>
                    setState(() => _obscurePass = !_obscurePass)),
            _inputField(
                confirmPassCtrl, "Confirm Password", Icons.lock_outline,
                isPass: true,
                obscure: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                extraValidator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  if (v != passCtrl.text) return "Passwords do not match";
                  return null;
                }),

            const SizedBox(height: 30),

            _button("Continue", () {
              if (_step2Key.currentState!.validate()) {
                setState(() => _step = 2);
                _playAnimation();
              }
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STEP 3 — PHOTO CAPTURE
  // ─────────────────────────────────────────────
  Widget _photoStep() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Icon(Icons.camera_alt_outlined, size: 70, color: primaryColor),

        const SizedBox(height: 20),
        Text("Profile Photo",
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: textDark)),

        const SizedBox(height: 10),
        Text("Take a clear front-facing photo",
            style: TextStyle(color: Colors.grey[500])),

        const SizedBox(height: 40),

        GestureDetector(
          onTap: _handleCamera,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: primaryColor.withOpacity(0.2), width: 4),
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: inputBg,
                  backgroundImage:
                  _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.camera_enhance_rounded,
                      size: 45, color: primaryColor)
                      : null,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: primaryColor,
                  child:
                  const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Text(
            _image == null ? "Tap to capture photo" : "Tap to retake",
            style: TextStyle(color: Colors.grey[500], fontSize: 13)),

        const SizedBox(height: 40),

        _button(
          isLoading ? "Registering..." : "Create Account",
          isLoading ? null : _registerUser,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SUCCESS
  // ─────────────────────────────────────────────
  Widget _successStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 90, color: primaryColor),
        const SizedBox(height: 20),
        Text("Welcome Aboard!",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textDark)),
        const SizedBox(height: 10),
        Text("Account created successfully",
            style: TextStyle(color: Colors.grey[500])),

        const SizedBox(height: 30),

        _button("Go to Login", () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // COMMON WIDGETS
  // ─────────────────────────────────────────────
  Widget _inputField(
      TextEditingController ctrl,
      String hint,
      IconData icon, {
        bool isPass = false,
        bool obscure = false,
        VoidCallback? onToggle,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? extraValidator,
      }) {
    // ✅ FIX: Removed unnecessary SingleChildScrollView wrapper around each input
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: ctrl,
        obscureText: isPass ? obscure : false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: primaryColor),
          suffixIcon: isPass
              ? IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
            ),
            onPressed: onToggle,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
        validator:
        extraValidator ?? (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _button(String text, VoidCallback? onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
      ),
    );
  }
}