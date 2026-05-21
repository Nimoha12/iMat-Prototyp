import 'package:flutter/material.dart';

class SettingsRadioOption extends StatelessWidget {

  final String title;
  final String value;
  final String groupValue;

  final Function(String?) onChanged;

  const SettingsRadioOption({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),

      child: InkWell(
        onTap: () {
          onChanged(value);
        },

        borderRadius:
            BorderRadius.circular(14),

        child: Row(
          children: [

            ////////////////////////////////////////////////////
            /// RADIO
            ////////////////////////////////////////////////////

            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,

              activeColor:
                  const Color(0xFF3F8A73),
            ),

            ////////////////////////////////////////////////////
            /// LABEL
            ////////////////////////////////////////////////////

            Text(
              title,

              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}