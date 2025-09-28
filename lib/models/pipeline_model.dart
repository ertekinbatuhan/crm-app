class PipelineStage {
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
}
