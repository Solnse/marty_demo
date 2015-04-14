require 'mcfly'

class CreateMartyApiAuths < McflyMigration
	include Marty::Migrations

  def change
    create_table :marty_api_auths do |t|
      t.string :app_name
      t.string :api_key
      t.string :script_name
    end

    add_mcfly_unique_index(Marty::ApiAuth)
    add_index :marty_api_auths, [:app_name,
    														 :script_name,
    														 :obsoleted_dt],
    					unique: true,
    					name: 'unique_marty_api_auths_2'
  end
end
