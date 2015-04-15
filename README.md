**Adding Marty to a new project.**

add to Gemfile:
```ruby
gem 'marty', git: "https://github.com/arman000/marty.git"
```
Marty currently requires netzke for the presentation layer, and since netzke requires extjs, we’re going to need to integrate it.

**_Install extjs somewhere on the machine and create a symbolic link to it as public/extjs_**

example:
    {PROJECT_ROOT}/public $ ln -s ~/repos/extjs-version extjs

**_Netzke also uses the FamFamFam Silk icon set, so you can copy them into public/images/icons folder. (or symlink)_**

**_Bring in the Marty migrations:_**

	$ rake marty:install:migrations

**_Run the migrations:_**

	$ rake db:migrate

**Note:** wait to run marty:seed until we set our marty-specific configs in our application.

Referencing and utilizing Marty components is namespaced so our application should also be namespaced which helps to keep code organized and clean. This means that components, models, views, and controllers should be in a subdirectory structure named the same as the application.

**_Create the directories for this purpose. If your app name is "example_app", create the following directories:_**

    app/components/
    app/components/example_app/
    app/controllers/example_app/
    app/models/example_app/
    app/views/layouts/example_app/
    app/lib/example_app/
    app/db/example_app/

**_redirect application_controller to use our namespaced controller which inherits from marty._**

app/controllers/application_controller.rb: replace everything with the following 2 lines:
```ruby
	require ‘example_app/application_controller’
	ApplicationController = ExampleApp::ApplicationController
```
**_create application controller file:_**

app/controllers/example_app/application_controller.rb:
```ruby
	class ExampleApp::ApplicationController < Marty::ApplicationController
		protect_from_forgery
		layout "example_app/application"
	end
```
**_Configure routes to mount the Marty Engine in the application and include netzke routes._**

app/config/routes.rb:
```ruby
    Rails.application.routes.draw do
        …
        netzke
        mount Marty::Engine => "/example_app"
        get 'components/:component' => 'example_app/components#index', as: "components"
        get 'marty/components/:component' =>
      	        'marty/components#index', as: "marty/components"
        root 'example_app/components#home'
        …
    end
```
**_Require marty in a main application file that will always get loaded._**

lib/example_app.rb
```ruby
	require ‘marty’
```
**_Change javascript includes to point to the javascript files we will be using, via netzke._**

modify app/views/layouts/application.html.erb

	**change:** <%= javascript_include_tag %> **to:** <%= netzke_init %>

**_Add marty config lines to app/config/application.rb in the class Application < Rails::Application block:_**
```ruby
    # always load files from our lib directory.
    config.autoload_paths += %W(#{config.root}/lib)
    config.session_store :cookie_store, :key => '_example_app_session'

    # if using ldap, create the yml file for the variables below.
    ldap_yml = YAML.load_file("#{config.root}/config/ldap.yml")["ldap"]

    # marty requirements
    config.marty = ActiveSupport::OrderedOptions.new
    config.marty.roles = [:viewer,:admin,:dev,:user_manager]
    config.marty.class_list = []
    config.marty.auth_source = ‘local'
    config.marty.system_account = ‘marty’
    config.marty.local_password = 'marty'
    config.marty.autologin = 1

    # for ldap authentication
    config.marty.ldap = ActiveSupport::OrderedOptions.new
    config.marty.ldap.host      = ldap_yml["host"]
    config.marty.ldap.port      = ldap_yml["port"]
    config.marty.ldap.base_dn   = ldap_yml["base_dn"]
    config.marty.ldap.login     = ldap_yml["login"]
    config.marty.ldap.domain    = ldap_yml["domain"]
```
** Create the ldap.yml file for the network variables.
app/config/ldap.yml
```ruby
See app/config/ldap.yml.example
```
**_If you wish to use ldap authentication:_**

	**change:** config.marty.auth_source = ‘ldap’

add your first marty user in your application db/seeds.rb:
```ruby
		login = ‘ldap_username’ # your windows login name
		firstname = ‘FirstName’
		lastname = ‘LastName’
		if !Marty::User.find_by_login(login)
		user = Marty::User.new
		user.login = login
		user.firstname = firstname
		user.lastname = lastname
		user.active = true
		user.save!

		# this will give your user all roles listed in config.marty.roles listed above.
		Marty::Role.all.map { |role|
			ur = Marty::UserRole.new
			ur.user = user
			ur.role = role
			ur.save!
		}
```
**_We can now run the seeds:_**

	$ rake marty:seed
	$ rake db:seed  # if you created a Marty::User to populate in your db/seeds.rb file.

**Note:** If you are using ‘local’ auth_source, you can log into the application for the first time as the default user ‘marty’ with the password ‘marty’ (as set in the config above), and create new users as desired. You will notice that there is no password field in the Add User form. If using local authentication, a user’s password will be the same as their login name. Probably only useful for testing situations where you don’t want to hit the ldap server, but could potentially be used as a hook into other authentication services.

**_Now we need to create our controller for our application components._**

