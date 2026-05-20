import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Delivery/add_address_form.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Delivery/empty_address_view.dart';


class DeliveryAddressesPage
    extends StatefulWidget {

  const DeliveryAddressesPage({
    super.key,
  });

  @override
  State<DeliveryAddressesPage>
      createState() =>
          _DeliveryAddressesPageState();
}

class _DeliveryAddressesPageState
    extends State<DeliveryAddressesPage> {

  bool isAddingAddress = false;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),

      child: Center(
        child: Container(
          constraints:
              const BoxConstraints(
            maxWidth: 1000,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                children: [

                  const Text(
                    'Mina leveransadresser',

                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF3F8A73),
                    ),

                    onPressed: () {

                      setState(() {
                        isAddingAddress = true;
                      });
                    },

                    child: const Text(
                      '+ Lägg till adress',
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              isAddingAddress
                  ? AddAddressForm(
                      onCancel: () {

                        setState(() {
                          isAddingAddress = false;
                        });
                      },
                    )
                  : const EmptyAddressView(),
            ],
          ),
        ),
      ),
    );
  }
}
