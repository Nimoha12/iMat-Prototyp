import 'package:flutter/material.dart';
import 'package:imat_repo/Widgets/home/login_overlay_scope.dart';

class NotLoggedInView
    extends StatelessWidget {

  const NotLoggedInView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          //////////////////////////////////////////////////////
          /// ICON
          //////////////////////////////////////////////////////

          Icon(
            Icons.person_off,
            size: 140,
            color: Colors.grey.shade500,
          ),

          const SizedBox(height: 36),

          //////////////////////////////////////////////////////
          /// TITLE
          //////////////////////////////////////////////////////

          const Text(
            "Du är inte inloggad",

            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          //////////////////////////////////////////////////////
          /// DESCRIPTION
          //////////////////////////////////////////////////////

          Text(
            "Logga in för att komma åt din profil.",

            style: TextStyle(
              fontSize: 24,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 48),

          //////////////////////////////////////////////////////
          /// LOGIN BUTTON
          //////////////////////////////////////////////////////

          SizedBox(
            width: 260,
            height: 72,

            child: ElevatedButton(
              onPressed: () {
                final loginOverlay = LoginOverlayScope.maybeOf(context);
                loginOverlay?.showLoginOverlay();
              },

              child: const Text(
                "Logga in",

                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}