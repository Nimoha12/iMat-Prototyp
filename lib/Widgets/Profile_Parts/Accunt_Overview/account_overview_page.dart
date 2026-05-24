import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/profile_page.dart';




class AccountOverviewPage extends StatelessWidget {

  const AccountOverviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),

      child: Center(
        child: Container(
          constraints:
              const BoxConstraints(
            maxWidth: 820,
          ),
          child: const ProfilePage(),
        ),
      ),
    );
  }
}