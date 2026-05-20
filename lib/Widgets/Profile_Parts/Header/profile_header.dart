import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/CloseProfile_Button.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/LogoutButton%20.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Profile_Title.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/Profile_tabs.dart';
import 'package:imat_repo/model/Profile/profile_section.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileSection selectedSection;
  final Function(ProfileSection) onTabSelected;

  const ProfileHeader({
    super.key,
    required this.selectedSection,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      color: Colors.white,

      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 10,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          const CloseProfileButton(),

          const SizedBox(width: 16),

          const ProfileTitle(),
          const SizedBox(width: 32),

          Expanded(
            child: ProfileTabs(
              selectedSection: selectedSection,
              onTabSelected: onTabSelected,
            ),
          ),

          const SizedBox(width: 24),
          LogoutButton(),
        ],
      ),
    );
  }
}