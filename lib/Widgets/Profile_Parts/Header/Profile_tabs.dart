import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/profile_tab_button.dart';

import 'package:imat_repo/model/Profile/profile_section.dart';


class ProfileTabs extends StatelessWidget {
  final ProfileSection selectedSection;

  final Function(ProfileSection)
      onTabSelected;

  const ProfileTabs({
    super.key,
    required this.selectedSection,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      color: Colors.white,
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          ProfileTabButton(
            title: 'Kontoöversikt',
            icon: Icons.person,
            isSelected:
                selectedSection ==
                    ProfileSection.overview,
            onPressed: () {
              onTabSelected(
                ProfileSection.overview,
              );
            },
          ),
          const SizedBox(width: 24),
          ProfileTabButton(
            title: 'Leveransadresser',
            icon: Icons.location_on,
            isSelected:
                selectedSection ==
                    ProfileSection.addresses,
            onPressed: () {
              onTabSelected(
                ProfileSection.addresses,
              );
            },
          ),
          const SizedBox(width: 24),
          ProfileTabButton(
            title: 'Inställningar',
            icon: Icons.settings,
            isSelected:
                selectedSection ==
                    ProfileSection.settings,
            onPressed: () {
              onTabSelected(
                ProfileSection.settings,
              );
            },
          ),
        ],
      ),
    );
  }
}