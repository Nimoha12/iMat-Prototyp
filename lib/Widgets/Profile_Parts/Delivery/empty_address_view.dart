import 'package:flutter/material.dart';

class EmptyAddressView
    extends StatelessWidget {

  const EmptyAddressView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 180,

      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: const Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              Icons.location_on,
              size: 28,
              color: Colors.grey,
            ),

            SizedBox(height: 12),

            Text(
              'Inga adresser sparade',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
