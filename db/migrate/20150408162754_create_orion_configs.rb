class CreateOrionConfigs < ActiveRecord::Migration
  def change
    create_table :orion_configs do |t|
      t.string :key
      t.string :value
    end

    add_index :orion_configs, :key, unique: true
  end
end
