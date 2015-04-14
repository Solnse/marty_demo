# This migration comes from marty (originally 19)
require 'marty/migrations'

class CreateMartyPostings < McflyAppendOnlyMigration
  include Marty::Migrations

  def change
    create_table :marty_postings do |t|
      t.string :name, null: false
      t.references :posting_type, null: false
      t.string :comment, null: false
    end

    add_mcfly_index :marty_postings,
    :name, :posting_type_id

    add_fk :postings, :posting_types
  end
end
