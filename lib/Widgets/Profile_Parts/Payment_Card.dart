import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Cradit_Card_Field.dart';
import 'package:imat_repo/model/imat_data_handler.dart';
import 'package:provider/provider.dart';

class PaymentCard extends StatefulWidget {
  final bool isEditing;
  final VoidCallback onEditPressed;

  const PaymentCard({
    super.key,
    required this.isEditing,
    required this.onEditPressed,
  });

  @override
  State<PaymentCard> createState() =>
      _PaymentCardState();
}

class _PaymentCardState
    extends State<PaymentCard> {

  bool initialized = false;

  late TextEditingController holderController;
  late TextEditingController typeController;
  late TextEditingController numberController;
  late TextEditingController cvvController;
  late TextEditingController monthController;
  late TextEditingController yearController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {

      final card =
          context.read<ImatDataHandler>()
                 .getCreditCard();

      holderController =
          TextEditingController(
            text: card.holdersName,
          );

      typeController =
          TextEditingController(
            text: card.cardType,
          );

      numberController =
          TextEditingController(
            text: card.cardNumber,
          );

      cvvController =
          TextEditingController(
            text:
                card.verificationCode.toString(),
          );

      monthController =
          TextEditingController(
            text:
                card.validMonth.toString(),
          );

      yearController =
          TextEditingController(
            text:
                card.validYear.toString(),
          );

      initialized = true;
    }
  }

  void saveCard() {

    final handler =
        context.read<ImatDataHandler>();

    final card =
        handler.getCreditCard();

    card.holdersName =
        holderController.text;

    card.cardType =
        typeController.text;

    card.cardNumber =
        numberController.text;

    card.verificationCode =
        int.tryParse(
          cvvController.text,
        ) ??
        0;

    card.validMonth =
        int.tryParse(
          monthController.text,
        ) ??
        1;

    card.validYear =
        int.tryParse(
          yearController.text,
        ) ??
        25;

    handler.setCreditCard(card);
  }

  @override
  void dispose() {

    holderController.dispose();
    typeController.dispose();
    numberController.dispose();
    cvvController.dispose();
    monthController.dispose();
    yearController.dispose();

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
                  "Betalningsinformation",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                ElevatedButton(
                  onPressed: () {

                    if (widget.isEditing) {
                      saveCard();
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
      child: CreditCardField(
        controller:
            holderController,
        title: "Kortinnehavare",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: CreditCardField(
        controller:
            typeController,
        title: "Korttyp",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: CreditCardField(
        controller:
            numberController,
        title: "Kortnummer",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: CreditCardField(
        controller:
            cvvController,
        title: "CVV",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: CreditCardField(
        controller:
            monthController,
        title: "Månad",
        isEditing:
            widget.isEditing,
      ),
    ),

    SizedBox(
      width: 350,
      child: CreditCardField(
        controller:
            yearController,
        title: "År",
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