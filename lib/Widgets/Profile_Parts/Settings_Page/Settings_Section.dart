import 'package:flutter/material.dart';

class SettingsSection
    extends StatelessWidget {

  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

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
          title,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        //////////////////////////////////////////////////////
        /// OPTIONS
        //////////////////////////////////////////////////////

        ...children,
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// RADIO OPTION
////////////////////////////////////////////////////////////

