# This migration comes from marty (originally 4)
class CreateMartyRoles < ActiveRecord::Migration
  def change
    create_table :marty_roles do |t|
      t.string 	:name, null: false
    end
  end
end