app/controllers/example_app/components_controller.rb:
```ruby
    require 'marty/permissions'
    require 'netzke/basepack/grid'
    require 'netzke/basepack/fields'
    require 'example_app/auth_app'

    class ExampleApp::ComponentsController < Marty::ComponentsController
    	def home
        	render inline: "<%= netzke :'auth_app' %>", layout: true
     	end
    end
```
Notice the last require we do for the application specific auth_app. We can use Marty’s built in auth_app, but we need to create our class to inherit from it in order to pass the namespaced class name.

**_create the auth_app:_**

app/components/example_app/auth_app.rb:
```ruby
	require 'example_app'
    require 'marty/main_auth_app'
    require 'marty/permissions'
    class ExampleApp::AuthApp < Marty::MainAuthApp
    end
    AuthApp = ExampleApp::AuthApp
```
Now when we start up the server and go to local host, you will be presented with the basic application to login.

**Making the Menus Work**

To give your application configurability without the need of editing the source code directly, we’ll create a config view.

Before adding any new models to our project, we need to tell Marty about the namespace that we’ve created. We can do this by prefixing all our application-specific tables with an application table prefix.

**_Create 2 new files that will help define our models._**

lib/example_app/migrations.rb
```ruby
require 'marty/migrations'
module ExampleApp::Migrations
	include Marty::Migrations
	def tb_prefix
	  "example_app_"
	end
end
```
*# some SQL commands to bypass McFly versioning (check your db docs for what you might need.) Useful for fixing records when you don’t want the change versioned.*

```ruby
def disable_triggers(table_name, &block)
  	begin
  	    execute("ALTER TABLE #{table_name} DISABLE TRIGGER ALL;")
  	    block.call
  	ensure
    	execute("ALTER TABLE #{table_name} ENABLE TRIGGER ALL;")
  	end
  end

def grant_view_permissions(permission, schema, view_name, role)
  	execute("GRANT #{permission} ON #{schema}.#{view_name} TO #{role};")
  end
end
```

app/models/example_app/base.rb

```ruby
class ExampleApp::Base < ActiveRecord::Base
    self.table_name_prefix = "example_app_"
    self.abstract_class = true
end
```
**_Add the migrations file to our main application require file:_**

lib/example_app.rb
```ruby
	…
	require ‘example_app/migrations’
```
This matches Marty’s table naming convention and will help to keep the schema understandable. When creating new migrations, you should include ExampleApp::Migrations in the migration file before running it. If you are adding foreign keys, use the Marty method: add_fk to properly handle the namespaced tables.

**Create the Config View**
```ruby
rails g migration create_example_app_configs key:string value:string
```
**_Require both fields and add the unique index:_**

db/migrate/{timestamp}_create_example_app_configs.rb:
```ruby
class CreateExampleAppConfigs < ActiveRecord::Migration
    def change
        create_table :example_app_configs do |t|
        t.string :key, null: false
        t.string :value, null: false
    end
    add_index :example_app_configs, :key, unique: true
end
```
**_Next define the config model class:_**

app/models/example_app/config.rb:
```ruby
class ExampleApp::Config < ExampleApp::Base
    validates_presence_of :key, :value
    validates_uniqueness_of :key
    delorean_fn :lookup, sig: 1 do
        |key|
        self[key]
    end

    def self.[]=(key, value)
        entry = find_by_key(key)
        if !entry
            entry = self.new
            entry.key = key
        end
    	entry.value = value.to_json
        entry.save!
        value
    end

    def self.[](key)
        entry = find_by_key(key)
        entry and entry.get_value
    end

    def self.del(key)
        entry = find_by_key(key)
        if entry
            result = entry.get_value
            entry.destroy
            result
        end
    end
end
```
Since Netzke will handle the view for us, we don’t need to create one. However, we should create a menu item on the main grid panel to get us there.

**_Open our main auth_app component and add the config_view to the system menu._**

app/components/example_app/auth_app.rb:
```ruby
class ExampleApp::AuthApp < Marty::MainAuthApp
    def system_menu
        res = super
        super[:menu] += [:config_view]
        res
    end

    # Then we need to create the action handler for netzke.
    action :config_view do |a|
        a.text     = ‘config’
        a.tooltip  = 'Manage system configuration'
        a.handler  = :netzke_load_component_by_action
        a.icon     = :cog
        a.disabled = !self.class.has_admin_perm?
    end
    component :config_view
end
```
**_That means we need to create the config view component too:_**

app/components/example_app/config_view.rb:
```ruby
require 'marty/panel'
class ExampleApp::ConfigView < Marty::Grid
    has_marty_permissions \
    create: :admin,
    read: :admin,
    update: :admin,
    delete: :admin

    def configure(c)
        super
        c.title   = "Config"
        c.model   = "ExampleApp::Config"
        c.columns = [:key, :value]
        c.blank_text = 'xxx'
        c.enable_extended_search = false
        c.data_store.sorters     = {property: :key, direction: 'ASC'}
    end

    column :key do |c|
        c.flex = 1
    end

    column :value do |c|
        c.flex = 3
    end
end
ConfigView = ExampleApp::ConfigView
```
To get the Postings menu working, we need to create a monkey patch to let Marty know how to map the posting type permissions.

**_create monkey patch_**

lib/example_app/monkey.rb
```ruby
require ‘marty/new_posting_form’
Marty::NewPostingForm.class_eval do
    has_marty_permissions BASE: :dev
end
```
