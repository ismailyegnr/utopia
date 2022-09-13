import 'package:flutter/material.dart';

class ProfileOptions extends StatelessWidget {
  Widget tile(String label, Icon icon, Function() callback) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -2.5),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        leading: icon,
        onTap: callback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        tile("Edit Profile", const Icon(Icons.edit), () => null),
        const Divider(),
        tile("My Articles", const Icon(Icons.book), () => null),
        const Divider(),
        tile("Saved Articles", const Icon(Icons.save), () => null),
        const Divider(),
        tile("Draft Articles", const Icon(Icons.save), () => null),
        const Divider(),
        tile("Blocked Authors", const Icon(Icons.block_outlined), () => null),
        // Divider(),
      ],
    );
  }
}