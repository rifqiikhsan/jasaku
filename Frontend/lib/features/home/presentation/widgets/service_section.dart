import 'package:flutter/material.dart';
import 'package:jasaku/features/home/domain/entities/service_entity.dart';
import '../../../../app/theme.dart';
import 'service_card.dart';

class ServiceSection extends StatelessWidget {
  final List<ServiceEntity> services;
  final bool isLoading;

  const ServiceSection({
    super.key,
    required this.services,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
              InkWell(
                splashColor: Colors.blue.withValues(alpha: 0.2),
                highlightColor: Colors.blue.withValues(alpha: 0.1),
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
            ...services.map((s) => ServiceCard(service: s, onTap: () {})),
        ],
      ),
    );
  }
}
