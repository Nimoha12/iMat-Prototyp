import 'package:flutter/material.dart';
import 'package:imat_repo/model/imat/customer.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';


////////////////////////////////////////////////////////////
/// WHICH CUSTOMER FIELD
////////////////////////////////////////////////////////////


enum CustomerField {
  firstName,
  lastName,
  email,
  phoneNumber,
}

////////////////////////////////////////////////////////////
/// EDITABLE FIELD
////////////////////////////////////////////////////////////

class EditableCustomerField
    extends StatefulWidget {

  final String title;
  final CustomerField customerKey;
  final bool isEditing;

  const EditableCustomerField({
    super.key,
    required this.isEditing,
    required this.title,
    required this.customerKey,
  });

  @override
  State<EditableCustomerField> createState() =>
      _EditableCustomerFieldState();
}

class _EditableCustomerFieldState
    extends State<EditableCustomerField> {

  late TextEditingController controller;
  late FocusNode focusNode;
  bool wasFocused = false;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();

    focusNode = FocusNode();

    //////////////////////////////////////////////////////////
    /// SAVE WHEN LEAVING FIELD
    //////////////////////////////////////////////////////////

    focusNode.addListener(() {
      final hasFocus = focusNode.hasFocus;

      if (wasFocused && !hasFocus) {
        saveField();
      }

      wasFocused = hasFocus;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var iMatHandler =
        Provider.of<ImatDataHandler>(
          context,
        );

    var customer =
        iMatHandler.getCustomer();

    controller.text =
        getCustomerValue(customer);
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  /// GET VALUE FROM CUSTOMER
  ////////////////////////////////////////////////////////////

  String getCustomerValue(Customer customer) {

    switch (widget.customerKey) {

      case CustomerField.firstName:
        return customer.firstName;

      case CustomerField.lastName:
        return customer.lastName;

      case CustomerField.email:
        return customer.email;

      case CustomerField.phoneNumber:
        return customer.phoneNumber;
    }
  }

  ////////////////////////////////////////////////////////////
  /// SAVE TO BACKEND
  ////////////////////////////////////////////////////////////

  void saveField() {

    var iMatHandler =
        Provider.of<ImatDataHandler>(
          context,
          listen: false,
        );

    var customer =
        iMatHandler.getCustomer();

    switch (widget.customerKey) {

      case CustomerField.firstName:
        customer.firstName =
            controller.text;
        break;

      case CustomerField.lastName:
        customer.lastName =
            controller.text;
        break;

      case CustomerField.email:
        customer.email =
            controller.text;
        break;

      case CustomerField.phoneNumber:
        customer.phoneNumber =
            controller.text;
        break;
    }

    //////////////////////////////////////////////////////////
    /// SAVE TO IMAT BACKEND
    //////////////////////////////////////////////////////////

    iMatHandler.setCustomer(customer);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        //////////////////////////////////////////////////////
        /// TITLE
        //////////////////////////////////////////////////////

        Text(
          widget.title,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        //////////////////////////////////////////////////////
        /// INPUT
        //////////////////////////////////////////////////////

        SizedBox(
          width: 420,

          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: widget.isEditing,

            ////////////////////////////////////////////////////
            /// SAVE ON ENTER
            ////////////////////////////////////////////////////

            onSubmitted: (_) {
              saveField();
            },

            style: const TextStyle(
              fontSize: 18,
            ),

            decoration: InputDecoration(
  filled: true,
  fillColor: Colors.white,

  contentPadding:
      const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  ),

  ////////////////////////////////////////////////////////////
  /// NORMAL STATE
  ////////////////////////////////////////////////////////////

  enabledBorder: OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(14),

    borderSide: BorderSide(
      color: widget.isEditing
          ? Colors.grey.shade300
          : Colors.transparent,

      width: 2,
    ),
  ),

  ////////////////////////////////////////////////////////////
  /// FOCUSED STATE
  ////////////////////////////////////////////////////////////

  focusedBorder: OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(14),

    borderSide: const BorderSide(
      color: Color(0xFF3F8A73),
      width: 3,
    ),
  ),

  ////////////////////////////////////////////////////////////
  /// DISABLED STATE
  ////////////////////////////////////////////////////////////

  disabledBorder: OutlineInputBorder(
    borderRadius:
        BorderRadius.circular(14),

    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  ),
),
          ),
        ),
      ],
    );
  }


}