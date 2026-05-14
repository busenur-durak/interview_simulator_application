import '../models/level_data.dart';

class Levels {
  Levels._();

  static const junior = LevelData(
    id: 'junior',
    name: 'Junior',
    expectations:
        'The candidate has 0 to 2 years of professional experience, so calibrate your questions and evaluation accordingly. '
        'Expect foundational and theoretical knowledge — correct use of terminology, understanding of core concepts, and awareness of common tools and patterns. '
        'Accept answers that demonstrate genuine learning eagerness and curiosity, even when they lack depth or production-level detail. '
        'Do not expect war stories from production incidents, complex architectural decisions, or deep optimization experience — they likely have not encountered these yet. '
        'Focus your evaluation on their problem-solving approach, how they think through unfamiliar problems, and their willingness to learn from mistakes. '
        'Simple, definition-level and "explain this concept" questions are appropriate; scenario-based questions should involve straightforward, well-scoped situations rather than ambiguous real-world complexity.',
  );

  static const mid = LevelData(
    id: 'mid',
    name: 'Mid-Level',
    expectations:
        'The candidate has 2 to 5 years of professional experience and should demonstrate solid practical knowledge backed by real project examples. '
        'Expect them to compare and contrast different tools, libraries, or architectural approaches with clear reasoning — not just name-dropping, but explaining why they chose one over another. '
        'They should understand practical trade-offs and limitations: performance vs. readability, speed of delivery vs. maintainability, third-party dependency vs. custom implementation. '
        'Expect evidence of independent problem-solving — situations where they identified an issue, evaluated options, and drove a solution without constant guidance. '
        'Ask "why did you choose X over Y" and "what would you do differently now" questions to test reflective thinking and growth. '
        'Vague or purely theoretical answers without concrete project context should be probed further — at this level, real experience matters more than textbook knowledge.',
  );

  static const senior = LevelData(
    id: 'senior',
    name: 'Senior',
    expectations:
        'The candidate has 5 or more years of professional experience and should demonstrate deep architectural thinking and a system-level design perspective. '
        'Expect them to discuss scalability, long-term maintainability, and the broader impact of technical decisions on the team, product, and organization. '
        'They should naturally bring up mentoring, code review practices, technical leadership, and how they elevate the engineers around them — not just their own output. '
        'Demand that they explain the WHY behind their decisions, not just the HOW — understanding context, constraints, and trade-offs at a strategic level is essential at this seniority. '
        'Challenge them with complex scenarios involving competing constraints: tight deadlines vs. technical debt, team skill gaps vs. architectural ambition, business pressure vs. engineering standards. '
        'Surface-level or purely implementation-focused answers are insufficient — push for systems thinking, cross-team impact awareness, and evidence of shaping technical direction beyond their immediate codebase.',
  );

  static const List<LevelData> all = [junior, mid, senior];

  static LevelData getById(String id) {
    return all.firstWhere(
      (level) => level.id == id,
      orElse: () => throw ArgumentError('No level found with id: $id'),
    );
  }
}
