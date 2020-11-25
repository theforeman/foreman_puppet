module ForemanPuppetEnc
  class HostPuppetFacet < ApplicationRecord
    self.table_name = 'host_puppet_facets'
    audited associated_with: :host

    include Facets::Base
    include ForemanPuppetEnc::HostCommon

    has_many :host_classes, dependent: :destroy
    has_many :puppetclasses, through: :host_classes

    validates :environment_id, presence: true, unless: ->(facet) { facet.host.puppet_proxy_id.blank? }

    after_validation :ensure_puppet_associations
    before_save :clear_puppetinfo, if: :environment_id_changed?

    def self.populate_fields_from_facts(host, parser, type, source_proxy)
      type ||= 'puppet'
      return unless type == 'puppet'

      if Setting[:update_environment_from_facts]
        host.set_non_empty_values parser, [:environment]
      elsif parser.environment.present?
        self.environment ||= parser.environment
      end

      # if proxy authentication is enabled and we have no puppet proxy set and the upload came from puppet,
      # use it as puppet proxy.
      host.puppet_proxy ||= source_proxy
    end

    def self.inherited_attributes(new_hostgroup, attributes)
      { 'environment_id' => new_hostgroup.puppet&.inherited_environment_id }.merge(attributes)
    end

    def clear_puppetinfo
      return if environment
      self.puppetclasses = []
      self.config_groups = []
    end

    # the environment used by #clases nees to be self.environment and not self.parent.environment
    def parent_classes
      return [] unless host.hostgroup
      host.hostgroup.puppet&.classes(environment)
    end

    def parent_config_groups
      return [] unless host.hostgroup
      host.hostgroup.puppet&.all_config_groups
    end

    def ensure_puppet_associations
      status = validate_association_taxonomy(:environment)
      return status unless environment

      puppetclasses.where.not(id: environment.puppetclasses.reorder(nil)).find_each do |puppetclass|
        errors.add(
          :puppetclasses,
          format(_('%{puppetclass} does not belong to the %{environment} environment'), puppetclass: puppetclass, environment: environment)
        )
        status = false
      end
      status
    end

    private

    # Copy of method with same name, but for facet associations
    def validate_association_taxonomy(association_name)
      association = self.class.reflect_on_association(association_name)
      raise ArgumentError, "Association #{association_name} not found" unless association
      associated_object_id = public_send(association.foreign_key)
      if associated_object_id.present? &&
         association.klass.with_taxonomy_scope(host.organization, host.location).find_by(id: associated_object_id).blank?
        errors.add(
          association.foreign_key,
          format(_("with id %{object_id} doesn't exist or is not assigned to proper organization and/or location"), object_id: associated_object_id)
        )
        false
      else
        true
      end
    end
  end
end
