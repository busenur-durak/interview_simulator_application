enum TopicCategory {
  technical,
  business,
  culture,
  hybrid;

  String get displayName => switch (this) {
    TopicCategory.technical => 'Technical',
    TopicCategory.business => 'Business',
    TopicCategory.culture => 'Culture',
    TopicCategory.hybrid => 'Hybrid',
  };
}

enum InterviewAction {
  continueInterview,
  close,
  forceClose,
}

enum InterviewEndReason {
  naturalCompletion,
  userRequestedEnd,
  candidateAskedInChat,
  userTerminated,
  modelTerminated,
  hardCap,
}

enum FollowUpDecision {
  followUp,
  nextTopic,
  modelDecides,
}
