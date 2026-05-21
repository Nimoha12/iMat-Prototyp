import 'package:flutter/material.dart';

class EmptyAddressView
    extends StatelessWidget {

  const EmptyAddressView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 300,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

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
              size: 90,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              'Inga adresser sparade',

              style: TextStyle(
                fontSize: 34,
              ),
            ),
          ],
        ),
      ),
    );
  }
}