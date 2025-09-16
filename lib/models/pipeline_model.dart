import 'package:flutter/material.dart';

class PipelineStage {
  final String name;
  final int count;
  final double value;
  final double progress;
  final Color color;

  PipelineStage({
    required this.name,
    required this.count,
    required this.value,
    required this.progress,
    required this.color,
  });
}
