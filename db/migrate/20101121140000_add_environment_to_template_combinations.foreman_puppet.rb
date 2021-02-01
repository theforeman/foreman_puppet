class AddEnvironmentToTemplateCombinations < ActiveRecord::Migration[4.2]
  def up
    add_reference :template_combinations, :environment, foreign_key: true unless column_exists?(:template_combinations, :environment_id)
  end

  def down
    remove_reference :template_combinations, :environment, foreign_key: true if ForemanPuppet.extracted_from_core?
  end
end
