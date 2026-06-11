import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../providers/home_provider.dart';
import 'service_card.dart';

class ServiceSection extends StatelessWidget {
  final List<ServiceModel> services;
  final bool isLoading;

  const ServiceSection({
    super.key,
    required this.services,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Terdekat dari kamu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            )
          else
            ...services
                .map((s) => ServiceCard(service: s, onTap: () {}))
                .toList(),
        ],
      ),
    );
  }
}
