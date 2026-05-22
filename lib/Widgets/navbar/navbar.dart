import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/Profile_page.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Pages/favorites/favorites_page.dart';
import 'package:imat_repo/Pages/history/history_page.dart';
import 'package:imat_repo/Pages/search/search_page.dart';
import 'package:imat_repo/Widgets/Cart.dart';
import 'package:imat_repo/Widgets/home/login_overlay_scope.dart';
import 'package:imat_repo/Widgets/navbar/cart.button.dart';
import 'package:imat_repo/model/AuthState.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'nav_icon.dart';
import 'logo.dart';

enum NavbarPage { none, favorites, history, profile }

class IMatNavbar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onLoginTap;
  final NavbarPage activePage;

  const IMatNavbar({
    super.key,
    this.onLoginTap,
    this.activePage = NavbarPage.none,
  });

  @override
  State<IMatNavbar> createState() => _IMatNavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(78);
}

class _IMatNavbarState extends State<IMatNavbar>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speech = SpeechToText();
  final TextEditingController _controller = TextEditingController();

  bool _isListening = false; // röd mic + stopp
  late AnimationController _pulseController; // puls

  @override
  void initState() {
    super.initState();

    _pulseController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 900),
          lowerBound: 0.8,
          upperBound: 1.2,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _pulseController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _pulseController.forward();
          }
        });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (!available) return;

    setState(() {
      _isListening = true;
    });

    _pulseController.forward();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Lyssnar…")));

    _speech.listen(
      onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });

        if (result.finalResult) {
          _stopListening();
          _onSearchSubmitted(context, result.recognizedWords);
        }
      },
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
    _pulseController.stop();
    _pulseController.value = 1.0;
  }

  void _onFavoritesTapLoggedIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesPage()),
    );
  }

  void _onHistoryTapLoggedIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistoryPage()),
    );
  }

  void _onUserTapLoggedIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  void _onSearchSubmitted(BuildContext context, String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchPage(query: trimmedQuery)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginOverlay = LoginOverlayScope.maybeOf(context);
    final bool isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final ShowLoginOverlay showLogin =
        loginOverlay?.showLoginOverlay ??
        ({LoginSuccessAction? onLoginSuccess}) {
          widget.onLoginTap?.call();
        };

    return AppBar(
      backgroundColor: IMatColors.green,
      elevation: 0,
      toolbarHeight: 78,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen = constraints.maxWidth < 900;

          return Row(
            children: [
              const SizedBox(width: 12),

              // Klickbar logga som leder till startsidan
              IMatLogo(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),

              const SizedBox(width: 24),

              // Kortare sökfält (mer luftigt)
              Expanded(
                flex: isSmallScreen ? 2 : 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: SizedBox(
                        height: 46,
                        child: TextField(
                          controller: _controller,
                          style: IMatText.bodyM,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (query) {
                            _onSearchSubmitted(context, query);
                          },
                          decoration: InputDecoration(
                            hintText: "Sök varor...",
                            hintStyle: IMatText.bodyM.copyWith(
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: IMatColors.white,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 28,
                            ),

                            // ⭐ RÖSTKNAPP MED PULS + RÖD FÄRG + STOPP
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _isListening
                                    ? _stopListening()
                                    : _startListening();
                              },
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _isListening
                                        ? _pulseController.value
                                        : 1.0,
                                    child: Icon(
                                      _isListening ? Icons.mic : Icons.mic_none,
                                      color: _isListening
                                          ? Colors.red
                                          : Colors.grey,
                                      size: 28,
                                    ),
                                  );
                                },
                              ),
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Ikoner
              CartButton(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const Cart(),
                    ),
                  );
                },
              ),

              NavIcon(
                selected: widget.activePage == NavbarPage.favorites,
                icon: widget.activePage == NavbarPage.favorites
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: "Favoriter",
                onTap: isLoggedIn
                    ? () => _onFavoritesTapLoggedIn(context)
                    : () => showLogin(
                        onLoginSuccess: () => _onFavoritesTapLoggedIn(context),
                      ),
              ),

              NavIcon(
                selected: widget.activePage == NavbarPage.history,
                icon: Icons.history,
                label: "Historik",
                onTap: isLoggedIn
                    ? () => _onHistoryTapLoggedIn(context)
                    : () => showLogin(
                        onLoginSuccess: () => _onHistoryTapLoggedIn(context),
                      ),
              ),

              NavIcon(icon: Icons.help_outline, label: "Hjälp", onTap: () {}),

              NavIcon(
                selected: widget.activePage == NavbarPage.profile,
                icon: isLoggedIn ? Icons.account_circle : Icons.person_outline,
                label: isLoggedIn ? "Användare" : "Logga in",
                onTap: isLoggedIn
                    ? () => _onUserTapLoggedIn(context)
                    : () => showLogin(),
              ),

              const SizedBox(width: 12),
            ],
          );
        },
      ),
    );
  }
}
