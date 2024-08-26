import 'dart:ui';

import 'package:flutter/material.dart';

class HourlyForcast extends StatelessWidget {
  final IconData icons;
  final String time;
  final String temp;
  const HourlyForcast({
    super.key,
    required this.icons,
    required this.time,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              const SizedBox(
                width: 120,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
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
                temp,
                style: const TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
