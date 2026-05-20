import 'package:flutter/material.dart';

class AddAddressForm
    extends StatelessWidget {

  final VoidCallback onCancel;

  const AddAddressForm({
    super.key,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(32),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            'Ny adress',

            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const TextField(
  decoration: InputDecoration(
    labelText: 'Adressnamn',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 18),

const TextField(
  decoration: InputDecoration(
    labelText: 'Gatuadress',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 18),

Row(
  children: [

    Expanded(
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Postnummer',
          border: OutlineInputBorder(),
        ),
      ),
    ),

    const SizedBox(width: 16),

    Expanded(
      flex: 2,

      child: TextField(
        decoration: InputDecoration(
          labelText: 'Stad',
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 18),

const TextField(
  decoration: InputDecoration(
    labelText: 'Portkod (Valfritt)',
    border: OutlineInputBorder(),
  ),
),
          Row(
            children: [

              Expanded(
                child: ElevatedButton(
                  onPressed: () {},

                  child: const Text(
                    'Spara adress',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,

                  child: const Text(
                    'Avbryt',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}