import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icons;
  final String lable;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.icons,
    required this.lable,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
     
        const SizedBox(
          height: 8,
        ),
        Icon(
         icons,
          size: 30,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
         lable,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
