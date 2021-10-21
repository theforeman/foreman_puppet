class CreateEnvironments < ActiveRecord::Migration[4.2]
  def up
    create_table :environments do |t|
      t.string :name, null: false, limit: 255
      t.timestamps null: true
    end
    create_table :environments_puppetclasses do |t|
      t.references :puppetclass, null: false
      t.references :environment, foreign_key: true
    end
  end

  def down
    drop_table :environments_puppetclasses
    drop_table :environments
  end
end
