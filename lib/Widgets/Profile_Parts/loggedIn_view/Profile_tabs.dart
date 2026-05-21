import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/profile_tab_button.dart';
import 'package:imat_repo/model/Profile/profile_section.dart';




class ProfileTabs
    extends StatelessWidget {

  ////////////////////////////////////////////////////////////
  /// CURRENT SELECTED TAB
  ////////////////////////////////////////////////////////////

  final ProfileSection selectedSection;

  ////////////////////////////////////////////////////////////
  /// CALLBACK
  ////////////////////////////////////////////////////////////

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
      height: 120,

      color: Colors.white,

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          //////////////////////////////////////////////////////
          /// KONTOÖVERSIKT
          //////////////////////////////////////////////////////

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

          const SizedBox(width: 40),

          //////////////////////////////////////////////////////
          /// LEVERANSADRESSER
          //////////////////////////////////////////////////////

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

          const SizedBox(width: 40),

          //////////////////////////////////////////////////////
          /// INSTÄLLNINGAR
          //////////////////////////////////////////////////////

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