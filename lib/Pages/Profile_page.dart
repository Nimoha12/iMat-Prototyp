import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/profile_header.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Logged_in_Profile_View.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Not_logged_in_View.dart';
import 'package:imat_repo/model/AuthState.dart';
import 'package:imat_repo/model/Profile/profile_section.dart';

import 'package:provider/provider.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  ProfileSection selectedSection =
      ProfileSection.overview;

  @override
  Widget build(BuildContext context) {
    final authState =
        context.watch<AuthState>();

    return Scaffold(
      appBar: const IMatNavbar(
  activePage: NavbarPage.profile,
),
      backgroundColor:
          const Color(0xFFF6F3ED),
      body: authState.isLoggedIn
          ? Column(
              children: [
                ProfileHeader(
                  selectedSection: selectedSection,
                  onTabSelected: (section) {
                    setState(() {
                      selectedSection = section;
                    });
                  },
                ),
                Expanded(
                  child:
                      LoggedInProfileView(
                    selectedSection:
                        selectedSection,
                    onTabSelected:
                        (section) {
                      setState(() {
                        selectedSection =
                            section;
                      });
                    },
                  ),
                ),
              ],
            )
          : const NotLoggedInView(),
    );
  }
}