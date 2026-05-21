import 'package:flutter/material.dart';
import 'package:imat_repo/model/Profile/profile_page_content.dart';
import 'package:imat_repo/model/Profile/profile_section.dart';




class LoggedInProfileView
    extends StatelessWidget {

  final ProfileSection selectedSection;

  final Function(ProfileSection)
      onTabSelected;

  const LoggedInProfileView({
    super.key,
    required this.selectedSection,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ProfilePageContent(
            selectedSection:
                selectedSection,
          ),
        ),
      ],
    );
  }
}