

import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Accunt_Overview/account_overview_page.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Delivery/delivery_addresses_page.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Settings_Page/settings_page.dart';
import 'package:imat_repo/model/Profile/profile_section.dart';

class ProfilePageContent
    extends StatelessWidget {

  final ProfileSection selectedSection;

  const ProfilePageContent({
    super.key,
    required this.selectedSection,
  });

  @override
  Widget build(BuildContext context) {

    switch (selectedSection) {

      case ProfileSection.overview:
        return const AccountOverviewPage();

      case ProfileSection.addresses:
        return const DeliveryAddressesPage();

      case ProfileSection.settings:
        return const SettingsPage();
    }
  }
}