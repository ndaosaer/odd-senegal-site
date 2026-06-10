module Jekyll
  class FixSchemaGenerator < Generator
    priority :highest
    safe true

    def generate(site)
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
      Jekyll.logger.info "FixSchema:", "schema set to #{schema.length} hashes"
    end
  end
end
