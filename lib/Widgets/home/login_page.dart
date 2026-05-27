import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/model/imat/user.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

import 'hover_close_icon.dart';

class LoginOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onLoginSuccess;

  const LoginOverlay({super.key, required this.onClose, this.onLoginSuccess});

  @override
  State<LoginOverlay> createState() => _LoginOverlayState();
}

class _LoginOverlayState extends State<LoginOverlay> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSending = false;
  String? _errorMessage;

  bool get _canLogin =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    void onFieldsChanged() => setState(() {});
    _emailController.addListener(onFieldsChanged);
    _passwordController.addListener(onFieldsChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onTap: _isSending ? null : widget.onClose,
        child: Material(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 430,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 32),
                        Expanded(
                          child: Text(
                            'Logga in',
                            textAlign: TextAlign.center,
                            style: IMatText.h1,
                          ),
                        ),
                        HoverCloseIcon(
                          onClose: _isSending ? () {} : widget.onClose,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _LoginLabeledField(
                      label: 'E-postadress',
                      hint: 'din.epost@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !_isSending,
                    ),
                    const SizedBox(height: 14),
                    _LoginLabeledField(
                      label: 'Lösenord',
                      hint: 'Ange ditt lösenord',
                      controller: _passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _tryLogin(),
                      enabled: !_isSending,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: IMatText.bodyS.copyWith(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed:
                            _isSending || !_canLogin ? null : _tryLogin,
                        style: _primaryButtonStyle(),
                        child: Text(_isSending ? 'Loggar in…' : 'Logga in'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: IMatColors.green,
      disabledBackgroundColor: IMatColors.border,
      foregroundColor: IMatColors.white,
      disabledForegroundColor: IMatColors.textSecondary,
      elevation: 0,
      textStyle: IMatText.bodyM.copyWith(fontWeight: FontWeight.w800),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Future<void> _tryLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Fyll i e-post och lösenord';
      });
      return;
    }

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    final iMat = context.read<ImatDataHandler>();
    iMat.setUser(User(email, password));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSending = false;
    });

    widget.onLoginSuccess?.call();
    widget.onClose();
  }
}

class _LoginLabeledField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  const _LoginLabeledField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: IMatText.bodyS.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 54,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            enabled: enabled,
            style: IMatText.bodyM,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: IMatText.bodyM.copyWith(color: Colors.grey.shade500),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF9C9C9C)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF9C9C9C)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: IMatColors.green, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
