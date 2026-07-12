import 'package:flutter/material.dart';
import 'package:jasaku/features/home/domain/entities/service_entity.dart';
import 'package:jasaku/shared/extensions/color_extension.dart';
import '../../../../app/theme.dart';

class ServiceCard extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback? onTap;

  const ServiceCard({super.key, required this.service, this.onTap});

  // String _formatPrice(int price) {
  //   final rb = price ~/ 1000;
  //   return '${rb}rb';
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: AppTheme.accent.withValues(alpha: 0.1),
          highlightColor: AppTheme.accent.withValues(alpha: 0.05),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: service.emojiColor.toColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      service.emoji!,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.serviceName!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service.category
                                ?.map((e) => e.catDesc)
                                .whereType<String>()
                                .join(' & ') ??
                            '-',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${service.distance}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF555555),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star,
                            color: AppTheme.accent,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${service.summaryRating}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${service.totalReviews} Ulasan)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (service.isVerification == 'Y')
                      const Text(
                        'Terverifikasi',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (service.isVerification == 'Y')
                      const SizedBox(height: 4),
                    const Text(
                      'Mulai Dari',
                      style: TextStyle(fontSize: 11, color: Color(0xFF888888)),
                    ),
                    Text(
                      '${service.priceMinimum}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
