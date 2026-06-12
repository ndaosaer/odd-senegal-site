# Monkey-patch direct de BackwardsCompatibility pour corriger le bug
# sur site.data['schema'] contenant des strings au lieu de hashes.
# Ce fichier doit être dans _plugins/ du dépôt site.

Jekyll::Hooks.register :site, :post_read do |site|
  site.data['schema'] = [
    { 'name' => 'reporting_status',      'field' => 'reporting_status',      'label' => 'Reporting Status',    'widget' => 'select'  },
    { 'name' => 'indicator_name',        'field' => 'indicator_name',        'label' => 'Indicator Name',      'widget' => 'text'    },
    { 'name' => 'indicator_number',      'field' => 'indicator_number',      'label' => 'Indicator Number',    'widget' => 'text'    },
    { 'name' => 'target_id',             'field' => 'target_id',             'label' => 'Target',              'widget' => 'text'    },
    { 'name' => 'computation_units',     'field' => 'computation_units',     'label' => 'Unit of Measurement', 'widget' => 'text'    },
    { 'name' => 'source_active_1',       'field' => 'source_active_1',       'label' => 'Source Active',       'widget' => 'boolean' },
    { 'name' => 'source_organisation_1', 'field' => 'source_organisation_1', 'label' => 'Source Organisation', 'widget' => 'text'    },
  ]
end

# Patch de BackwardsCompatibility après chargement du gem
Jekyll::Hooks.register :site, :post_read do |site|
  begin
    bc = Jekyll::OpenSdgPlugins::BackwardsCompatibility
    unless bc.instance_variable_get(:@patched)
      bc.prepend(Module.new do
        def generate(site)
          if site.data['schema'].is_a?(Array)
            site.data['schema'] = site.data['schema'].select { |f| f.is_a?(Hash) }
            if site.data['schema'].none? { |f| f['name'] == 'reporting_status' }
              site.data['schema'] << { 'name' => 'reporting_status', 'field' => 'reporting_status', 'label' => 'Reporting Status', 'widget' => 'select' }
            end
          end
          super
        end
      end)
      bc.instance_variable_set(:@patched, true)
      Jekyll.logger.info "FixSchema:", "BackwardsCompatibility patched successfully"
    end
  rescue => e
    Jekyll.logger.warn "FixSchema:", "Could not patch: #{e.message}"
  end
end
