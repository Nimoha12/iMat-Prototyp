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
  final String? searchQuery;
  final bool highlightSearchQuery;

  const IMatNavbar({
    super.key,
    this.onLoginTap,
    this.activePage = NavbarPage.none,
    this.searchQuery,
    this.highlightSearchQuery = false,
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
  final FocusNode _searchFocusNode = FocusNode();

  bool _isListening = false;
  bool _isSearchFlashActive = false;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _controller.text = widget.searchQuery ?? '';

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.85,
      upperBound: 1.15,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _pulseController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _pulseController.forward();
        }
      });

    if (widget.highlightSearchQuery &&
        _controller.text.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _flashSearchField();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchFocusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant IMatNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchQuery != oldWidget.searchQuery) {
      _controller.text = widget.searchQuery ?? '';
    }

    if (widget.highlightSearchQuery !=
            oldWidget.highlightSearchQuery ||
        widget.searchQuery != oldWidget.searchQuery) {
      if (widget.highlightSearchQuery &&
          _controller.text.trim().isNotEmpty) {
        _flashSearchField();
      }
    }
  }

  void _flashSearchField() {
    if (!mounted) return;

    setState(() {
      _isSearchFlashActive = true;
    });

    Future.delayed(const Duration(milliseconds: 180), () {
      if (!mounted) return;

      setState(() {
        _isSearchFlashActive = false;
      });
    });
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();

    if (!available) return;
    if (!mounted) return;

    setState(() {
      _isListening = true;
    });

    _pulseController.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Lyssnar…"),
      ),
    );

    _speech.listen(
      onResult: (result) {
        if (!mounted) return;

        setState(() {
          _controller.text = result.recognizedWords;
        });

        if (result.finalResult) {
          _stopListening();
          _onSearchSubmitted(
            context,
            result.recognizedWords,
          );
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
      MaterialPageRoute(
        builder: (_) => const FavoritesPage(),
      ),
    );
  }

  void _onHistoryTapLoggedIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HistoryPage(),
      ),
    );
  }

  void _onUserTapLoggedIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      ),
    );
  }

  void _onSearchSubmitted(
    BuildContext context,
    String query,
  ) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) return;

    setState(() {
      _controller.text = trimmedQuery;
    });

    _flashSearchField();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchPage(
          query: trimmedQuery,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginOverlay =
        LoginOverlayScope.maybeOf(context);

    final bool isLoggedIn =
        context.watch<AuthState>().isLoggedIn;

    final ShowLoginOverlay showLogin =
        loginOverlay?.showLoginOverlay ??
            ({
              LoginSuccessAction? onLoginSuccess,
            }) {
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
          final bool isSmallScreen =
              constraints.maxWidth < 900;

          return Row(
            children: [
              const SizedBox(width: 12),

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

              Expanded(
                flex: isSmallScreen ? 2 : 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 620,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 700,
                        ),
                        curve: Curves.easeOutCubic,
                        height: 46,
                        decoration: BoxDecoration(
                          color: _isSearchFlashActive
                              ? const Color.fromARGB(255, 32, 32, 32)
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _searchFocusNode,
                          cursorColor: IMatColors.black,
                          textInputAction:
                              TextInputAction.search,

                          style: IMatText.bodyM.copyWith(
                            color: IMatColors.black,
                            fontSize: 25,
                            decoration:
                                TextDecoration.none,
                          ),

                          onSubmitted: (query) {
                            _onSearchSubmitted(
                              context,
                              query,
                            );
                          },

                          decoration: InputDecoration(
                            hintText: "Sök varor...",

                            hintStyle:
                                IMatText.bodyM.copyWith(
                              color: const Color.fromARGB(255, 53, 53, 53),
                            ),

                            prefixIcon: const Icon(
                              Icons.search,
                              color: IMatColors.black,
                              size: 28,
                            ),

                            suffixIcon: GestureDetector(
                              onTap: () {
                                _isListening
                                    ? _stopListening()
                                    : _startListening();
                              },
                              child: AnimatedBuilder(
                                animation:
                                    _pulseController,
                                builder:
                                    (context, child) {
                                  return Transform.scale(
                                    scale: _isListening
                                        ? _pulseController
                                            .value
                                        : 1.0,
                                    child: Icon(
                                      _isListening
                                          ? Icons.mic
                                          : Icons.mic_none,
                                      color: _isListening
                                          ? Colors.red
                                          : IMatColors
                                              .black,
                                      size: 28,
                                    ),
                                  );
                                },
                              ),
                            ),

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),

                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              CartButton(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder:
                          (
                            context,
                            animation,
                            secondaryAnimation,
                          ) => const Cart(),
                    ),
                  );
                },
              ),

              NavIcon(
                selected:
                    widget.activePage ==
                    NavbarPage.favorites,
                icon:
                    widget.activePage ==
                            NavbarPage.favorites
                        ? Icons.favorite
                        : Icons.favorite_border,
                label: "Favoriter",
                onTap: isLoggedIn
                    ? () => _onFavoritesTapLoggedIn(
                          context,
                        )
                    : () => showLogin(
                          onLoginSuccess: () =>
                              _onFavoritesTapLoggedIn(
                            context,
                          ),
                        ),
              ),

              NavIcon(
                selected:
                    widget.activePage ==
                    NavbarPage.history,
                icon: Icons.history,
                label: "Historik",
                onTap: isLoggedIn
                    ? () =>
                        _onHistoryTapLoggedIn(context)
                    : () => showLogin(
                          onLoginSuccess: () =>
                              _onHistoryTapLoggedIn(
                            context,
                          ),
                        ),
              ),

              NavIcon(
                icon: Icons.help_outline,
                label: "Hjälp",
                onTap: () {},
              ),

              NavIcon(
                selected:
                    widget.activePage ==
                    NavbarPage.profile,
                icon: isLoggedIn
                    ? Icons.account_circle
                    : Icons.person_outline,
                label: isLoggedIn
                    ? "Användare"
                    : "Logga in",
                onTap: isLoggedIn
                    ? () => _onUserTapLoggedIn(
                          context,
                        )
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