import 'package:flutter/material.dart';
import 'package:imat_repo/Pages/home_page.dart';
import 'package:imat_repo/model/AuthState.dart';

import 'package:provider/provider.dart';


class LogoutButton
    extends StatelessWidget {

  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 44,

      child: OutlinedButton(
        onPressed: () {
          
        context.read<AuthState>().logout();
          //////////////////////////////////////////////////////
          /// LOG OUT
          //////////////////////////////////////////////////////

          Navigator.pushAndRemoveUntil(
            context,

            MaterialPageRoute(
              builder: (context) =>
                  const HomePage(),
            ),

            (route) => false,
            
          );
        },

        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 2.5),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),

        child: const Text(
          "Logga ut",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}