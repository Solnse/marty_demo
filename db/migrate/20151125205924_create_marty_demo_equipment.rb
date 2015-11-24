require 'mcfly'

class CreateMartyDemoEquipment < McflyMigration
  include MartyDemo::Migrations
  def change
    create_table :marty_demo_equipment do |t|
      t.timestamps null: false

      t.belongs_to :farm, :class_name => MartyDemo::Farm
      t.string :name
      t.string :equip_type
      t.date :purchase_date
      t.date :service_date
      t.date :expected_replacement_date
      t.decimal :purchase_price
    end

    add_mcfly_unique_index MartyDemo::Equipment
  end
end
