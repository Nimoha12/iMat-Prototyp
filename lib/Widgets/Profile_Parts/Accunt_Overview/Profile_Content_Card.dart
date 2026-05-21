import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Accunt_Overview/EditProfile_Button.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Accunt_Overview/Profile_Content_Header.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Accunt_Overview/editable_customer_field.dart';

class ProfileContentCard extends StatefulWidget {
  const ProfileContentCard({super.key});

  @override
  State<ProfileContentCard> createState() =>
      _ProfileContentCardState();
}

class _ProfileContentCardState
    extends State<ProfileContentCard> {

  bool isEditing = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      constraints: const BoxConstraints(maxWidth: 760),
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          //////////////////////////////////////////////////////
          /// HEADER
          //////////////////////////////////////////////////////

          ProfileContentHeader(
            editButton: EditProfileButton(
              onPressed: () {

                setState(() {
                  isEditing = !isEditing;
                });

              },
            ),
          ),

          const SizedBox(height: 28),

          //////////////////////////////////////////////////////
          /// FIELDS
          //////////////////////////////////////////////////////

          EditableCustomerField(
            title: "Förnamn",
            customerKey:
                CustomerField.firstName,
            isEditing: isEditing,
          ),

          const SizedBox(height: 20),

          EditableCustomerField(
            title: "Efternamn",
            customerKey:
                CustomerField.lastName,
            isEditing: isEditing,
          ),

          const SizedBox(height: 20),

          EditableCustomerField(
            title: "Telefonnummer",
            customerKey:
                CustomerField.phoneNumber,
            isEditing: isEditing,
          ),
        ],
      ),
    );
  }
}