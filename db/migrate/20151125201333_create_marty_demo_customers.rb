require 'mcfly'

class CreateMartyDemoCustomers < McflyMigration
  include MartyDemo::Migrations
  def change
    create_table :marty_demo_customers do |t|
      t.timestamps null: false

      t.belongs_to :farm, :class_name => MartyDemo::Farm
      t.string :name
      t.string :company
      t.string :phone
      t.date :join_date
      t.text :description
    end

    add_mcfly_unique_index MartyDemo::Customer
  end
end
