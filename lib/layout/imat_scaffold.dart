import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Navigation/breadcrumb_bar.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';

class IMatScaffold extends StatelessWidget {
  final Widget body;
  final NavbarPage activePage;
  final String? searchQuery;
  final bool highlightSearchQuery;
  final List<BreadcrumbItem> breadcrumbContext;

  const IMatScaffold({
    super.key,
    required this.body,
    this.activePage = NavbarPage.none,
    this.searchQuery,
    this.highlightSearchQuery = false,
    this.breadcrumbContext = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IMatNavbar(
        activePage: activePage,
        searchQuery: searchQuery,
        highlightSearchQuery: highlightSearchQuery,
        breadcrumbContext: breadcrumbContext,
      ),
      body: body,
    );
  }
}
