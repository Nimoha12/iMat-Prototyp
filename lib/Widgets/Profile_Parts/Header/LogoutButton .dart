import 'package:flutter/material.dart';
import 'package:imat_repo/Theme/imat_theme.dart';
import 'package:imat_repo/Widgets/Navigation/module_navigation.dart';
import 'package:imat_repo/model/AuthState.dart';
import 'package:provider/provider.dart';

const String logoutButtonText = 'Logga ut';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  
  OverlayEntry? _warningEntry;

  

  void _toggleWarning() {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (dialogContext) {
      return Stack(
        children: [
          Positioned(
            top: 165,
            right: 90,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: IMatColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Logga ut?',
                      textAlign: TextAlign.center,
                      style: IMatText.bodyL.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Du kommer behöva logga in igen för att komma åt profil, favoriter och historik.',
                      textAlign: TextAlign.center,
                      style: IMatText.bodyS.copyWith(
                        color: IMatColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 42,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Nej'),
                          ),
                        ),

                        const SizedBox(width: 10),

                        SizedBox(
                          width: 100,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);

                              context
                                  .read<AuthState>()
                                  .logout();

                              ModuleNavigation.exit(
                                this.context,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  IMatColors.danger,
                              foregroundColor:
                                  Colors.white,
                              elevation: 0,
                            ),
                            child: const Text('Ja'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

  void _removeWarning() {
    _warningEntry?.remove();
    _warningEntry = null;
  }

  void _logout() {
    _removeWarning();

    context.read<AuthState>().logout();

    ModuleNavigation.exit(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 118,
        height: 48,
        child: OutlinedButton(
          onPressed: _toggleWarning,
          style: IMatButton.outlinedRed.copyWith(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 14),
            ),
            textStyle: WidgetStateProperty.all(
              IMatText.bodyS.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          child: const Text(logoutButtonText),
        ),
    );
  }
}

class _LogoutWarning extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _LogoutWarning({
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: IMatColors.white,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: IMatColors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Logga ut?',
              style: IMatText.bodyS.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 68,
                  height: 40,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Nej'),
                  ),
                ),

                const SizedBox(width: 6),

                SizedBox(
                  width: 68,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: IMatColors.danger,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Ja'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}