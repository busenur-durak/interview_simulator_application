import 'enums.dart';

class PositionData {
  final String id;
  final String name;
  final Map<TopicCategory, List<String>> topics;
  final List<String> avoidTopics;
  final List<String> tools;

  const PositionData({
    required this.id,
    required this.name,
    required this.topics,
    this.avoidTopics = const [],
    this.tools = const [],
  });

  List<String> get allTopicNames =>
      topics.values.expand((list) => list).toList();

  int get totalTopicCount => allTopicNames.length;
}

class SectorData {
  final String id;
  final String name;
  final String context;
  final List<PositionData> positions;

  const SectorData({
    required this.id,
    required this.name,
    required this.context,
    required this.positions,
  });

  PositionData? getPosition(String positionId) {
    for (final position in positions) {
      if (position.id == positionId) return position;
    }
    return null;
  }

  List<String> get positionIds => positions.map((p) => p.id).toList();

  List<String> get positionNames => positions.map((p) => p.name).toList();
}
