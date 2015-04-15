class CreateMartyDemoConfigs < ActiveRecord::Migration
  def change
    create_table :marty_demo_configs do |t|
      t.string :key
      t.string :value
    end

    add_index :marty_demo_configs, :key, unique: true
  end
end
