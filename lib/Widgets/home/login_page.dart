import 'package:flutter/material.dart';
import 'package:imat_repo/model/imat/user.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

import 'hover_close_icon.dart';

class LoginOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const LoginOverlay({super.key, required this.onClose});

  @override
  State<LoginOverlay> createState() => _LoginOverlayState();
}

class _LoginOverlayState extends State<LoginOverlay> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSending = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        // Klick på mörka bakgrunden
        onTap: _isSending ? null : widget.onClose,

        child: Material(
          color: Colors.black.withValues(alpha: 0.5),

          child: Center(
            child: GestureDetector(
              // Hindrar klick i rutan från att bubbla vidare
              onTap: () {},

              child: Container(
                width: 560,
                padding: const EdgeInsets.all(40),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TOPPRAD
                    Row(
                      children: [
                        const SizedBox(width: 48),
                        const Expanded(
                          child: Text(
                            "Logga in",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        HoverCloseIcon(
                          onClose: _isSending ? () {} : widget.onClose,
                        ),
                        // För balans så texten hålls centrerad
                      ],
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 28),
                      decoration: InputDecoration(
                        hintText: "E-post",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _passwordController,
                      style: TextStyle(fontSize: 28),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _sendLogin(),
                      decoration: InputDecoration(
                        hintText: "Lösenord",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _isSending ? null : _sendLogin,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B8A73),

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        elevation: 0,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const SizedBox(width: 10),

                          Text(
                            _isSending ? "skickar..." : "logga in",

                            style: const TextStyle(fontSize: 38),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, size: 38),
                        ],
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "fel användarnamn eller lösenord";
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

    widget.onClose();
  }
}
