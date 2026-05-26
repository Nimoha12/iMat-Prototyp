import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Navigation/navbar.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Costumer_card.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Header/LogoutButton%20.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Payment_Card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _editing = false;

  final GlobalKey<CustomerCardState> _customerKey = GlobalKey();
  final GlobalKey<PaymentCardState> _paymentKey = GlobalKey();

  void _toggleEditing() {
    if (_editing) {
      _customerKey.currentState?.saveCustomer();
      _paymentKey.currentState?.saveCard();
    }

    setState(() {
      _editing = !_editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3ED),

      appBar: const IMatNavbar(
        activePage: NavbarPage.profile,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),

          child: Column(
            children: [
             //header

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

                      const SizedBox(width: 36),

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

              //content

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                  children: [
                    //customer

                    Expanded(
                      child: CustomerCard(
                        key: _customerKey,
                        isEditing: _editing,
                      ),
                    ),

                    const SizedBox(width: 24),

                    //payment column

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,

                        children: [
                          Align(
  alignment: Alignment.center,
  child: SizedBox(
    width: 400, // adjust as needed
    height: 72,
    child: ElevatedButton.icon(
      onPressed: _toggleEditing,
      icon: Icon(
        _editing ? Icons.save : Icons.edit,
        size: 28,
      ),
      label: Text(
        _editing ? 'Spara' : 'Redigera',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B7B67),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  ),
),

                          const SizedBox(height: 24),

                          Expanded(
                            child: PaymentCard(
                              key: _paymentKey,
                              isEditing: _editing,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}