import '../models/enums.dart';
import '../models/sector_data.dart';

const serviceSector = SectorData(
  id: 'service',
  name: 'Service & Sales',
  context:
      'Service and sales roles focus on customer outcomes, communication, and execution. '
      'Candidates should show empathy, structured problem-solving, and strong collaboration.',
  positions: [
    PositionData(
      id: 'crm_specialist',
      name: 'CRM Specialist',
      topics: {
        TopicCategory.technical: [
          'Customer Lifecycle',
          'Segmentation',
          'Process Documentation',
        ],
        TopicCategory.business: [
          'Customer Retention',
          'Stakeholder Reporting',
        ],
        TopicCategory.culture: [
          'Customer Empathy',
          'Attention to Detail',
        ],
        TopicCategory.hybrid: [
          'Balancing Process and Flexibility',
          'Handling Escalations',
        ],
      },
      tools: ['CRM', 'Spreadsheets', 'Dashboards'],
    ),
    PositionData(
      id: 'sales_representative',
      name: 'Sales Representative',
      topics: {
        TopicCategory.technical: [
          'Lead Qualification',
          'Pipeline Management',
          'Discovery Calls',
        ],
        TopicCategory.business: [
          'Negotiation',
          'Objection Handling',
          'Forecasting',
        ],
        TopicCategory.culture: [
          'Resilience',
          'Coachability',
        ],
        TopicCategory.hybrid: [
          'Balancing Volume and Quality',
          'Cross-team Collaboration',
        ],
      },
      tools: ['CRM', 'Email', 'Calling Tools'],
    ),
    PositionData(
      id: 'corporate_communications_specialist',
      name: 'Corporate Communications Specialist',
      topics: {
        TopicCategory.technical: [
          'Messaging Frameworks',
          'Media Relations',
          'Internal Comms',
        ],
        TopicCategory.business: [
          'Reputation Management',
          'Stakeholder Alignment',
        ],
        TopicCategory.culture: [
          'Clarity',
          'Consistency',
        ],
        TopicCategory.hybrid: [
          'Crisis Communication',
          'Balancing Transparency and Risk',
        ],
      },
      tools: ['Docs', 'Press Kits', 'Analytics'],
    ),
    PositionData(
      id: 'office_manager',
      name: 'Office Manager',
      topics: {
        TopicCategory.technical: [
          'Operations Planning',
          'Vendor Coordination',
          'Process Improvement',
        ],
        TopicCategory.business: [
          'Budget Basics',
          'Prioritization',
        ],
        TopicCategory.culture: [
          'Reliability',
          'Communication',
        ],
        TopicCategory.hybrid: [
          'Handling Multiple Requests',
          'Trade-offs Under Time Pressure',
        ],
      },
      tools: ['Spreadsheets', 'Ticketing', 'Calendar Tools'],
    ),
    PositionData(
      id: 'field_operations_specialist',
      name: 'Field Operations Specialist',
      topics: {
        TopicCategory.technical: [
          'Operational Checklists',
          'Incident Handling',
          'Process Standardization',
        ],
        TopicCategory.business: [
          'Service Levels',
          'Escalation Paths',
        ],
        TopicCategory.culture: [
          'Ownership',
          'Safety Mindset',
        ],
        TopicCategory.hybrid: [
          'Balancing Speed and Quality',
          'Working Under Pressure',
        ],
      },
      tools: ['Mobile Tools', 'Tickets', 'Reporting'],
    ),
  ],
);

