import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Settings_Page/Settings_Radio_Option.dart';
import 'package:imat_repo/Widgets/Profile_Parts/Settings_Page/Settings_Section.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {

  String textSize = 'medium';
  String contrast = 'standard';
  String language = 'sv';

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

          padding: const EdgeInsets.all(32),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(20),

            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              //////////////////////////////////////////////////
              /// TITLE
              //////////////////////////////////////////////////

              const Text(
                'Inställningar',

                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 36),

              //////////////////////////////////////////////////
              /// TEXT SIZE
              //////////////////////////////////////////////////

              SettingsSection(
                title: 'Textstorlek',

                children: [

                  SettingsRadioOption(
                    title: 'Liten',
                    value: 'small',
                    groupValue: textSize,

                    onChanged: (value) {

                      setState(() {
                        textSize = value!;
                      });
                    },
                  ),

                  SettingsRadioOption(
                    title:
                        'Mellan (Rekommenderas)',

                    value: 'medium',
                    groupValue: textSize,

                    onChanged: (value) {

                      setState(() {
                        textSize = value!;
                      });
                    },
                  ),

                  SettingsRadioOption(
                    title: 'Stor',
                    value: 'large',
                    groupValue: textSize,

                    onChanged: (value) {

                      setState(() {
                        textSize = value!;
                      });
                    },
                  ),
                ],
              ),

              const Divider(height: 60),

              //////////////////////////////////////////////////
              /// CONTRAST
              //////////////////////////////////////////////////

              SettingsSection(
                title: 'Kontrastläge',

                children: [

                  SettingsRadioOption(
                    title: 'Standard',
                    value: 'standard',
                    groupValue: contrast,

                    onChanged: (value) {

                      setState(() {
                        contrast = value!;
                      });
                    },
                  ),

                  SettingsRadioOption(
                    title: 'Hög kontrast',
                    value: 'high',
                    groupValue: contrast,

                    onChanged: (value) {

                      setState(() {
                        contrast = value!;
                      });
                    },
                  ),
                ],
              ),

              const Divider(height: 90),

              //////////////////////////////////////////////////
              /// LANGUAGE
              //////////////////////////////////////////////////

              SettingsSection(
                title: 'Språk',

                children: [

                  SettingsRadioOption(
                    title: 'Svenska',
                    value: 'sv',
                    groupValue: language,

                    onChanged: (value) {

                      setState(() {
                        language = value!;
                      });
                    },
                  ),

                  SettingsRadioOption(
                    title: 'English',
                    value: 'en',
                    groupValue: language,

                    onChanged: (value) {

                      setState(() {
                        language = value!;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 50),

              //////////////////////////////////////////////////
              /// INFO BOX
              //////////////////////////////////////////////////

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),

                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF1F7F4),

                  borderRadius:
                      BorderRadius.circular(16),

                  border: Border.all(
                    color:
                        const Color(0xFF3F8A73),

                    width: 2,
                  ),
                ),

                child: const Row(
                  children: [

                    Text(
                      '💡',
                      style:
                          TextStyle(fontSize: 24),
                    ),

                    SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        'Tips: Inställningarna sparas automatiskt och gäller för hela webbplatsen.',

                        style: TextStyle(
                          fontSize: 20,
                        ),
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