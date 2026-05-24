import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Accunt_Overview/editable_customer_field.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class CustomerCard extends StatefulWidget {
  final bool isEditing;
  final VoidCallback onEditPressed;

  const CustomerCard({
    super.key,
    required this.isEditing,
    required this.onEditPressed,
  });

  @override
  State<CustomerCard> createState() =>
      _CustomerCardState();
}

class _CustomerCardState
    extends State<CustomerCard> {

  bool initialized = false;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController postCodeController;
  late TextEditingController cityController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {

      final customer =
          context.read<ImatDataHandler>()
                 .getCustomer();

      firstNameController =
          TextEditingController(
            text: customer.firstName,
          );

      lastNameController =
          TextEditingController(
            text: customer.lastName,
          );

      emailController =
          TextEditingController(
            text: customer.email,
          );

      phoneController =
          TextEditingController(
            text: customer.mobilePhoneNumber,
          );

      addressController =
          TextEditingController(
            text: customer.address,
          );

      postCodeController =
          TextEditingController(
            text: customer.postCode,
          );

      cityController =
          TextEditingController(
            text: customer.postAddress,
          );

      initialized = true;
    }
  }

  void saveCustomer() {

    final handler =
        context.read<ImatDataHandler>();

    final customer =
        handler.getCustomer();

    customer.firstName =
        firstNameController.text;

    customer.lastName =
        lastNameController.text;

    customer.email =
        emailController.text;

    customer.mobilePhoneNumber =
        phoneController.text;

    customer.address =
        addressController.text;

    customer.postCode =
        postCodeController.text;

    customer.postAddress =
        cityController.text;

    handler.setCustomer(customer);
  }

  @override
  void dispose() {

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    postCodeController.dispose();
    cityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(24),
      ),

      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  "Konto & Leverans",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                ElevatedButton(
                  onPressed: () {

                    if (widget.isEditing) {
                      saveCustomer();
                    }

                    widget.onEditPressed();
                  },

                  child: Text(
                    widget.isEditing
                        ? "Spara"
                        : "Redigera",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Wrap(
  spacing: 32,
  runSpacing: 32,

  children: [

    SizedBox(
      width: 350,
      child: EditableCustomerField(
        controller:
            firstNameController,
        title: "Förnamn",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: EditableCustomerField(
        controller:
            lastNameController,
        title: "Efternamn",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: EditableCustomerField(
        controller:
            emailController,
        title: "E-post",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: EditableCustomerField(
        controller:
            phoneController,
        title: "Telefon",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: EditableCustomerField(
        controller:
            addressController,
        title: "Adress",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: EditableCustomerField(
        controller:
            postCodeController,
        title: "Postnummer",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: EditableCustomerField(
        controller:
            cityController,
        title: "Stad",
        isEditing:
            widget.isEditing,
      ),
    ),
  ],
)
          ],
        ),
      ),
    );
  }
}