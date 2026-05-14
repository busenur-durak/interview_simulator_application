class MockData {
  MockData._();

  /// Sector IDs — translate via t(context, 'sector_$id')
  static const List<String> sectorIds = ['tech', 'business', 'marketing', 'service'];

  /// Position IDs per sector — translate via t(context, 'position_$id')
  static const Map<String, List<String>> positionIds = {
    'tech': [
      'flutter_developer',
      'backend_developer',
      'data_scientist',
      'cyber_security_specialist',
      'devops_engineer',
    ],
    'business': [
      'hr_specialist',
      'accounting_finance_analyst',
      'project_manager',
      'business_development_specialist',
      'logistics_manager',
    ],
    'marketing': [
      'digital_marketing_strategist',
      'uiux_designer',
      'social_media_manager',
      'graphic_designer',
      'content_writer',
    ],
    'service': [
      'crm_specialist',
      'sales_representative',
      'corporate_communications_specialist',
      'office_manager',
      'field_operations_specialist',
    ],
  };

  /// Level IDs — translate via t(context, 'level_$id')
  static const List<String> levelIds = ['junior', 'mid', 'senior'];
}
