# This migration comes from marty (originally 72)
class AddValidationFunctionToImportTypes < ActiveRecord::Migration
  def change
    add_column :marty_import_types, :validation_function, :string
    drop_table :marty_import_synonyms
  end
end
