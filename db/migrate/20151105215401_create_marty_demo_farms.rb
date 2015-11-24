require 'mcfly'

class CreateMartyDemoFarms < McflyMigration
  include MartyDemo::Migrations
  def change
    create_table :marty_demo_farms do |t|
      t.timestamps null: false

      t.string :name
      t.string :owner
      t.string :county
      t.float  :acres
    end

    add_mcfly_unique_index MartyDemo::Farm
  end
end
