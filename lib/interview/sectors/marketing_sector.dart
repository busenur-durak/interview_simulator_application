import '../models/enums.dart';
import '../models/sector_data.dart';

const marketingSector = SectorData(
  id: 'marketing',
  name: 'Marketing & Design',
  context:
      'Marketing and design roles focus on communicating value, understanding users, '
      'and crafting compelling experiences. Candidates should demonstrate creativity '
      'paired with measurable outcomes and collaboration.',
  positions: [
    PositionData(
      id: 'digital_marketing_strategist',
      name: 'Digital Marketing Strategist',
      topics: {
        TopicCategory.technical: [
          'Campaign Planning',
          'SEO/SEM Basics',
          'Analytics & Attribution',
          'A/B Testing',
        ],
        TopicCategory.business: [
          'Go-to-market Strategy',
          'Budget Allocation',
          'Stakeholder Reporting',
        ],
        TopicCategory.culture: [
          'Experimentation Mindset',
          'Collaboration',
        ],
        TopicCategory.hybrid: [
          'Balancing Brand and Performance',
          'Prioritization Under Constraints',
        ],
      },
      tools: ['Google Analytics', 'Ads Platforms', 'Looker Studio'],
    ),
    PositionData(
      id: 'uiux_designer',
      name: 'UI/UX Designer',
      topics: {
        TopicCategory.technical: [
          'User Research',
          'Information Architecture',
          'Wireframing & Prototyping',
          'Design Systems',
        ],
        TopicCategory.business: [
          'Defining UX Metrics',
          'Stakeholder Alignment',
        ],
        TopicCategory.culture: [
          'Feedback & Iteration',
          'Empathy',
        ],
        TopicCategory.hybrid: [
          'Trade-offs: Usability vs Business Goals',
          'Collaboration with Engineering',
        ],
      },
      tools: ['Figma', 'Prototyping', 'User Testing'],
    ),
    PositionData(
      id: 'social_media_manager',
      name: 'Social Media Manager',
      topics: {
        TopicCategory.technical: [
          'Content Calendars',
          'Community Management',
          'Trend Analysis',
        ],
        TopicCategory.business: [
          'Brand Voice',
          'Engagement Metrics',
          'Crisis Communication',
        ],
        TopicCategory.culture: [
          'Consistency',
          'Creativity',
        ],
        TopicCategory.hybrid: [
          'Balancing Growth and Reputation',
          'Cross-team Collaboration',
        ],
      },
      tools: ['Scheduling Tools', 'Analytics', 'Creative Tools'],
    ),
    PositionData(
      id: 'graphic_designer',
      name: 'Graphic Designer',
      topics: {
        TopicCategory.technical: [
          'Visual Hierarchy',
          'Typography',
          'Brand Guidelines',
          'Asset Production',
        ],
        TopicCategory.business: [
          'Brief Interpretation',
          'Stakeholder Feedback',
        ],
        TopicCategory.culture: [
          'Craft',
          'Iteration',
        ],
        TopicCategory.hybrid: [
          'Trade-offs: Speed vs Quality',
          'Working with Constraints',
        ],
      },
      tools: ['Adobe Suite', 'Figma', 'Illustration Tools'],
    ),
    PositionData(
      id: 'content_writer',
      name: 'Content Writer',
      topics: {
        TopicCategory.technical: [
          'Content Strategy',
          'SEO Writing',
          'Editorial Process',
        ],
        TopicCategory.business: [
          'Audience Research',
          'Messaging',
        ],
        TopicCategory.culture: [
          'Clarity',
          'Curiosity',
        ],
        TopicCategory.hybrid: [
          'Balancing Tone and Conversion',
          'Working with Product Teams',
        ],
      },
      tools: ['CMS', 'Keyword Tools', 'Docs'],
    ),
  ],
);

