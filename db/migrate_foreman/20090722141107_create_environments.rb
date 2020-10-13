class CreateEnvironments < ActiveRecord::Migration[5.0]
  def up
    create_table :environments do |t|
      t.string :name, null: false, limit: 255
      t.timestamps null: true
    end
    create_table :environments_puppetclasses do |t|
      t.references :puppetclass, foreign_key: true
      t.references :environment, foreign_key: true
    end
  end

  def down
    drop_table :environments
    drop_table :environments_puppetclasses
  end
end
