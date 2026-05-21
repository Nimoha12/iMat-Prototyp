import 'package:flutter/material.dart';

class AddAddressForm extends StatelessWidget {
  final VoidCallback onCancel;

  const AddAddressForm({
    super.key,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ny adress',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        const TextField(
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            labelText: 'Adressnamn',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 18),
        const TextField(
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            labelText: 'Gatuadress',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 18),
        const Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Postnummer',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: TextField(
                style: TextStyle(fontSize: 18),
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
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            labelText: 'Portkod (Valfritt)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Spara adress',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                child: const Text(
                  'Avbryt',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
