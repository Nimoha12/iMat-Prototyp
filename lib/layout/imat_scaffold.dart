import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';

class IMatScaffold extends StatelessWidget {
  final Widget body;

  const IMatScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IMatNavbar(), // gemensam navbar
      body: body,
    );
  }
}
