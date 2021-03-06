# This migration comes from marty (originally 5)
class CreateMartyUserRoles < ActiveRecord::Migration
  include Marty::Migrations

  def change
    create_table :marty_user_roles do |t|
      t.references :user, null: false
      t.references :role, null: false
    end

    add_fk :marty_user_roles, :marty_users, column: :user_id
    add_fk :marty_user_roles, :marty_roles, column: :role_id
    add_index(:marty_user_roles, [:user_id])
  end
end
