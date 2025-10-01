import 'package:equatable/equatable.dart';

class PipelineStage extends Equatable {
  final String name;
  final double progress;
  final double? value;
  final int weight;

  const PipelineStage({
    required this.name,
    required this.progress,
    this.value,
    this.weight = 1,
  });

  @override
  List<Object?> get props => [name, progress, value, weight];
}
