import '../models/enums.dart';
import '../models/sector_data.dart';

const businessSector = SectorData(
  id: 'business',
  name: 'Business & Finance',
  context:
      'Business roles focus on planning, execution, and stakeholder management. '
      'Candidates should demonstrate structured thinking, clear communication, and '
      'an ability to make trade-offs under constraints.',
  positions: [
    PositionData(
      id: 'hr_specialist',
      name: 'Human Resources Specialist',
      topics: {
        TopicCategory.technical: [
          'Recruitment Process Design',
          'Interviewing & Assessment',
          'Performance Management',
          'HR Analytics Basics',
        ],
        TopicCategory.business: [
          'Workforce Planning',
          'Employee Relations',
          'Policy & Compliance',
        ],
        TopicCategory.culture: [
          'Confidentiality & Ethics',
          'Conflict Resolution',
        ],
        TopicCategory.hybrid: [
          'Hiring Manager Alignment',
          'Handling Sensitive Situations',
        ],
      },
      tools: ['ATS', 'Spreadsheets', 'HRIS'],
    ),
    PositionData(
      id: 'accounting_finance_analyst',
      name: 'Accounting & Finance Analyst',
      topics: {
        TopicCategory.technical: [
          'Financial Statements',
          'Budgeting & Forecasting',
          'Variance Analysis',
          'Internal Controls',
        ],
        TopicCategory.business: [
          'Stakeholder Reporting',
          'Prioritizing Deadlines',
        ],
        TopicCategory.culture: [
          'Attention to Detail',
          'Integrity',
        ],
        TopicCategory.hybrid: [
          'Explaining Numbers to Non-finance Teams',
          'Balancing Accuracy and Speed',
        ],
      },
      tools: ['Excel', 'ERP', 'Power BI/Tableau'],
    ),
    PositionData(
      id: 'project_manager',
      name: 'Project Manager',
      topics: {
        TopicCategory.technical: [
          'Project Planning',
          'Scope Management',
          'Risk Management',
          'Agile & Waterfall',
        ],
        TopicCategory.business: [
          'Stakeholder Management',
          'Budget & Timeline Control',
        ],
        TopicCategory.culture: [
          'Leadership',
          'Conflict Resolution',
        ],
        TopicCategory.hybrid: [
          'Trade-offs and Prioritization',
          'Cross-team Coordination',
        ],
      },
      tools: ['Jira', 'Confluence', 'Gantt Tools'],
    ),
    PositionData(
      id: 'business_development_specialist',
      name: 'Business Development Specialist',
      topics: {
        TopicCategory.technical: [
          'Pipeline Management',
          'Market Research',
          'Proposal Writing',
        ],
        TopicCategory.business: [
          'Negotiation',
          'Partnership Strategy',
          'Value Proposition',
        ],
        TopicCategory.culture: [
          'Resilience',
          'Customer Empathy',
        ],
        TopicCategory.hybrid: [
          'Balancing Growth and Profitability',
          'Stakeholder Alignment',
        ],
      },
      tools: ['CRM', 'Spreadsheets', 'Presentation Tools'],
    ),
    PositionData(
      id: 'logistics_manager',
      name: 'Logistics Manager',
      topics: {
        TopicCategory.technical: [
          'Supply Chain Fundamentals',
          'Inventory Management',
          'Process Optimization',
        ],
        TopicCategory.business: [
          'Vendor Management',
          'Cost Optimization',
          'Service Levels',
        ],
        TopicCategory.culture: [
          'Operational Discipline',
          'Decision Making Under Pressure',
        ],
        TopicCategory.hybrid: [
          'Trade-offs: Cost vs Speed',
          'Handling Disruptions',
        ],
      },
      tools: ['ERP', 'WMS', 'Dashboards'],
    ),
  ],
);

