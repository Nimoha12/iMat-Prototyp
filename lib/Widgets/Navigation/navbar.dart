import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/Profile_page.dart';
import 'package:imat_repo/Theme/imat_colors.dart';
import 'package:imat_repo/Theme/imat_text.dart';
import 'package:imat_repo/Pages/favorites/favorites_page.dart';
import 'package:imat_repo/Pages/history/history_page.dart';
import 'package:imat_repo/Pages/search/search_page.dart';
import 'package:imat_repo/Widgets/Cart_Parts/Cart.dart';
import 'package:imat_repo/Widgets/Navigation/breadcrumb_bar.dart';
import 'package:imat_repo/Widgets/Navigation/cart.button.dart';
import 'package:imat_repo/Widgets/home/login_overlay_scope.dart';
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
  final List<BreadcrumbItem> breadcrumbContext;

  const IMatNavbar({
    super.key,
    this.onLoginTap,
    this.activePage = NavbarPage.none,
    this.searchQuery,
    this.highlightSearchQuery = false,
    this.breadcrumbContext = const [],
  });

  @override
  State<IMatNavbar> createState() => _IMatNavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(88); // något högre för större innehåll
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
      _controller.clear();
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

  NavbarPage _resolvedActivePage(BuildContext context) {
    if (widget.activePage != NavbarPage.none) {
      return widget.activePage;
    }

    final routeName = ModalRoute.of(context)?.settings.name;
    if (routeName == FavoritesPage.routeName) {
      return NavbarPage.favorites;
    }
    if (routeName == HistoryPage.routeName) {
      return NavbarPage.history;
    }
    if (routeName == ProfilePage.routeName) {
      return NavbarPage.profile;
    }

    return NavbarPage.none;
  }

  bool _isOnNavbarPage(BuildContext context) {
    return _resolvedActivePage(context) != NavbarPage.none;
  }

  void _navigateToNavbarPage(
    BuildContext context,
    Widget page,
    String routeName,
  ) {
    final route = MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => page,
    );

    if (_isOnNavbarPage(context)) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }

  void _onFavoritesTapLoggedIn(BuildContext context) {
    if (_resolvedActivePage(context) == NavbarPage.favorites) {
      return;
    }

    _navigateToNavbarPage(
      context,
      const FavoritesPage(),
      FavoritesPage.routeName,
    );
  }

  void _onHistoryTapLoggedIn(BuildContext context) {
    if (_resolvedActivePage(context) == NavbarPage.history) {
      return;
    }

    _navigateToNavbarPage(
      context,
      const HistoryPage(),
      HistoryPage.routeName,
    );
  }

  void _onUserTapLoggedIn(BuildContext context) {
    if (_resolvedActivePage(context) == NavbarPage.profile) {
      return;
    }

    _navigateToNavbarPage(
      context,
      const ProfilePage(),
      ProfilePage.routeName,
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

    final route = MaterialPageRoute<void>(
      settings: const RouteSettings(name: SearchPage.routeName),
      builder: (_) => SearchPage(
        query: trimmedQuery,
        breadcrumbContext: widget.breadcrumbContext,
      ),
    );

    final alreadyOnSearch =
        ModalRoute.of(context)?.settings.name == SearchPage.routeName;

    if (alreadyOnSearch) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
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

    final activePage = _resolvedActivePage(context);

    return AppBar(
      backgroundColor: IMatColors.green,
      elevation: 0,
      toolbarHeight: 88,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen =
              constraints.maxWidth < 900;

          return Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 50),
                  IMatLogo(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                  ),
                  
                ],
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  _SearchBarExpanded(
                    isSmallScreen: isSmallScreen,
                    controller: _controller,
                    searchFocusNode: _searchFocusNode,
                    pulseController: _pulseController,
                    isSearchFlashActive: _isSearchFlashActive,
                    isListening: _isListening,
                    onSubmitted: (query) =>
                        _onSearchSubmitted(context, query),
                    onMicTap: () {
                      _isListening
                          ? _stopListening()
                          : _startListening();
                    },
                  ),
                  const SizedBox(width: 30),
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
                  const SizedBox(width: 30),
                  NavIcon(
                    selected: activePage == NavbarPage.favorites,
                    icon: activePage == NavbarPage.favorites
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
                  const SizedBox(width: 30),
                  NavIcon(
                    selected: activePage == NavbarPage.history,
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
                  const SizedBox(width: 30),
                  NavIcon(
                    icon: Icons.help_outline,
                    label: "Hjälp",
                    onTap: () {},
                  ),
                  const SizedBox(width: 30),
                  NavIcon(
                    selected: activePage == NavbarPage.profile,
                    icon: isLoggedIn
                        ? Icons.account_circle
                        : Icons.person_outline,
                    label: isLoggedIn
                        ? "Profil"
                        : "Logga in",
                    onTap: isLoggedIn
                        ? () => _onUserTapLoggedIn(
                              context,
                            )
                        : () => showLogin(),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchBarExpanded extends StatelessWidget {
  final bool isSmallScreen;
  final TextEditingController controller;
  final FocusNode searchFocusNode;
  final AnimationController pulseController;
  final bool isSearchFlashActive;
  final bool isListening;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onMicTap;

  const _SearchBarExpanded({
    required this.isSmallScreen,
    required this.controller,
    required this.searchFocusNode,
    required this.pulseController,
    required this.isSearchFlashActive,
    required this.isListening,
    required this.onSubmitted,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isSmallScreen ? 200 : 300,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        height: 46,
        decoration: BoxDecoration(
          color: isSearchFlashActive
              ? const Color.fromARGB(255, 32, 32, 32)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          focusNode: searchFocusNode,
          cursorColor: IMatColors.black,
          textInputAction: TextInputAction.search,
          style: IMatText.bodyM.copyWith(
            color: IMatColors.black,
            fontSize: 25,
            decoration: TextDecoration.none,
          ),
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: "Sök varor...",
            hintStyle: IMatText.bodyM.copyWith(
              color: const Color.fromARGB(255, 53, 53, 53),
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: IMatColors.black,
              size: 28,
            ),
            suffixIcon: GestureDetector(
              onTap: onMicTap,
              child: AnimatedBuilder(
                animation: pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isListening ? pulseController.value : 1.0,
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? Colors.red : IMatColors.black,
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
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}