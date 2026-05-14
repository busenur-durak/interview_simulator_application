import '../models/enums.dart';
import '../models/sector_data.dart';

const financeSector = SectorData(
  id: 'finance',
  name: 'Finance',
  context:
      'The finance industry covers banking, investment, insurance, and corporate '
      'finance. Candidates should demonstrate analytical rigor, regulatory awareness, '
      'and the ability to communicate financial insights clearly.',
  positions: [
    PositionData(
      id: 'financial_analyst',
      name: 'Financial Analyst',
      topics: {
        TopicCategory.technical: [
          'Financial Modeling & Valuation',
          'Excel & Spreadsheet Mastery',
          'Data Analysis & Visualization',
          'Accounting Principles & Standards',
          'Forecasting & Budgeting',
          'Financial Reporting & Statements',
          'SQL & Database Queries',
          'Statistical Analysis Methods',
        ],
        TopicCategory.business: [
          'Regulatory Compliance Awareness',
          'Investment Decision Communication',
          'Market Research & Competitive Analysis',
          'Client & Stakeholder Reporting',
        ],
        TopicCategory.culture: [
          'Attention to Detail & Accuracy',
          'Ethical Decision Making in Finance',
          'Time Management Under Deadlines',
          'Professional Development & Certifications',
        ],
        TopicCategory.hybrid: [
          'Presenting Financial Insights to Executives',
          'Strategic Financial Planning Contributions',
          'Cross-department Budget Coordination',
          'Financial Technology Adoption & Innovation',
        ],
      },
      avoidTopics: [
        'Software development',
        'IT infrastructure',
        'Legal advisory',
        'Sales techniques',
      ],
      tools: [
        'Excel',
        'Bloomberg Terminal',
        'SQL',
        'Power BI/Tableau',
        'SAP',
        'Python/R basics',
      ],
    ),
    PositionData(
      id: 'risk_analyst',
      name: 'Risk Analyst',
      topics: {
        TopicCategory.technical: [
          'Risk Assessment Methodologies',
          'Statistical & Quantitative Modeling',
          'Credit Risk Analysis',
          'Market Risk Analysis',
          'Operational Risk Frameworks',
          'Stress Testing & Scenario Analysis',
          'Regulatory Frameworks (Basel/SOX/IFRS)',
          'Data Analysis with Python or R',
        ],
        TopicCategory.business: [
          'Risk Reporting to Senior Management',
          'Risk Policy Development & Review',
          'Internal Audit Coordination',
          'Vendor & Third-party Risk Assessment',
        ],
        TopicCategory.culture: [
          'Ethical Judgment & Integrity',
          'Attention to Detail Under Pressure',
          'Continuous Learning in Evolving Regulations',
          'Cross-functional Team Collaboration',
        ],
        TopicCategory.hybrid: [
          'Communicating Risk to Non-technical Stakeholders',
          'Crisis Management & Contingency Planning',
          'Balancing Risk Tolerance with Business Growth',
          'Technology Risk Assessment in Digital Transformation',
        ],
      },
      avoidTopics: [
        'Software engineering',
        'Marketing strategies',
        'Human resources',
        'Product design',
      ],
      tools: [
        'Excel',
        'SAS/SPSS',
        'Python/R',
        'SQL',
        'Risk Management Platforms',
        'Bloomberg',
      ],
    ),
  ],
);
