# This migration comes from marty (originally 71)
class AddObjectChangesColumnToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :object_changes, :text
  end

  def self.down
    remove_column :versions, :object_changes
  end
end
