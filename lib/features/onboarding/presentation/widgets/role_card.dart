import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  final String role;
  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Text(label));
  }
}
