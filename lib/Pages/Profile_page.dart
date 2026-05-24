import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Costumer_card.dart';

import 'package:imat_repo/Widgets/Profile_Parts/Header/LogoutButton%20.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Payment_Card.dart';

import 'package:imat_repo/Widgets/navbar/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool editingCustomer = false;
  bool editingPayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3ED),

      appBar: const IMatNavbar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),

          child: Column(
            children: [

              //////////////////////////////////////////////////////
              /// HEADER
              //////////////////////////////////////////////////////

              Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  children: [

    Row(
      children: [

        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.close,
            size: 42,
          ),
        ),

        const SizedBox(width: 28),

        const Text(
          "Min profil",

          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),

    const LogoutButton(),
  ],
),

              const SizedBox(height: 40),

              //////////////////////////////////////////////////////
              /// CONTENT
              //////////////////////////////////////////////////////

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Expanded(
                    child: CustomerCard(
                      isEditing:
                          editingCustomer,

                      onEditPressed: () {
                        setState(() {
                          editingCustomer =
                              !editingCustomer;
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 24),

                  Expanded(
                    child: PaymentCard(
                      isEditing:
                          editingPayment,

                      onEditPressed: () {
                        setState(() {
                          editingPayment =
                              !editingPayment;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}