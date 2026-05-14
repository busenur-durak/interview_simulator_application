import '../models/enums.dart';
import '../models/sector_data.dart';

const techSector = SectorData(
  id: 'tech',
  name: 'Technology & Software',
  context:
      'Technology roles focus on building, shipping, and maintaining software systems. '
      'Candidates should show problem-solving skills, practical engineering judgement, '
      'and clear communication about trade-offs.',
  positions: [
    PositionData(
      id: 'flutter_developer',
      name: 'Flutter Developer',
      topics: {
        TopicCategory.technical: [
          'State Management',
          'Widget Lifecycle & Rendering',
          'Navigation & Routing',
          'Testing Strategies',
          'App Architecture Patterns',
          'API Integration & Networking',
        ],
        TopicCategory.business: [
          'Estimation & Delivery',
          'Collaborating with Design & Backend',
          'Prioritization & Technical Debt',
        ],
        TopicCategory.culture: [
          'Learning Mindset',
          'Code Review & Collaboration',
        ],
        TopicCategory.hybrid: [
          'Explaining Technical Decisions',
          'Incident Handling',
        ],
      },
      tools: ['Flutter', 'Dart', 'Git', 'REST APIs'],
    ),
    PositionData(
      id: 'backend_developer',
      name: 'Backend Developer (Python/Java)',
      topics: {
        TopicCategory.technical: [
          'API Design',
          'Database Modeling',
          'Authentication & Authorization',
          'Caching & Performance',
          'Testing & Observability',
          'Concurrency & Async Patterns',
        ],
        TopicCategory.business: [
          'Service Reliability',
          'Stakeholder Communication',
        ],
        TopicCategory.culture: [
          'Ownership',
          'On-call & Incident Response',
        ],
        TopicCategory.hybrid: [
          'Trade-offs: Consistency vs Availability',
          'Designing for Scale',
        ],
      },
      tools: ['SQL', 'REST', 'Queues', 'Docker'],
    ),
    PositionData(
      id: 'data_scientist',
      name: 'Data Scientist',
      topics: {
        TopicCategory.technical: [
          'Exploratory Data Analysis',
          'Feature Engineering',
          'Model Evaluation',
          'Experiment Design (A/B)',
          'Data Pipelines',
          'Responsible AI',
        ],
        TopicCategory.business: [
          'Defining Success Metrics',
          'Communicating Insights',
        ],
        TopicCategory.culture: [
          'Curiosity',
          'Reproducibility',
        ],
        TopicCategory.hybrid: [
          'Model Trade-offs and Constraints',
          'Stakeholder Alignment',
        ],
      },
      tools: ['Python', 'SQL', 'Notebooks'],
    ),
    PositionData(
      id: 'cyber_security_specialist',
      name: 'Cyber Security Specialist',
      topics: {
        TopicCategory.technical: [
          'Threat Modeling',
          'Vulnerability Management',
          'Incident Response',
          'Identity & Access Management',
          'Secure SDLC',
          'Logging & Monitoring',
        ],
        TopicCategory.business: [
          'Risk Communication',
          'Compliance Awareness',
        ],
        TopicCategory.culture: [
          'Security Mindset',
          'Cross-team Enablement',
        ],
        TopicCategory.hybrid: [
          'Balancing Security and Usability',
          'Prioritizing Fixes',
        ],
      },
      tools: ['SIEM', 'OWASP', 'IDS/IPS'],
    ),
    PositionData(
      id: 'devops_engineer',
      name: 'DevOps Engineer',
      topics: {
        TopicCategory.technical: [
          'CI/CD',
          'Infrastructure as Code',
          'Monitoring & Alerting',
          'Containers & Orchestration',
          'Release Strategies',
          'Cost Optimization',
        ],
        TopicCategory.business: [
          'Reliability Targets',
          'Stakeholder Communication',
        ],
        TopicCategory.culture: [
          'Automation Mindset',
          'Collaboration with Dev Teams',
        ],
        TopicCategory.hybrid: [
          'Trade-offs: Speed vs Stability',
          'Reducing Mean Time to Recovery',
        ],
      },
      tools: ['GitHub Actions', 'Docker', 'Kubernetes', 'Terraform'],
    ),
  ],
);

