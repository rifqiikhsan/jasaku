import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DistanceBubble extends StatelessWidget {
  final double distanceKm;
  final Color color;

  const DistanceBubble({
    super.key,
    required this.distanceKm,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.ac_unit_rounded, color: Colors.white, size: 11),
          const SizedBox(width: 4),
          Text(
            '$distanceKm km',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
