# Hook site:after_init — s'exécute avant TOUS les generators
# y compris ceux du thème remote avec priority :highest
Jekyll::Hooks.register :site, :after_init do |site|
  schema = [
    { 'name' => 'reporting_status', 'field' => 'reporting_status',
      'label' => 'Reporting Status', 'widget' => 'select' },
    { 'name' => 'indicator_name', 'field' => 'indicator_name',
      'label' => 'Indicator Name', 'widget' => 'text' },
    { 'name' => 'indicator_number', 'field' => 'indicator_number',
      'label' => 'Indicator Number', 'widget' => 'text' },
    { 'name' => 'target_id', 'field' => 'target_id',
      'label' => 'Target', 'widget' => 'text' },
    { 'name' => 'computation_units', 'field' => 'computation_units',
      'label' => 'Unit of Measurement', 'widget' => 'text' },
    { 'name' => 'source_active_1', 'field' => 'source_active_1',
      'label' => 'Source Active', 'widget' => 'boolean' },
    { 'name' => 'source_organisation_1', 'field' => 'source_organisation_1',
      'label' => 'Source Organisation', 'widget' => 'text' },
  ]
  site.data['schema'] = schema
  Jekyll.logger.info "FixSchema:", "hook after_init: schema set to #{schema.length} hashes"
end

# Hook site:pre_render — second filet de sécurité
Jekyll::Hooks.register :site, :pre_render do |site|
  if site.data['schema'].nil? || !site.data['schema'].first.is_a?(Hash)
    schema = [
      { 'name' => 'reporting_status', 'field' => 'reporting_status',
        'label' => 'Reporting Status', 'widget' => 'select' },
    ]
    site.data['schema'] = schema
    Jekyll.logger.warn "FixSchema:", "pre_render fallback applied"
  end
end
