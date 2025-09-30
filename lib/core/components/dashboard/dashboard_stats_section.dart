import 'package:flutter/material.dart';
import '../../../models/stat_model.dart';
import '../card/stat_card.dart';

class DashboardStatsSection extends StatelessWidget {
  final List<StatModel> stats;

  const DashboardStatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: AppStatCard(
                  title: stat.title,
                  value: stat.value,
                  subtitle: stat.hasChange ? stat.formattedChange : null,
                  subtitleColor: stat.isPositive ? Colors.green : Colors.red,
                ),
              ),
              if (index < stats.length - 1) const SizedBox(width: 16),
            ],
          ),
        );
      }).toList(),
    );
  }
}
