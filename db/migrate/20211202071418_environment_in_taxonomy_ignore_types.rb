class EnvironmentInTaxonomyIgnoreTypes < ActiveRecord::Migration[6.0]
  def up
    organizations = Organization.where("ignore_types LIKE '%Environment%'")
    locations = Location.where("ignore_types LIKE '%Environment%'")

    (organizations + locations).each do |tax|
      new_types = tax.ignore_types.map { |type| type == 'Environment' ? 'ForemanPuppet::Environment' : type }
      tax.update ignore_types: new_types
    end
  end
end
