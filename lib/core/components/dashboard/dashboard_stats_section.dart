import 'package:flutter/material.dart';
import '../../../models/stat_model.dart';
import '../card/stat_card.dart';

class DashboardStatsSection extends StatelessWidget {
  final List<StatModel> stats;

  const DashboardStatsSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: stat.isPositive 
                  ? AppStatCard.positive(
                      title: stat.title,
                      value: stat.value,
                      change: stat.change,
                    )
                  : AppStatCard.negative(
                      title: stat.title,
                      value: stat.value,
                      change: stat.change,
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