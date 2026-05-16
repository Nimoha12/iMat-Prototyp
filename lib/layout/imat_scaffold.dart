import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/navbar/navbar.dart';

class IMatScaffold extends StatelessWidget {
  final Widget body;

  const IMatScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IMatNavbar(), // din befintliga navbar
      body: body,
    );
  }
}
