require 'mcfly'

class CreateMartyDemoAnimals < McflyMigration
  include MartyDemo::Migrations
  def change
    create_table :marty_demo_animals do |t|
      t.timestamps null: false

      t.belongs_to :farm, :class_name => MartyDemo::Farm
      t.integer :tag
      t.string :name
      t.string :family
      t.string :gender
      t.text :description
    end

    add_mcfly_unique_index MartyDemo::Animal
  end
end
