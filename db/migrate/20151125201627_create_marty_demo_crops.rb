require 'mcfly'

class CreateMartyDemoCrops < McflyMigration
  include MartyDemo::Migrations
  def change
    create_table :marty_demo_crops do |t|
      t.timestamps null: false

      t.belongs_to :farm, :class_name => MartyDemo::Farm
      t.string :name
      t.string :season
      t.decimal :price
      t.text :description
    end

    add_mcfly_unique_index MartyDemo::Crop
  end
end
