// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  IconData icon;
  String text;
  VoidCallback onTap;
  ActionCard({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
