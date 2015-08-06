require 'marty/migrations'

module MartyDemo::Migrations
  include Marty::Migrations

  def tb_prefix
  	"marty_demo_"
  end

  def disable_triggers(table_name, &block)
    begin
      execute("ALTER TABLE #{table_name} DISABLE TRIGGER USER;")

      block.call

    ensure
      execute("ALTER TABLE #{table_name} ENABLE TRIGGER USER;")
    end
  end

  def grant_view_permissions(permission, schema, view_name, role)
    execute("GRANT #{permission} ON #{schema}.#{view_name} TO #{role};")
  end
end
