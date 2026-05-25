import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/navbar/navbar.dart';

class IMatScaffold extends StatelessWidget {
  final Widget body;
  final NavbarPage activePage;
  final String? searchQuery;
  final bool highlightSearchQuery;

  const IMatScaffold({
    super.key,
    required this.body,
    this.activePage = NavbarPage.none,
    this.searchQuery,
    this.highlightSearchQuery = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IMatNavbar(
        activePage: activePage,
        searchQuery: searchQuery,
        highlightSearchQuery: highlightSearchQuery,
      ), // din befintliga navbar
      body: body,
    );
  }
}
