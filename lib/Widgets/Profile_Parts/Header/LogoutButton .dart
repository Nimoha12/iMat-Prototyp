import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/home_page.dart';
import 'package:imat_repo/Theme/imat_theme.dart';
import 'package:imat_repo/model/AuthState.dart';
import 'package:provider/provider.dart';

const String logoutButtonText = 'Logga ut';
const String logoutWarningText = 'Vill du logga ut?';
const String logoutConfirmText = 'Ja';
const String logoutCancelText = 'Nej';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _warningEntry;

  @override
  void dispose() {
    _removeWarning();
    super.dispose();
  }

  void _toggleWarning() {
    if (_warningEntry != null) {
      _removeWarning();
      return;
    }

    _warningEntry = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 10),
          child: SizedBox(
            width: 268,
            child: _LogoutWarning(onCancel: _removeWarning, onConfirm: _logout),
          ),
        );
      },
    );

    Overlay.of(context).insert(_warningEntry!);
  }

  void _removeWarning() {
    _warningEntry?.remove();
    _warningEntry = null;
  }

  void _logout() {
    _removeWarning();
    context.read<AuthState>().logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: 118,
        height: 48,
        child: OutlinedButton(
          onPressed: _toggleWarning,
          style: IMatButton.outlinedRed.copyWith(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 14),
            ),
            textStyle: WidgetStateProperty.all(
              IMatText.bodyS.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          child: const Text(logoutButtonText),
        ),
      ),
    );
  }
}

class _LogoutWarning extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _LogoutWarning({required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        container: true,
        liveRegion: true,
        label: logoutWarningText,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: IMatColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: IMatColors.danger, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                logoutWarningText,
                style: IMatText.bodyM.copyWith(
                  fontWeight: FontWeight.w800,
                  color: IMatColors.black,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: IMatColors.black,
                        side: const BorderSide(
                          color: IMatColors.border,
                          width: 2,
                        ),
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: IMatText.bodyS.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      child: const Text(logoutCancelText),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: IMatColors.danger,
                        foregroundColor: IMatColors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: IMatText.bodyS.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      child: const Text(logoutConfirmText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
