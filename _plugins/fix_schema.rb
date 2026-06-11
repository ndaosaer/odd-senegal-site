# Monkey-patch du generator BackwardsCompatibility pour protéger
# l'accès à site.data['schema'] contre les éléments non-Hash.
# Ce fichier doit être dans _plugins/ du dépôt site.

Jekyll::Hooks.register :site, :after_init do |site|
  Jekyll.logger.info "FixSchema:", "hook registered"
end

# On attend que le gem soit chargé, puis on le patche
Jekyll::Hooks.register :site, :post_read do |site|
  # Forcer schema à être une liste de hashes après la lecture des _data
  schema = [
    { 'name' => 'reporting_status', 'field' => 'reporting_status',
      'label' => 'Reporting Status', 'widget' => 'select' },
    { 'name' => 'indicator_name',   'field' => 'indicator_name',
      'label' => 'Indicator Name',   'widget' => 'text' },
    { 'name' => 'indicator_number', 'field' => 'indicator_number',
      'label' => 'Indicator Number', 'widget' => 'text' },
    { 'name' => 'target_id',        'field' => 'target_id',
      'label' => 'Target',           'widget' => 'text' },
    { 'name' => 'computation_units','field' => 'computation_units',
      'label' => 'Unit of Measurement','widget' => 'text' },
    { 'name' => 'source_active_1',  'field' => 'source_active_1',
      'label' => 'Source Active',    'widget' => 'boolean' },
    { 'name' => 'source_organisation_1','field' => 'source_organisation_1',
      'label' => 'Source Organisation','widget' => 'text' },
  ]
  site.data['schema'] = schema
  Jekyll.logger.info "FixSchema:", "post_read: schema forced to #{schema.length} hashes"
end
