import '../models/enums.dart';
import '../models/sector_data.dart';

const itSector = SectorData(
  id: 'it',
  name: 'Information Technology',
  context:
      'The IT industry encompasses software development, systems analysis, and '
      'digital services. Candidates should demonstrate both technical proficiency '
      'and the ability to deliver value through technology solutions.',
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
          'Dart Language Features',
          'Performance Optimization',
          'API Integration & Networking',
        ],
        TopicCategory.business: [
          'Project Estimation & Deadline Management',
          'Client Communication & Requirement Gathering',
          'Technical Debt vs Business Priority',
          'Cross-team Collaboration with Design and Backend',
        ],
        TopicCategory.culture: [
          'Learning & Growth Mindset',
          'Mentoring & Knowledge Sharing',
          'Code Review Philosophy',
          'Work-life Balance & Sustainable Pace',
        ],
        TopicCategory.hybrid: [
          'Explaining Technical Decisions to Non-technical Stakeholders',
          'Technology Stack Selection for New Projects',
          'Handling Production Incidents Under Pressure',
          'Open Source Contribution & Developer Community',
        ],
      },
      avoidTopics: [
        'Backend infrastructure',
        'Database administration',
        'DevOps pipelines',
        'Network engineering',
      ],
      tools: [
        'Flutter SDK',
        'Dart',
        'Firebase',
        'Git',
        'REST APIs',
        'CI/CD',
      ],
    ),
    PositionData(
      id: 'system_analyst',
      name: 'System Analyst',
      topics: {
        TopicCategory.technical: [
          'Requirements Analysis & Elicitation',
          'System Design & UML Modeling',
          'Database Design & Data Modeling',
          'Business Process Mapping',
          'Data Flow & Integration Architecture',
          'Security & Compliance Requirements',
          'Testing Strategy & QA Coordination',
          'Technical Documentation Standards',
        ],
        TopicCategory.business: [
          'Stakeholder Management & Expectations',
          'Project Scope Definition & Control',
          'Cost-Benefit Analysis',
          'Vendor Evaluation & Selection',
        ],
        TopicCategory.culture: [
          'Communication & Presentation Skills',
          'Conflict Resolution in Cross-functional Teams',
          'Adaptability to Changing Requirements',
          'Continuous Process Improvement',
        ],
        TopicCategory.hybrid: [
          'Bridging Business and Technical Teams',
          'Legacy System Modernization Decisions',
          'Change Management & User Adoption',
          'Translating Business Needs into Technical Specifications',
        ],
      },
      avoidTopics: [
        'Writing production code',
        'Infrastructure management',
        'Direct customer support',
      ],
      tools: [
        'UML Tools',
        'JIRA',
        'SQL',
        'Visio/Draw.io',
        'Excel',
        'Confluence',
      ],
    ),
  ],
);
