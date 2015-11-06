class CreateMartyDemoAnimals < McflyMigration
  include MartyDemo::Migrations
  def change
    create_table :marty_demo_animals do |t|
      t.timestamps null: false

      t.integer :tag
      t.string :name
      t.string :family
      t.string :gender
      t.text :description
      t.belongs_to :farm
    end

    add_fk :animals, :farms, column: :farm_id
    add_mcfly_unique_index MartyDemo::Animal
  end
end
