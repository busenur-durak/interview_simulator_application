import 'dart:math';

import '../models/enums.dart';
import '../models/interview_state.dart';

class TopicSelector {
  static final _random = Random();

  /// Selects the next (topic, category) pair based on interview phase,
  /// category diversity rules, and weighted random distribution.
  static (String topic, TopicCategory category) selectNext(
    InterviewState state,
  ) {
    final phase = state.currentPhase;
    final remaining = state.remainingTopics;

    // Determine which categories are blocked to prevent 3+ consecutive same-category.
    final blocked = _blockedCategory(state);

    // Build a filtered remaining map that excludes the blocked category.
    final available = <TopicCategory, List<String>>{
      for (final entry in remaining.entries)
        if (entry.value.isNotEmpty && entry.key != blocked)
          entry.key: entry.value,
    };

    // If blocking removed all options, fall back to unfiltered remaining.
    final pool = available.isNotEmpty
        ? available
        : <TopicCategory, List<String>>{
            for (final entry in remaining.entries)
              if (entry.value.isNotEmpty) entry.key: entry.value,
          };

    // If absolutely nothing remains, return the last covered topic as safety.
    if (pool.isEmpty) {
      return _lastCoveredFallback(state);
    }

    return switch (phase) {
      1 => _selectPhase1(pool),
      2 => _selectPhase2(pool),
      3 => _selectPhase3(pool),
      4 => _selectPhase4(pool),
      _ => _selectPhase2(pool), // defensive default
    };
  }

  // ---------------------------------------------------------------------------
  // Phase strategies
  // ---------------------------------------------------------------------------

  /// Phase 1 (Warm-up, Q1-2): Ice-breaker topics.
  /// Prefer culture first, then business, then anything available.
  static (String, TopicCategory) _selectPhase1(
    Map<TopicCategory, List<String>> pool,
  ) {
    final preferred = [
      TopicCategory.culture,
      TopicCategory.business,
      TopicCategory.hybrid,
      TopicCategory.technical,
    ];
    final topic = _pickFirstFrom(pool, preferred);
    if (topic != null) return topic;
    return _pickAny(pool);
  }

  /// Phase 2 (Core, Q3-6): Weighted towards technical depth.
  static (String, TopicCategory) _selectPhase2(
    Map<TopicCategory, List<String>> pool,
  ) {
    const weights = {
      TopicCategory.technical: 50,
      TopicCategory.hybrid: 30,
      TopicCategory.business: 15,
      TopicCategory.culture: 5,
    };
    return _selectWeighted(pool, weights);
  }

  /// Phase 3 (Deep, Q7-10): Balanced technical + hybrid exploration.
  static (String, TopicCategory) _selectPhase3(
    Map<TopicCategory, List<String>> pool,
  ) {
    const weights = {
      TopicCategory.technical: 35,
      TopicCategory.hybrid: 35,
      TopicCategory.business: 20,
      TopicCategory.culture: 10,
    };
    return _selectWeighted(pool, weights);
  }

  /// Phase 4 (Closing, Q11+): No pure technical; reflective / soft topics.
  static (String, TopicCategory) _selectPhase4(
    Map<TopicCategory, List<String>> pool,
  ) {
    final preferred = [
      TopicCategory.culture,
      TopicCategory.business,
      TopicCategory.hybrid,
    ];
    final closingPool = <TopicCategory, List<String>>{
      for (final cat in preferred)
        if (pool.containsKey(cat)) cat: pool[cat]!,
    };

    if (closingPool.isNotEmpty) {
      final topic = _pickFirstFrom(closingPool, preferred);
      if (topic != null) return topic;
    }

    // Fallback: if only technical topics remain, use them anyway.
    return _pickAny(pool);
  }

  // ---------------------------------------------------------------------------
  // Selection helpers
  // ---------------------------------------------------------------------------

  /// Weighted random category selection. Only categories present in [pool] are
  /// considered. Their weights are re-normalized before the roll.
  static (String, TopicCategory) _selectWeighted(
    Map<TopicCategory, List<String>> pool,
    Map<TopicCategory, int> weights,
  ) {
    // Collect eligible categories with their weights.
    final eligible = <(TopicCategory, int)>[
      for (final cat in pool.keys)
        if (weights.containsKey(cat)) (cat, weights[cat]!),
    ];

    // If no eligible category matches the weight map, fall back.
    if (eligible.isEmpty) return _pickAny(pool);

    final totalWeight = eligible.fold<int>(0, (sum, e) => sum + e.$2);
    var roll = _random.nextInt(totalWeight);

    for (final (cat, weight) in eligible) {
      roll -= weight;
      if (roll < 0) {
        final topic = pool[cat]!.first;
        return (topic, cat);
      }
    }

    // Should not reach here, but defensive fallback.
    final (cat, _) = eligible.last;
    return (pool[cat]!.first, cat);
  }

  /// Picks the first available topic from [remaining] by walking [preferred]
  /// category order. Returns null if nothing found.
  static (String, TopicCategory)? _pickFirstFrom(
    Map<TopicCategory, List<String>> remaining,
    List<TopicCategory> preferred,
  ) {
    for (final cat in preferred) {
      final topics = remaining[cat];
      if (topics != null && topics.isNotEmpty) {
        return (topics.first, cat);
      }
    }
    return null;
  }

  /// Picks any topic from any available category (first non-empty entry).
  static (String, TopicCategory) _pickAny(
    Map<TopicCategory, List<String>> pool,
  ) {
    for (final entry in pool.entries) {
      if (entry.value.isNotEmpty) {
        return (entry.value.first, entry.key);
      }
    }
    // Absolute last-resort – should never happen if caller checks pool.
    return ('General', TopicCategory.hybrid);
  }

  /// Returns the category that must be excluded to prevent 3+ consecutive
  /// same-category questions, or null if no blocking is needed.
  static TopicCategory? _blockedCategory(InterviewState state) {
    final last2 = state.lastNCategories(2);
    if (last2.length == 2 && last2[0] == last2[1]) {
      return last2[0];
    }
    return null;
  }

  /// Safety fallback when all remaining topics are exhausted: return the most
  /// recently covered topic so the interview can still produce a question.
  static (String, TopicCategory) _lastCoveredFallback(InterviewState state) {
    if (state.records.isNotEmpty) {
      final last = state.records.last;
      return (last.topic, last.category);
    }
    // Absolute edge case: no records and no topics.
    return ('General', TopicCategory.hybrid);
  }
}
